# KlassMate — Documentation Index

> **Repository:** `klassmatch`  
> **Product:** KlassMate — safe, moderated, student-to-student homework info sharing  
> **Target market:** Poland/EU, ages 10–19  
> **Docs version:** 0.1.0-unified  
> **Last updated:** 2025-06-11

---

## 📚 Document Map

| # | Document | Purpose | Priority |
|---|----------|---------|----------|
| **00** | [PROJECT_OVERVIEW](00_PROJECT_OVERVIEW.md) | Master assumptions, goals, tech stack, open questions | 🔴 Read first |
| **01** | [ARCHITECTURE](01_ARCHITECTURE.md) | Database schema, RLS, Edge Functions, file structure | 🔴 Read first |
| **01b** | [ARCHITECTURE_SUPPLEMENT](01b_ARCHITECTURE_SUPPLEMENT.md) | Sorting, reminders, modals, in-app logs, error reporting | 🔴 Read first |
| **02** | [CODE_STANDARDS](02_CODE_STANDARDS.md) | TypeScript rules, file headers, i18n, commit conventions | 🟡 Before coding |
| **03** | [AI_RULES](03_AI_RULES.md) | Hard prohibitions and mandatory practices for AI assistants | 🟡 Before coding |
| **04** | [SECURITY](04_SECURITY.md) | Biometrics, session trust, 2FA, screenshot prevention | 🟡 Before coding |
| **05** | [LEGAL_COMPLIANCE](05_LEGAL_COMPLIANCE.md) | RODO/GDPR, parental consent, DSA, copyright | 🟡 Before launch |
| **06** | [FEATURES_SPEC](06_FEATURES_SPEC.md) | UX flows, help system, messaging, moderation UI | 🟢 Reference |
| **07** | [TESTING_STRATEGY](07_TESTING_STRATEGY.md) | Test layers, debug panel, mock system, CI/CD | 🟢 Reference |
| **08** | [ROADMAP_AND_MONETISATION](08_ROADMAP_AND_MONETISATION.md) | Phased delivery, pricing, growth strategy | 🟢 Reference |
| **09** | [NOTIFICATIONS_AND_REMINDERS](09_NOTIFICATIONS_AND_REMINDERS.md) | Push notifications, in-app center, reminders | 🟢 Reference |
| **10** | [SESSION_AND_STATE](10_SESSION_AND_STATE.md) | Zustand stores, offline mode, optimistic updates | 🟢 Reference |
| **11** | [USER_STORIES](11_USER_STORIES.md) | 15 user stories with P0/P1/P2 acceptance criteria | 🟢 Reference |
| **12** | [MVP_SCOPE](12_MVP_SCOPE.md) | Explicit IN/OUT scope, anti-scope-creep checklist | 🟢 Reference |
| **13** | [API_CONTRACT](13_API_CONTRACT.md) | Zod schemas for all 10 Edge Functions, rate limits | 🟢 Reference |
| **14** | [RISK_REGISTER](14_RISK_REGISTER.md) | 15 risks with probability × impact scoring | 🟢 Reference |
| **15** | [COMPETITIVE_ANALYSIS](15_COMPETITIVE_ANALYSIS.md) | Direct/indirect competitor matrix, SWOT, positioning | 🟢 Reference |
| **16** | [ANALYTICS_PLAN](16_ANALYTICS_PLAN.md) | Privacy-first analytics, 40+ events, North Star = WAC | 🟢 Reference |
| **17** | [DATA_SEED](17_DATA_SEED.md) | Faker-based deterministic seeding, dev/test guards | 🟢 Reference |

---

## 🗂️ Document Dependencies

```
00_PROJECT_OVERVIEW
    ├── 01_ARCHITECTURE
    │   ├── 01b_ARCHITECTURE_SUPPLEMENT
    │   ├── 04_SECURITY
    │   ├── 06_FEATURES_SPEC
    │   ├── 09_NOTIFICATIONS_AND_REMINDERS
    │   ├── 10_SESSION_AND_STATE
    │   ├── 13_API_CONTRACT
    │   └── 17_DATA_SEED
    ├── 02_CODE_STANDARDS
    │   └── 03_AI_RULES
    ├── 05_LEGAL_COMPLIANCE
    ├── 07_TESTING_STRATEGY
    ├── 08_ROADMAP_AND_MONETISATION
    │   ├── 15_COMPETITIVE_ANALYSIS
    │   └── 16_ANALYTICS_PLAN
    ├── 11_USER_STORIES
    │   └── 12_MVP_SCOPE
    └── 14_RISK_REGISTER
```

---

## 🎯 Quick Start for New Team Members

1. **Read 00 + 01 + 01b** — Understand what we're building, how it's architected, and the supplementary patterns (sorting, modals, logging)
2. **Read 02 + 03** — Understand how to write code and what AI assistants must follow
3. **Read 12 (MVP_SCOPE)** — Know what's in Phase 1 and what's explicitly out
4. **Reference 06 + 11** — When implementing specific features
5. **Check 14 (RISK_REGISTER)** — Before making architectural decisions

---

## 🔧 Key Decisions Documented

| Decision | Document | Section |
|----------|----------|---------|
| Tech stack (Expo 52, Supabase Frankfurt) | 00_PROJECT_OVERVIEW | §5 |
| No external API keys for users | 00_PROJECT_OVERVIEW | §5 (OCR strategy) |
| Three-layer auth model | 04_SECURITY | §1 |
| Parental consent via email link (MVP) | 05_LEGAL_COMPLIANCE | §3 |
| Rule-based profanity filter (MVP), AI later | 00_PROJECT_OVERVIEW | §5 |
| DM = text/voice only, no images | 06_FEATURES_SPEC | §5 |
| Free tier with ads, Premium 1.99 PLN/mo | 08_ROADMAP_AND_MONETISATION | §3 |
| Privacy-first analytics (no third-party trackers) | 16_ANALYTICS_PLAN | §1 |
| Zod schemas for all API contracts | 13_API_CONTRACT | §2 |

---

## ⚠️ Critical Open Questions (from 00_PROJECT_OVERVIEW)

These **must** be answered before writing code:

1. **App name final decision** — "KlassMate" vs "KlassMatch" (affects bundle ID, domain)
2. **Parental consent mechanism** — Email link (A) / Parent account (B) / Admin vouch (C)
3. **Who can be Class Admin** — Any student (A) / Only teacher (B) / Student+teacher approval (C)
4. **Screenshot prevention** — Best-effort or hard requirement?
5. **Voice messages only** — Confirm: no live conversation recording in MVP?

---

## 🐛 Known Issues Fixed in This Unified Docs Version

| Issue | Original Location | Fix |
|-------|-------------------|-----|
| SQL `message_target_check` allowed both `channel_id` AND `dm_id` non-null | 01_ARCHITECTURE.md §2 | Changed to XOR: `(channel_id IS NOT NULL AND dm_id IS NULL) OR (dm_id IS NOT NULL AND channel_id IS NULL)` |
| Missing `updated_at` triggers | 01_ARCHITECTURE.md §2 | Added `update_updated_at_column()` function + triggers for all tables with `updated_at` |

---

## ⚠️ Missing Config Files (Must Create Before Development)

The following config files are referenced throughout the documentation but do not yet exist in the repository:

| File | Referenced In | Purpose |
|------|---------------|---------|
| `src/config/features.config.ts` | 01_ARCHITECTURE.md §8, 03_AI_RULES.md, 07_TESTING_STRATEGY.md | Feature flags, debug toggles, rollout gates |
| `src/config/limits.config.ts` | 01_ARCHITECTURE.md §8 | File size limits, voice duration, storage quotas |
| `src/config/locales.config.ts` | 01_ARCHITECTURE.md §8 | Available languages, default/fallback locale |
| `src/config/moderation.config.ts` | 01_ARCHITECTURE.md §5 | Confidence thresholds, blocked word list reference |

**Action:** Create these files before writing any feature code. See 01_ARCHITECTURE.md §8 for full schema.

---

## 📦 Missing Dependencies (Must Add to package.json)

The following dependencies are referenced in the documentation but not yet in `package.json`:

| Package | Type | Referenced In | Purpose |
|---------|------|---------------|---------|
| `zod` | dependencies | 13_API_CONTRACT.md | API input/output validation for all Edge Functions |
| `supabase` | devDependencies | 01_ARCHITECTURE.md, 17_DATA_SEED.md | CLI for migrations, local dev, type generation |
| `@faker-js/faker` | devDependencies | 17_DATA_SEED.md | Deterministic test data seeding |

**Action:** Add these before the first sprint. See individual documents for version constraints.

---

## 📝 Changelog

| Date | Version | Change |
|------|---------|--------|
| 2025-06-11 | 0.1.0-unified | Merged Project (00–10 + 01b) + ProjectKM (00–10 + 01b + 11–17) into unified docs/ folder. Fixed SQL XOR bug. Added updated_at triggers. Added 01b_ARCHITECTURE_SUPPLEMENT.md. |

---

*For questions or updates to this documentation set, refer to the individual documents above. Each document has a header block with its purpose, path, and dependencies.*
