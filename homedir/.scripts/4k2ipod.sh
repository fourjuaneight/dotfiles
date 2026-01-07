#!/usr/bin/env bash

main() {
  local file fname escaped_file subtitle_filter hdr
  local color_transfer color_primaries color_space hdr_tin
  local sub_codec use_external sub_file
  local -a audio_args

  # Get file selection
  file="$(fd -t f -e 'mkv' -e 'mov' 2>/dev/null | gum choose)"

  if [[ -z "$file" ]]; then
    echo "No file selected."
    return 1
  fi

  # Auto-detect HDR from stream metadata.
  # Prefer transfer characteristics; fall back to BT.2020 primaries as a hint.
  color_transfer="$(ffprobe -v error -select_streams v:0 -show_entries stream=color_transfer -of default=nw=1 "$file" 2>/dev/null | awk -F= '/^color_transfer=/{print $2; exit}')"
  color_primaries="$(ffprobe -v error -select_streams v:0 -show_entries stream=color_primaries -of default=nw=1 "$file" 2>/dev/null | awk -F= '/^color_primaries=/{print $2; exit}')"
  color_space="$(ffprobe -v error -select_streams v:0 -show_entries stream=color_space -of default=nw=1 "$file" 2>/dev/null | awk -F= '/^color_space=/{print $2; exit}')"

  hdr="no"
  hdr_tin=""
  if [[ "$color_transfer" == "smpte2084" || "$color_transfer" == "arib-std-b67" ]]; then
    hdr="yes"
    hdr_tin="$color_transfer"
  elif [[ "$color_primaries" == "bt2020" ]]; then
    # Some remuxes are missing transfer tags; treat BT.2020 as a hint.
    hdr="yes"
    hdr_tin="smpte2084"
  fi

  if [[ "$hdr" == "yes" ]]; then
    echo "HDR detected (transfer=${color_transfer:-unknown}, primaries=${color_primaries:-unknown}, matrix=${color_space:-unknown})"
  else
    echo "SDR detected (transfer=${color_transfer:-unknown}, primaries=${color_primaries:-unknown}, matrix=${color_space:-unknown})"
  fi

  # Bash-safe "remove extension" (works for .mkv/.mov, and leaves name untouched if no extension)
  fname="${file%.*}"

  # Check for output file collision
  if [[ -f "${fname}.mp4" ]]; then
    echo "Error: ${fname}.mp4 already exists"
    return 1
  fi

  echo "Processing: $file"

  # Check if file has embedded subtitles, and whether they're text-based.
  # The ffmpeg `subtitles=` filter only supports text subtitle codecs.
  sub_codec="$(ffprobe -v error -select_streams s:0 -show_entries stream=codec_name -of default=nk=1:nw=1 "$file" 2>/dev/null)"

  if [[ -n "$sub_codec" ]]; then
    case "$sub_codec" in
      subrip|ass|ssa|mov_text|text|webvtt)
        # Escape the file path for the subtitles filter
        escaped_file="${file//\\/\\\\}"
        escaped_file="${escaped_file//:/\\:}"
        escaped_file="${escaped_file//\'/\\\'}"
        escaped_file="${escaped_file//\[/\\[}"
        escaped_file="${escaped_file//\]/\\]}"
        subtitle_filter="subtitles='${escaped_file}':si=0,"
        echo "Burning in embedded subtitles ($sub_codec)..."
        ;;
      *)
        echo "Embedded subtitles found ($sub_codec), but ffmpeg can only burn in text-based subtitles via the subtitles filter."
        echo "Tip: PGS/DVD subtitles need OCR/external .srt/.ass, or a different pipeline."

        use_external="$(gum choose "yes" "no" --header "Use external text subtitle file instead?")"
        if [[ $use_external == "yes" ]]; then
          sub_file="$(fd -t f -e 'srt' -e 'ass' -e 'ssa' -e 'vtt' 2>/dev/null | gum choose --header "Select subtitle file")"

          if [[ -n "$sub_file" ]]; then
            escaped_file="${sub_file//\\/\\\\}"
            escaped_file="${escaped_file//:/\\:}"
            escaped_file="${escaped_file//\'/\\\'}"
            escaped_file="${escaped_file//\[/\\[}"
            escaped_file="${escaped_file//\]/\\]}"
            subtitle_filter="subtitles='${escaped_file}',"
            echo "Using external subtitles: $sub_file"
          else
            subtitle_filter=""
            echo "No subtitle file selected, skipping..."
          fi
        else
          subtitle_filter=""
          echo "Skipping subtitles..."
        fi
        ;;
    esac
  else
    echo "No embedded subtitles found."
    use_external="$(gum choose "yes" "no" --header "Use external text subtitle file?")"

    if [[ $use_external == "yes" ]]; then
      sub_file="$(fd -t f -e 'srt' -e 'ass' -e 'ssa' -e 'vtt' 2>/dev/null | gum choose --header "Select subtitle file")"

      if [[ -n "$sub_file" ]]; then
        escaped_file="${sub_file//\\/\\\\}"
        escaped_file="${escaped_file//:/\\:}"
        escaped_file="${escaped_file//\'/\\\'}"
        escaped_file="${escaped_file//\[/\\[}"
        escaped_file="${escaped_file//\]/\\]}"
        subtitle_filter="subtitles='${escaped_file}',"
        echo "Using external subtitles: $sub_file"
      else
        subtitle_filter=""
        echo "No subtitle file selected, skipping..."
      fi
    else
      subtitle_filter=""
      echo "Skipping subtitles..."
    fi
  fi

  # Prefer libfdk_aac when available, otherwise fall back to native AAC with safer settings
  if ffmpeg -hide_banner -codecs 2>/dev/null | grep -q '\blibfdk_aac\b'; then
    audio_args=(-c:a libfdk_aac -vbr 4 -ac 2 -ar 44100 -af "aresample=resampler=soxr:osf=s16:async=1:first_pts=0")
    echo "Encoding audio with libfdk_aac (VBR 4) using high quality resampler..."
  else
    audio_args=(-c:a aac -aac_coder twoloop -b:a 192k -ac 2 -ar 44100 -af "aresample=resampler=soxr:osf=s16:async=1:first_pts=0")
    echo "libfdk_aac not available, using native AAC (twoloop @192k) with high quality resampler..."
  fi

  if [[ $hdr == "yes" ]]; then
    if ! ffmpeg -hide_banner -probesize 100000000 -analyzeduration 100000000 -fflags +genpts -i "$file" \
      -map 0:v:0 -map 0:a:0 -sn -dn \
      -map_metadata -1 -map_chapters -1 \
      -vf "${subtitle_filter}zscale=t=linear:npl=100:tin=${hdr_tin}:pin=bt2020:min=bt2020nc:rin=tv,format=gbrpf32le,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:p=bt709:r=tv,scale=640:-1,pad=iw:480:0:(oh-ih)/2,setsar=1,format=yuv420p,fps=24000/1001" \
      -c:v libx264 -crf 23 -preset fast -profile:v baseline -level 3.0 -pix_fmt yuv420p \
      -maxrate 1500k -bufsize 3000k \
      -x264-params "vbv-maxrate=1500:vbv-bufsize=3000:nal-hrd=vbr:force-cfr=1:ref=1:bframes=0:keyint=72:min-keyint=72:scenecut=0" \
      "${audio_args[@]}" \
      -fps_mode cfr \
      -movflags +faststart \
      -brand mp42 -video_track_timescale 24000 \
      -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
      -loglevel warning -stats \
      "${fname}.mp4"; then
      echo "HDR tonemapping failed; retrying as SDR..."
      hdr="no"
    fi
  fi

  if [[ $hdr == "no" ]]; then
    ffmpeg -hide_banner -probesize 100000000 -analyzeduration 100000000 -fflags +genpts -i "$file" \
      -map 0:v:0 -map 0:a:0 -sn -dn \
      -map_metadata -1 -map_chapters -1 \
      -vf "${subtitle_filter}scale=640:-1,pad=iw:480:0:(oh-ih)/2,setsar=1,format=yuv420p,fps=24000/1001" \
      -c:v libx264 -crf 23 -preset fast -profile:v baseline -level 3.0 -pix_fmt yuv420p \
      -maxrate 1500k -bufsize 3000k \
      -x264-params "vbv-maxrate=1500:vbv-bufsize=3000:nal-hrd=vbr:force-cfr=1:ref=1:bframes=0:keyint=72:min-keyint=72:scenecut=0" \
      "${audio_args[@]}" \
      -fps_mode cfr \
      -movflags +faststart \
      -brand mp42 -video_track_timescale 24000 \
      -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
      -loglevel warning -stats \
      "${fname}.mp4"
  fi
}

main "$@"