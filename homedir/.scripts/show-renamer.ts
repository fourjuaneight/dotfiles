// deno-lint-ignore-file
import "https://deno.land/x/dotenv/load.ts";
import { parse } from "https://deno.land/std@0.115.1/flags/mod.ts";

interface TVShow {
  _id: string;
  air_date: string;
  episodes: EpisodesEntity[];
  name: string;
  overview: string;
  id: number;
  poster_path: string;
  season_number: number;
}

interface EpisodesEntity {
  air_date: string;
  episode_number: number;
  crew?: CrewEntity[] | null;
  guest_stars?: GuestStarsEntity[] | null;
  id: number;
  name: string;
  overview: string;
  production_code: string;
  season_number: number;
  still_path: string;
  vote_average: number;
  vote_count: number;
}

interface CrewEntity {
  department: string;
  job: string;
  credit_id: string;
  adult: boolean;
  gender: number;
  id: number;
  known_for_department: string;
  name: string;
  original_name: string;
  popularity: number;
  profile_path?: string | null;
}

interface GuestStarsEntity {
  character: string;
  credit_id: string;
  order: number;
  adult: boolean;
  gender: number;
  id: number;
  known_for_department: string;
  name: string;
  original_name: string;
  popularity: number;
  profile_path?: string | null;
}

interface EpisodeNames {
  name: string;
  currentFilename: string;
  newFilename: string;
}

const cwd = Deno.cwd();
const key = Deno.env.get("TMDB_KEY");
const args = parse(Deno.args);

// get formatted episode names
const episodeName = (data: TVShow, showName: string): EpisodeNames[] =>
  data.episodes.map((episode) => {
    // clean names with parts
    const cleanPart = episode.name.replace(/Part\s([0-9]+):\s/g, "Part $1 - ");
    // replace spaces with dashes
    const name = episode.name
      .replace(/\sPart\s([0-9]+):\s/g, "-Part_$1-")
      .replace(/\s/g, "_");
    // add zero to single digit season/episode numbers
    const addZero = (num: number): string => (num < 10 ? `0${num}` : `${num}`);
    // generate new filename
    const file = `${showName}-S${addZero(data.season_number)}-E${addZero(
      episode.episode_number
    )}-`;

    return {
      name: cleanPart,
      currentFilename: `${file}.mkv`,
      newFilename: `${file}${name}.mkv`,
    };
  });
// rename file with episode name
const renameFile = async (episode: EpisodeNames): Promise<void> => {
  console.info("[mv]:", `${episode.currentFilename} -> ${episode.newFilename}`);

  const renameFiles = Deno.run({
    cmd: [
      "mv",
      `${cwd}/${episode.currentFilename}`,
      `${cwd}/${episode.newFilename}`,
    ],
  });

  try {
    await renameFiles.status();
  } catch (error) {
    throw new Error(`mv: ${error}`);
  }
};
// add media title to filename
const mediaTitle = async (episode: EpisodeNames): Promise<void> => {
  console.info("[mkvpropedit]:", `title = ${episode.name}`);

  const addTitle = Deno.run({
    cmd: [
      "mkvpropedit",
      `${cwd}/${episode.newFilename}`,
      "-e",
      "info",
      "-s",
      `title=${episode.name}`,
    ],
  });

  try {
    await addTitle.status();
  } catch (error) {
    throw new Error(`mkvpropedit: ${error}`);
  }
};

(async () => {
  try {
    switch (true) {
      case !args.showName:
        throw new Error("Please provide a show name");
      case !args.showID:
        throw new Error("Please provide a show ID");
      case !args.season:
        throw new Error("Please provide a season number");
      case !key:
        throw new Error("Please provide a TMDB API key");
      default:
        break;
    }

    // get TMDB data for show
    const request = await fetch(
      `https://api.themoviedb.org/3/tv/${args.showID}/season/${args.season}?api_key=${key}&language=en-US`
    );
    const data: TVShow = await request.json();
    // get episode names
    const episodeNames = episodeName(data, args.showName);

    for (const episode of episodeNames) {
      await renameFile(episode);
      await mediaTitle(episode);
    }
  } catch (error) {
    console.error(error);
  }
})();
