export interface Payload {
  title: string;
  body: string;
  image?: string;
  data?: {
    [key: string]: string;
  };
}

export interface Settings {
  sound: boolean;
  ios: {
    interruptionLevel: iOSInterruptionLevel;
  };
}

export enum iOSInterruptionLevel {
  PASSIVE = 'passive',
  ACTIVE = 'active',
  TIME_SENSITIVE = 'time-sensitive',
}

// ntfy uses integer priorities 1..5; map LunaSea's iOS interruption levels
// onto that range. `sound=false` forces minimum priority (no sound, no vibration).
export const toNtfyPriority = (settings: Settings): number => {
  if (!settings.sound) return 1; // min
  switch (settings.ios.interruptionLevel) {
    case iOSInterruptionLevel.PASSIVE:
      return 2; // low
    case iOSInterruptionLevel.TIME_SENSITIVE:
      return 4; // high
    case iOSInterruptionLevel.ACTIVE:
    default:
      return 3; // default
  }
};

export const generateTitle = (module: string, profile: string, body: string): string => {
  if (profile && profile !== 'default') return `${module} (${profile}): ${body}`;
  return `${module}: ${body}`;
};

/**
 * Build a deeplink for the LunaSea app to handle when a notification is tapped.
 * Returns a URL on the `lunasea://` custom scheme; the app needs to register
 * it as an intent/universal link to act on this. Returns undefined when the
 * payload has no actionable data.
 */
export const buildClickUrl = (payload: Payload): string | undefined => {
  const data = payload.data;
  if (!data || !data.module) return undefined;
  const query = new URLSearchParams();
  for (const key of Object.keys(data)) {
    if (key === 'module') continue;
    query.set(key, data[key]);
  }
  const qs = query.toString();
  return qs ? `lunasea://${data.module}?${qs}` : `lunasea://${data.module}`;
};
