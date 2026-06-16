/**
 * @file features.config.ts
 * @path src/config/features.config.ts
 * @description Feature flags, debug toggles, and gradual rollout gates.
 * @exports FEATURES
 * @dependsOn nothing
 */

export const FEATURES = {
  // Dev / debug
  DEBUG_PANEL: __DEV__ && process.env.EXPO_PUBLIC_DEBUG_MODE === 'true',
  MOCK_MODERATION: __DEV__ && process.env.EXPO_PUBLIC_MOCK_MODERATION === 'true',
  MOCK_PUSH: __DEV__ && process.env.EXPO_PUBLIC_MOCK_PUSH === 'true',

  // Gradual rollout flags
  NOTES_MODULE: false,         // Phase 2
  VOICE_MESSAGES: false,       // Phase 2
  DM_MESSAGES: false,            // Phase 2
  IMAGE_ATTACHMENTS: false,      // Phase 2
  THREADS: false,                // Phase 2
  BACKUP_GDRIVE: false,          // Phase 2
  BACKUP_ICLOUD: false,          // Phase 2
  PREMIUM_SUBSCRIPTIONS: false,  // Phase 3
  ADMOB_ADS: false,              // Phase 3
  SCHOOL_PLAN: false,            // Phase 3

  // Safety
  SCREENSHOT_PREVENTION: true,   // Best-effort (Android FLAG_SECURE, iOS detection)
  BIOMETRICS: true,              // Face ID / Touch ID / fingerprint
  TWO_FACTOR_ADMIN: true,        // 2FA required for class admins
  PARENTAL_CONSENT: true,        // Age gate + consent flow for <16

  // Analytics
  ANALYTICS_ENABLED: true,       // Privacy-first, no third-party trackers
  SENTRY_ENABLED: !__DEV__,       // Error tracking in production only
} as const;

export type FeatureFlag = keyof typeof FEATURES;
