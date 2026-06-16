-- =============================================================================
-- FILE: 0006_error_reports.sql
-- PATH: supabase/migrations/0006_error_reports.sql
-- PURPOSE: Privacy-preserving error reports for author debugging
-- DEPENDS ON: 0001_initial_schema.sql
-- NOTE: Only Edge Functions (service role) can write. No user SELECT access.
-- =============================================================================

CREATE TABLE error_reports (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  app_version   text NOT NULL,
  platform      text NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  error_code    text NOT NULL,
  error_message text NOT NULL,
  stack_trace   text,
  context       jsonb,  -- BEZ PII: only codes, states, flags
  user_hash     text,   -- SHA-256(user_id) — irreversible
  session_actions jsonb,  -- last 10 user actions (breadcrumbs, no message content)
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE error_reports ENABLE ROW LEVEL SECURITY;

-- Explicitly deny all user access — only service role (Edge Functions) can write
CREATE POLICY "error_reports_no_user_access" ON error_reports FOR ALL
  USING (false);

CREATE INDEX idx_error_reports_code ON error_reports(error_code, created_at DESC);
CREATE INDEX idx_error_reports_version ON error_reports(app_version, created_at DESC);
