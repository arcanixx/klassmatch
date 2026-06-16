-- =============================================================================
-- FILE: 0004_notifications_devices.sql
-- PATH: supabase/migrations/0004_notifications_devices.sql
-- PURPOSE: Push notifications and trusted device management
-- DEPENDS ON: 0001_initial_schema.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- DEVICES (trusted device model + push tokens)
-- -----------------------------------------------------------------------------
CREATE TABLE devices (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  device_name   text NOT NULL CHECK (char_length(device_name) BETWEEN 1 AND 100),
  device_id     text NOT NULL UNIQUE,  -- expo-device deviceId or custom
  platform      text NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  is_trusted    boolean NOT NULL DEFAULT false,
  push_token    text,
  last_seen_at  timestamptz NOT NULL DEFAULT now(),
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (profile_id, device_id)
);

ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "devices_select_own" ON devices FOR SELECT
  USING (profile_id = auth.uid());

CREATE POLICY "devices_insert_own" ON devices FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "devices_update_own" ON devices FOR UPDATE
  USING (profile_id = auth.uid())
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "devices_delete_own" ON devices FOR DELETE
  USING (profile_id = auth.uid());

CREATE INDEX idx_devices_profile ON devices(profile_id, is_trusted);
CREATE INDEX idx_devices_push ON devices(push_token) WHERE push_token IS NOT NULL;

CREATE TRIGGER devices_updated_at
  BEFORE UPDATE ON devices
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- NOTIFICATIONS (in-app notification center + push tracking)
-- -----------------------------------------------------------------------------
CREATE TABLE notifications (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  class_id      uuid REFERENCES classes(id) ON DELETE CASCADE,
  channel_id    uuid REFERENCES channels(id) ON DELETE SET NULL,
  message_id    uuid REFERENCES messages(id) ON DELETE SET NULL,
  type          text NOT NULL CHECK (type IN ('message', 'moderation', 'invite', 'reminder', 'system')),
  title         text NOT NULL,
  body          text,
  is_read       boolean NOT NULL DEFAULT false,
  read_at       timestamptz,
  action_url    text,  -- deep link path, e.g. /class/[id]/channel/[id]
  created_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notifications_select_own" ON notifications FOR SELECT
  USING (profile_id = auth.uid());

CREATE POLICY "notifications_update_own" ON notifications FOR UPDATE
  USING (profile_id = auth.uid())
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "notifications_delete_own" ON notifications FOR DELETE
  USING (profile_id = auth.uid());

CREATE INDEX idx_notifications_profile ON notifications(profile_id, is_read, created_at DESC);
CREATE INDEX idx_notifications_class ON notifications(class_id, created_at DESC);
