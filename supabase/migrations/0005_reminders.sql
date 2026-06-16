-- =============================================================================
-- FILE: 0005_reminders.sql
-- PATH: supabase/migrations/0005_reminders.sql
-- PURPOSE: User reminders with push notification scheduling
-- DEPENDS ON: 0001_initial_schema.sql, 0004_notifications_devices.sql
-- =============================================================================

CREATE TABLE reminders (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  class_id      uuid REFERENCES classes(id) ON DELETE CASCADE,
  channel_id    uuid REFERENCES channels(id) ON DELETE SET NULL,
  thread_id     uuid,  -- Phase 2
  title         text NOT NULL CHECK (char_length(title) BETWEEN 1 AND 200),
  note          text,
  remind_at     timestamptz NOT NULL,
  is_sent       boolean NOT NULL DEFAULT false,
  is_dismissed  boolean NOT NULL DEFAULT false,
  repeat_type   text DEFAULT 'none'
    CHECK (repeat_type IN ('none', 'daily', 'weekly')),
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE reminders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "reminders_owner_only" ON reminders FOR ALL
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE INDEX idx_reminders_remind_at ON reminders(remind_at)
  WHERE is_sent = false AND is_dismissed = false;

CREATE INDEX idx_reminders_owner ON reminders(owner_id, remind_at)
  WHERE is_sent = false AND is_dismissed = false;
