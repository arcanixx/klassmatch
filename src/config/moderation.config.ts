/**
 * @file moderation.config.ts
 * @path src/config/moderation.config.ts
 * @description Moderation thresholds, blocked word lists, and confidence levels.
 * @exports MODERATION
 * @dependsOn nothing
 */

export const MODERATION = {
  // Confidence thresholds (0-1)
  AUTO_APPROVE_THRESHOLD: 0.85,     // >0.85 = auto-approve without human review
  AUTO_REJECT_THRESHOLD: 0.15,      // <0.15 = auto-reject (spam, profanity)
  HUMAN_REVIEW_RANGE: [0.15, 0.85] as [number, number], // borderline → queue

  // Rule-based filter (MVP)
  BLOCKED_WORDS_PL: [
    'chuj', 'kurwa', 'pierdolić', 'jebać', 'pizda', 'cipa', 'dupa', 'debil',
    'idiota', 'matole', 'gówno', 'szmata', 'dziwka', 'skurwiel', 'pojeb',
    'pojebań', 'skurwysyn', 'cham', 'patałach', 'kretyn', 'baran', 'burak',
  ],
  BLOCKED_WORDS_EN: [
    'fuck', 'shit', 'bitch', 'asshole', 'cunt', 'dick', 'cock', 'pussy',
    'whore', 'slut', 'bastard', 'retard', 'moron', 'idiot', 'dumbass',
    'douche', 'twat', 'wanker', 'prick', 'crap', 'damn',
  ],

  // Severity multipliers
  SEVERITY_MULTIPLIERS: {
    profanity: 0.3,
    harassment: 0.6,
    threat: 0.9,
    spam: 0.2,
    grooming: 1.0,   // always auto-reject + immediate alert
  } as const,

  // Admin review timeouts
  REVIEW_ESCALATION_HOURS: 24,      // if not reviewed in 24h, escalate
  MAX_QUEUE_AGE_DAYS: 7,            // auto-reject after 7 days unreviewed

  // Action consequences
  WARN_AFTER_REJECTIONS: 3,         // 3 rejections = warning to user
  BAN_AFTER_REJECTIONS: 5,          // 5 rejections = auto-ban from class

  // AI model (Phase 2 — open source, no user API key)
  AI_MODEL_ENDPOINT: '',            // filled when Phase 2 model is chosen
  AI_MODEL_TIMEOUT_MS: 5000,        // fallback to rule-based if >5s
} as const;

export type ModerationSeverity = keyof typeof MODERATION.SEVERITY_MULTIPLIERS;
