/**
 * @file limits.config.ts
 * @path src/config/limits.config.ts
 * @description Numeric limits, quotas, and timeouts used across the app.
 * @exports LIMITS
 * @dependsOn nothing
 */

export const LIMITS = {
  // Messages
  MESSAGE_MAX_LENGTH: 2000,           // characters
  MESSAGE_BATCH_SIZE: 50,             // messages per query
  MESSAGE_SEARCH_LIMIT: 100,          // max results

  // Voice (Phase 2)
  VOICE_MAX_DURATION_FREE: 60,        // seconds
  VOICE_MAX_DURATION_PREMIUM: 300,    // seconds

  // Attachments (Phase 2)
  ATTACHMENT_MAX_SIZE_FREE: 5 * 1024 * 1024,      // 5 MB
  ATTACHMENT_MAX_SIZE_PREMIUM: 20 * 1024 * 1024,  // 20 MB
  OCR_IMAGE_MAX_SIZE: 3 * 1024 * 1024,             // 3 MB (OCR.space free tier)

  // Storage
  CLASS_STORAGE_FREE: 200 * 1024 * 1024,          // 200 MB
  CLASS_STORAGE_PREMIUM: 2 * 1024 * 1024 * 1024, // 2 GB

  // Classes / Channels
  MAX_CLASSES_FREE: 5,
  MAX_CLASSES_PREMIUM: 20,
  MAX_CHANNELS_PER_CLASS_FREE: 10,
  MAX_CHANNELS_PER_CLASS_PREMIUM: 50,
  MAX_CLASS_MEMBERS: 50,              // hard limit regardless of tier

  // Auth & Session
  SESSION_TIMEOUT_UNTRUSTED: 4 * 60 * 60 * 1000,  // 4 hours in ms
  SESSION_TIMEOUT_TRUSTED: 30 * 24 * 60 * 60 * 1000, // 30 days in ms
  MAX_TRUSTED_DEVICES: 5,
  PIN_ATTEMPTS_BEFORE_LOCKOUT: 5,
  PIN_LOCKOUT_DURATION_MS: 15 * 60 * 1000,        // 15 minutes

  // Moderation
  MODERATION_QUEUE_MAX_SIZE: 100,   // per class
  MODERATION_BATCH_SIZE: 20,        // items per admin review screen
  REPORT_COOLDOWN_HOURS: 24,        // between reports of same user

  // Notifications
  NOTIFICATION_BATCH_SIZE: 50,      // in-app notification list
  MAX_UNREAD_BADGE: 99,             // "99+"
  QUIET_HOURS_START: 22,            // 22:00
  QUIET_HOURS_END: 7,             // 07:00

  // UI / Data
  IN_APP_LOG_MAX_ENTRIES: 100,      // FIFO rotation in SecureStore
  BREADCRUMB_MAX_COUNT: 10,         // per error report
  OFFLINE_QUEUE_MAX_SIZE: 100,      // messages
  PIN_CODE_LENGTH: 4,               // digits
} as const;
