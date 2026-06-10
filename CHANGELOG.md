# Changelog — KlassMate

Format: [Keep a Changelog](https://keepachangelog.com/pl/1.0.0/) · [Semantic Versioning](https://semver.org/)

> **Dla AI:** Nowe wpisy dodawaj NA GÓRZE sekcji `[Unreleased]`. Przed release przenieś do nowej sekcji.

---

## [Unreleased]

### Added
- (tu wpisuj nowe funkcje)

### Fixed
- (tu wpisuj naprawione bugi)

---

## [0.1.0-alpha] — 2026-06-10

Pierwsza wersja alpha — kompletna dokumentacja projektowa + szkielet projektu.

### Added — Dokumentacja (`docs/`)
- `00_PROJECT_OVERVIEW.md` — założenia, stack, analiza rynku, pytania do właściciela
- `01_ARCHITECTURE.md` — schema DB (PostgreSQL/Supabase), struktura plików, przepływy danych
- `01b_ARCHITECTURE_SUPPLEMENT.md` — sortowanie, modały aplikacyjne, rozszerzony model logowania błędów
- `02_CODE_STANDARDS.md` — nagłówki plików, nazewnictwo, TypeScript, wzorce
- `03_AI_RULES.md` — zasady dla modeli AI: ZAWSZE/NIGDY, checklista przed PR
- `04_SECURITY.md` — biometria (Face ID/Fingerprint), sesje, 2FA, screenshot prevention
- `05_LEGAL_COMPLIANCE.md` — RODO, zgoda rodziców <16 lat, prawa autorskie, DSA
- `06_FEATURES_SPEC.md` — help system, onboarding, toast messages, UX flows, OCR, DM, backup
- `07_TESTING_AND_DEBUG.md` — strategia testów, debug panel, mock system, seed data, Sentry
- `08_ROADMAP_AND_MONETISATION.md` — fazy, RevenueCat, freemium 1.99 PLN, AdMob child-safe
- `09_NOTIFICATIONS_AND_REMINDERS.md` — push, in-app, reminder CRON, permission flow, Android channels
- `10_SESSION_AND_STATE.md` — Zustand design, offline mode, optymistyczne aktualizacje, paginacja
- `CODE_REVIEW_CHECKLIST.md` — 102-punktowy przegląd przed mergem
- `AUDIT_CHECKLIST.md` — 86-punktowy audyt przed release
- `UI_UX_MOCKUP.html` — interaktywny mockup HTML (8 ekranów, dark mode, modały, toasty)
- `GRAPHICS_PLAN.md` — plan grafik P0/P1/P2, prompty AI, fallbacki SVG

### Added — Logi przykładowe (`logs/`)
- `2026-06-10_code_review_feat-auth-biometrics.md` — przykładowy wypełniony raport CR
- `2026-06-10_audit_sprint1_pre-beta.md` — przykładowy wypełniony raport audytu

### Added — Szkielet projektu
- Pełna struktura katalogów `src/`, `supabase/`, `__tests__/`, `assets/`
- `package.json` — zależności (Expo 52, Supabase, Zustand, i18next, Sentry)
- `tsconfig.json` — strict mode, path aliases `@/*`
- `app.config.ts` — Expo dynamic config (iOS/Android/Web, biometria, powiadomienia)
- `src/i18n/pl.json` + `src/i18n/en.json` — kompletne tłumaczenia (130+ kluczy)
- `.env.example` — wszystkie zmienne środowiskowe z opisami
- `.github/workflows/ci.yml` — GitHub Actions: typecheck, testy, Deno, audit, i18n parity
- `SECURITY.md` — polityka zgłaszania podatności bezpieczeństwa

### Decisions
- Stack: React Native + Expo SDK 52 · Supabase Frankfurt · TypeScript strict · Zustand · NativeWind
- OCR: Tesseract.js (offline) + OCR.space fallback — zero kluczy API dla użytkownika
- Moderacja: server-side Edge Function — przed zapisem do DB, klient nie jest zaufany
- Biometria: `expo-local-authentication` + `expo-secure-store` — tokeny w Keychain/Keystore
- Modały: wyłącznie własny komponent — zero `window.alert/confirm/prompt`
- Offline: optimistic updates + SecureStore queue, auto-flush po reconnect
- Monetyzacja: RevenueCat + AdMob child-directed NPA — faza 3
