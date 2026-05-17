import { Logger } from './logger';
const logger = Logger.child({ module: 'environment' });

interface _Options {
  fallback?: string;
  redacted?: boolean;
  optional?: boolean;
}

class _Var {
  constructor(private name: string, private options?: _Options) {
    const hasValue = process.env[this.name] !== undefined && process.env[this.name] !== '';
    const hasFallback = this.options?.fallback !== undefined;
    if (hasValue || hasFallback) {
      logger.debug({ key: this.name, value: this.options?.redacted ? '[REDACTED]' : this.read() });
    } else if (this.options?.optional) {
      logger.debug({ key: this.name }, 'Optional env var not set');
    } else {
      logger.fatal({ key: this.name }, 'Unable to find environment value. Exiting...');
      process.exit(1);
    }
  }

  public read = (): string => process.env[this.name] ?? this.options?.fallback ?? '';
  public readOptional = (): string | undefined =>
    process.env[this.name] || this.options?.fallback || undefined;
}

// ntfy
export const NTFY_BASE_URL = new _Var('NTFY_BASE_URL');
// Auth for publishing. Prefer NTFY_TOKEN (access token); fall back to
// NTFY_USERNAME + NTFY_PASSWORD (basic auth) if no token is set.
export const NTFY_TOKEN = new _Var('NTFY_TOKEN', { redacted: true, optional: true });
export const NTFY_USERNAME = new _Var('NTFY_USERNAME', { optional: true });
export const NTFY_PASSWORD = new _Var('NTFY_PASSWORD', { redacted: true, optional: true });
// Optional ingress auth (defense-in-depth on top of topic-as-secret)
export const WEBHOOK_TOKEN = new _Var('WEBHOOK_TOKEN', { redacted: true, optional: true });
// External API keys
export const FANART_TV_API_KEY = new _Var('FANART_TV_API_KEY', { redacted: true });
export const THEMOVIEDB_API_KEY = new _Var('THEMOVIEDB_API_KEY', { redacted: true });
// Server
export const PORT = new _Var('PORT', { fallback: '9000' });
