import axios, { AxiosInstance } from 'axios';
import { Environment, Logger, Notifications } from '../../utils';

const logger = Logger.child({ module: 'ntfy' });
let client: AxiosInstance | undefined;

interface PublishBody {
  topic: string;
  title: string;
  message: string;
  priority?: number;
  attach?: string;
  icon?: string;
  click?: string;
  tags?: string[];
}

type AuthMode = 'none' | 'token' | 'basic';

export const initialize = (): void => {
  const baseURL = Environment.NTFY_BASE_URL.read();
  const token = Environment.NTFY_TOKEN.readOptional();
  const username = Environment.NTFY_USERNAME.readOptional();
  const password = Environment.NTFY_PASSWORD.readOptional();

  let mode: AuthMode = 'none';
  const config: Parameters<typeof axios.create>[0] = {
    baseURL,
    timeout: 10_000,
  };

  if (token) {
    mode = 'token';
    config.headers = { Authorization: `Bearer ${token}` };
  } else if (username && password) {
    mode = 'basic';
    config.auth = { username, password };
  } else if (username || password) {
    logger.warn('Only one of NTFY_USERNAME / NTFY_PASSWORD is set; basic auth disabled');
  }

  client = axios.create(config);
  logger.info({ baseURL, auth: mode }, 'ntfy client initialized');
};

export const publish = async (
  topic: string,
  payload: Notifications.Payload,
  settings: Notifications.Settings,
): Promise<boolean> => {
  if (!client) {
    logger.error('ntfy client not initialized');
    return false;
  }

  const body: PublishBody = {
    topic,
    title: payload.title,
    message: payload.body,
    priority: Notifications.toNtfyPriority(settings),
  };

  if (payload.image) {
    body.attach = payload.image;
    body.icon = payload.image;
  }
  const click = Notifications.buildClickUrl(payload);
  if (click) body.click = click;

  try {
    const response = await client.post('/', body);
    logger.debug({ topic, status: response.status }, 'Published notification');
    return response.status >= 200 && response.status < 300;
  } catch (error: unknown) {
    if (axios.isAxiosError(error)) {
      logger.error(
        { topic, status: error.response?.status, body: error.response?.data, message: error.message },
        'Failed to publish to ntfy',
      );
    } else {
      logger.error({ topic, error }, 'Unexpected error publishing to ntfy');
    }
    return false;
  }
};
