import { LRUCache } from 'lru-cache';
import { Constants } from '../../utils';

const imageCache = new LRUCache<string, string>({
  max: Constants.CACHE.IMAGE_MAX_ENTRIES,
  ttl: Constants.CACHE.IMAGE_TTL_MS,
});

const movieKey = (movieId: number): string => `tmdb:movie:${movieId}`;
const seriesKey = (seriesId: number): string => `tmdb:series:${seriesId}`;

export const getMoviePoster = async (movieId: number): Promise<string | undefined> =>
  imageCache.get(movieKey(movieId));

export const setMoviePoster = async (movieId: number, url: string): Promise<boolean> => {
  imageCache.set(movieKey(movieId), url);
  return true;
};

export const getSeriesPoster = async (seriesId: number): Promise<string | undefined> =>
  imageCache.get(seriesKey(seriesId));

export const setSeriesPoster = async (seriesId: number, url: string): Promise<boolean> => {
  imageCache.set(seriesKey(seriesId), url);
  return true;
};
