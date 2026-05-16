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

export const initialize = (): void => {
  const baseURL = Environment.NTFY_BASE_URL.read();
  const token = Environment.NTFY_TOKEN.readOptional();
  client = axios.create({
    baseURL,
    timeout: 10_000,
    headers: token ? { Authorization: `Bearer ${token}` } : undefined,
  });
  logger.info({ baseURL, authenticated: !!token }, 'ntfy client initialized');
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
