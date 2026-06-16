/**
 * @file locales.config.ts
 * @path src/config/locales.config.ts
 * @description Available languages, default locale, and fallback chain.
 * @exports LOCALES
 * @dependsOn nothing
 */

export const LOCALES = {
  DEFAULT: 'pl' as const,
  AVAILABLE: ['pl', 'en'] as const,
  FALLBACK: 'pl' as const,
  RTL: [] as const,
};

export type LocaleCode = (typeof LOCALES.AVAILABLE)[number];

export const LOCALE_NAMES: Record<LocaleCode, string> = {
  pl: 'Polski',
  en: 'English',
};

export const LOCALE_DATE_FORMATS: Record<LocaleCode, string> = {
  pl: 'dd.MM.yyyy',
  en: 'MM/dd/yyyy',
};
