-- =============================================================================
-- FILE: 0003_moderation_and_audit.sql
-- PATH: supabase/migrations/0003_moderation_and_audit.sql
-- PURPOSE: Moderation queue and audit log for human-in-the-loop + accountability
-- DEPENDS ON: 0001_initial_schema.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- MODERATION_QUEUE
-- -----------------------------------------------------------------------------
CREATE TABLE moderation_queue (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id    uuid NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
  class_id      uuid NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  channel_id    uuid NOT NULL REFERENCES channels(id) ON DELETE CASCADE,
  sender_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content       text NOT NULL,
  ai_confidence numeric(4,3) CHECK (ai_confidence BETWEEN 0 AND 1),
  ai_reason     text,
  status        text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected', 'trimmed', 'escalated')),
  reviewed_by   uuid REFERENCES profiles(id) ON DELETE SET NULL,
  reviewed_at   timestamptz,
  action_taken  text CHECK (action_taken IN ('approve', 'reject', 'trim', 'escalate')),
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE moderation_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "moderation_queue_select_admin" ON moderation_queue FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = moderation_queue.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
  );

CREATE POLICY "moderation_queue_update_admin" ON moderation_queue FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = moderation_queue.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
  );

CREATE INDEX idx_moderation_queue_class ON moderation_queue(class_id, status, created_at);
CREATE INDEX idx_moderation_queue_sender ON moderation_queue(sender_id, status);

CREATE TRIGGER moderation_queue_updated_at
  BEFORE UPDATE ON moderation_queue
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- AUDIT_LOG (append-only, never UPDATE or DELETE)
-- -----------------------------------------------------------------------------
CREATE TABLE audit_log (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  class_id      uuid REFERENCES classes(id) ON DELETE SET NULL,
  action        text NOT NULL CHECK (char_length(action) BETWEEN 1 AND 50),
  target_type   text NOT NULL CHECK (target_type IN ('message', 'class', 'channel', 'member', 'user')),
  target_id     uuid,
  details       jsonb NOT NULL DEFAULT '{}',
  ip_hash       text,  -- SHA-256 of IP, never raw IP
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "audit_log_select_admin" ON audit_log FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = audit_log.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
    OR actor_id = auth.uid()
  );

CREATE INDEX idx_audit_log_class ON audit_log(class_id, created_at DESC);
CREATE INDEX idx_audit_log_actor ON audit_log(actor_id, created_at DESC);

-- Prevent UPDATE/DELETE at database level via trigger
CREATE OR REPLACE FUNCTION prevent_audit_log_mutation()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'audit_log is append-only: UPDATE and DELETE are forbidden';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_log_no_update
  BEFORE UPDATE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION prevent_audit_log_mutation();

CREATE TRIGGER audit_log_no_delete
  BEFORE DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION prevent_audit_log_mutation();
