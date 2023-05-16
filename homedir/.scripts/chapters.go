package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"regexp"
)

type ChapterData struct {
	ID         int
	TimeBase   string
	Start      int
	Start_Time string
	End        int
	End_Time   string
	Tags       struct {
		Title string
	}
}

type Chapter struct {
	Chapters []ChapterData `json:"chapters"`
}

func existsSync(path string) bool {
	_, err := os.Stat(path)
	if os.IsNotExist(err) {
		return false
	}
	return err == nil
}

func secToTime(ms int) string {
	seconds := ms / 1000
	milliseconds := ms % 1000
	hours := seconds / 3600
	minutes := (seconds % 3600) / 60
	remainingSeconds := seconds % 60

	return fmt.Sprintf("%02d:%02d:%02d.%03d", hours, minutes, remainingSeconds, milliseconds)
}

func removeFileExtension(filename string) string {
	re := regexp.MustCompile(`(.*)\.(mp3|m4b)`)
	return re.ReplaceAllString(filename, "$1")
}

func handleOutput(proc *exec.Cmd, method string) error {
	var stdout, stderr bytes.Buffer
	proc.Stdout = &stdout
	proc.Stderr = &stderr

	err := proc.Run()
	if err != nil {
		return fmt.Errorf("[%s]: %v", method, err)
	}

	exitCode := proc.ProcessState.ExitCode()
	if exitCode == 0 {
		io.Copy(os.Stdout, &stdout)
	} else {
		errorString := stderr.String()
		return fmt.Errorf("[%s]: %s", method, errorString)
	}

	return nil
}

func chapters(file string) (*Chapter, error) {
	ffprobeCmd := exec.Command("ffprobe", "-v", "quiet", "-print_format", "json", "-show_format", "-show_chapters", file)
	ffprobeOutput, err := ffprobeCmd.Output()
	if err != nil {
		return nil, err
	}

	var chapterData Chapter
	err = json.Unmarshal(ffprobeOutput, &chapterData)
	if err != nil {
		return nil, err
	}

	return &chapterData, nil
}

func ffmpeg(file string, name string, metadata ChapterData) error {
	start := secToTime(metadata.Start)
	end := secToTime(metadata.End)
	output := fmt.Sprintf("%s-%d.mp3", name, metadata.ID+1)

	cmd := exec.Command(
		"ffmpeg",
		"-i", file,
		"-ss", start,
		"-to", end,
		"-acodec", "libmp3lame",
		"-ar", "22050",
		"-ab", "64k",
		"-metadata", fmt.Sprintf(`track="%s"`, metadata.Tags.Title),
		"-max_muxing_queue_size", "9999",
		output,
	)

	if existsSync(output) {
		fmt.Printf("[ffmpeg]: %s already exists.\n", output)
	} else {
		fmt.Printf("[ffmpeg]: Converting %s from %s to %s...\n", output, start, end)

		err := handleOutput(cmd, "ffmpeg")
		if err != nil {
			return err
		}
	}

	return nil
}

func id3v2(name string, metadata ChapterData) error {
	file := fmt.Sprintf("%s-%d.mp3", name, metadata.ID+1)

	fmt.Printf("[id3v2]: Renaming %s...\n", file)

	cmd := exec.Command("id3v2", "--song", fmt.Sprintf("\"%s\"", metadata.Tags.Title), file)

	err := handleOutput(cmd, "id3v2")
	if err != nil {
		return err
	}

	return nil
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Please provide a file name as an argument.")
		os.Exit(1)
	}

	file := os.Args[1]
	name := removeFileExtension(file)
	chapters, err := chapters(file)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	for _, chapter := range chapters.Chapters {
		ffmpeg(file, name, chapter)
		id3v2(name, chapter)
	}
}
