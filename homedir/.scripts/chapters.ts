interface ChapterData {
  id: number;
  time_base: string;
  start: number;
  start_time: string;
  end: number;
  end_time: string;
  tags: {
    title: string;
  };
}

const msToTime = (value: number): string => {
  const pad = (n: number, z: number) => {
    z = z || 2;
    return ("00" + n).slice(-z);
  };

  let newValue = value;
  const ms = newValue % 3600;
  newValue = (newValue - ms) / 3600;
  const secs = newValue % 60;
  newValue = (newValue - secs) / 60;
  const mins = newValue % 60;
  const hrs = (newValue - mins) / 60;

  return `${pad(hrs)}:${pad(mins)}:${pad(secs)}.${pad(ms, 3)}`;
};

const secToTime = (value: number): string => {
  let hours = Math.floor(value / 3600);
  let minutes = Math.floor((value - hours * 3600) / 60);
  let seconds = value - hours * 3600 - minutes * 60;

  if (hours < 10) {
    hours = "0" + hours;
  }
  if (minutes < 10) {
    minutes = "0" + minutes;
  }
  if (seconds < 10) {
    seconds = "0" + seconds;
  }

  return `${hours}:${minutes}:${seconds}`;
};

const handleErr = async (proc, method: string) => {
  const rawError = await proc.stderrOutput();
  const errorString = new TextDecoder().decode(rawError);

  throw `[${method}]: ${errorString}`;
};

const ffmpeg = async (
  file: string,
  name: string,
  metadata: ChapterData
): Promise<void> => {
  try {
    const start_time: number = parseFloat(metadata.start_time);
    const end_time: number = parseFloat(metadata.end_time);
    const start: string = secToTime(start_time);
    const end: string = secToTime(end_time);
    const output = `${name}-${metadata.id + 1}.mp3`;

    console.info(`[ffmpeg]: Converting ${output} from ${start} to ${end}...`);

    const cmd = [
      "ffmpeg",
      "-i",
      `"${file}"`,
      "-ss",
      start,
      "-to",
      end,
      "-codec:a",
      "copy",
      "-ar",
      "22050",
      "-ab",
      "64k",
      "-metadata",
      `track="${metadata.tags.title}"`,
      `"${output}"`,
    ];
    const proc = Deno.run({ cmd, stderr: "piped" });

    await proc.status();
    await handleErr(proc, "ffmpeg");
  } catch (error) {
    throw `${error}`;
  }
};

const id3v2 = async (name: string, metadata: ChapterData): Promise<void> => {
  try {
    const file = `${name}-${metadata.id + 1}.mp3`;

    console.info(`[id3v2]: Renaming ${file}...`);

    const cmd = ["id3v2", "--song", `"${metadata.tags.title}"`, `"${file}"`];
    const proc = Deno.run({ cmd, stderr: "piped" });

    await proc.status();
    await handleErr(proc, "id3v2");
  } catch (error) {
    throw `${error}`;
  }
};

(async () => {
  try {
    const input = Deno.args;
    const name = input[0].replace(/(.*)\.(mp3|m4b)/g, "$1");
    const metadata = await Deno.readTextFile("./chapters.json", "utf8");
    const chapters: ChapterData[] = JSON.parse(metadata);

    for (const chapter of chapters) {
      await ffmpeg(input[0], name, chapter);
      await id3v2(name, chapter);
    }
  } catch (error) {
    console.error(error);
    Deno.exit(1);
  }
})();
