# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.x (alpha) | ✅ Active development |

## Reporting a Vulnerability

Jeśli odkryłeś podatność bezpieczeństwa w KlassMate, **nie twórz publicznego Issue na GitHubie**.

### Kontakt

Wyślij szczegółowy opis na: **security@klassmatch.pl**

Postaramy się odpowiedzieć w ciągu **72 godzin**.

### Co uwzględnić w zgłoszeniu

- Opis podatności i potencjalny wpływ
- Kroki do reprodukcji (proof of concept)
- Wersja aplikacji / commit hash
- Czy dotyczy danych użytkowników (szczególnie dzieci)

### Co się dzieje po zgłoszeniu

1. Potwierdzamy odbiór w ciągu 72h
2. Oceniamy wpływ i priorytet
3. Pracujemy nad poprawką
4. Informujemy Cię o postępach
5. Po wdrożeniu poprawki możemy publicznie wspomnieć o Twoim odkryciu (za Twoją zgodą)

### Zakres

Szczególnie interesują nas podatności dotyczące:
- Dostępu do danych innych użytkowników (naruszenie RLS)
- Ominięcia moderacji treści
- Uwierzytelnienia i zarządzania sesjami
- Danych dzieci (RODO / COPPA)
- Wstrzyknięcia danych (SQL injection, XSS)

### Zakres wykluczony

- Ataki wymagające fizycznego dostępu do urządzenia
- Podatności w zależnościach już zgłoszone do ich autorów
- Problemy UX nie związane z bezpieczeństwem

---

Dziękujemy za pomoc w utrzymaniu bezpieczeństwa KlassMate — aplikacji używanej przez dzieci i młodzież.
