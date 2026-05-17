export const MESSAGE = {
  INTERNAL_SERVER_ERROR: 'Internal Server Error',
  NO_TOPIC_SUPPLIED: 'No topic supplied',
  UNAUTHORIZED: 'Unauthorized',
  OK: 'OK',
};

export const CACHE = {
  // 7 days for image lookups; topics for tmdb/fanart don't change
  IMAGE_TTL_MS: 7 * 24 * 60 * 60 * 1000,
  IMAGE_MAX_ENTRIES: 5000,
};

export const THE_MOVIE_DB = {
  API: {
    BASE_URL: 'https://api.themoviedb.org/3/',
  },
  IMAGE: {
    BASE_URL: 'https://image.tmdb.org/t/p/',
    SIZE: 'w780',
  },
};
