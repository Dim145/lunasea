import express from 'express';
import { Models } from './';
import { Constants, Environment, Logger, Notifications } from '../utils';

const logger = Logger.child({ module: 'middleware' });

export async function startNewRequest(
  request: express.Request,
  response: express.Response,
  next: express.NextFunction,
): Promise<void> {
  logger.info({ url: request.url, method: request.method });
  next();
}

export async function checkWebhookAuth(
  request: express.Request,
  response: express.Response,
  next: express.NextFunction,
): Promise<void> {
  const expected = Environment.WEBHOOK_TOKEN.readOptional();
  if (!expected) {
    next();
    return;
  }
  const header = request.headers.authorization;
  if (header === `Bearer ${expected}`) {
    next();
    return;
  }
  logger.warn({ url: request.url }, 'Rejected webhook with bad or missing Authorization header');
  response.status(401).json(<Models.Response>{ message: Constants.MESSAGE.UNAUTHORIZED });
}

export async function extractTopic(
  request: express.Request<{ topic: string }>,
  response: express.Response,
  next: express.NextFunction,
): Promise<void> {
  const topic = request.params.topic;
  if (!topic) {
    response.status(400).json(<Models.Response>{ message: Constants.MESSAGE.NO_TOPIC_SUPPLIED });
    return;
  }
  response.locals.topic = topic;
  response.locals.profile = (request.query.profile as string | undefined) ?? 'default';
  logger.debug({ topic, profile: response.locals.profile });
  next();
}

export async function extractNotificationOptions(
  request: express.Request,
  response: express.Response,
  next: express.NextFunction,
): Promise<void> {
  const getSound = (sound: unknown): boolean => sound !== 'false';

  const getInterruptionLevel = (level: unknown): Notifications.iOSInterruptionLevel => {
    const valid = Object.values(Notifications.iOSInterruptionLevel) as string[];
    if (typeof level === 'string' && valid.includes(level)) {
      return level as Notifications.iOSInterruptionLevel;
    }
    return Notifications.iOSInterruptionLevel.ACTIVE;
  };

  response.locals.notificationSettings = <Notifications.Settings>{
    sound: getSound(request.query.sound),
    ios: {
      interruptionLevel: getInterruptionLevel(request.query.interruption_level),
    },
  };
  logger.debug(response.locals.notificationSettings);
  next();
}
