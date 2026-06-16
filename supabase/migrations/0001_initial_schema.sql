-- =============================================================================
-- FILE: 0001_initial_schema.sql
-- PATH: supabase/migrations/0001_initial_schema.sql
-- PURPOSE: Core MVP Phase 1 schema — profiles, classes, members, channels, messages
-- FUNCTIONS: update_updated_at_column() (created in 0002)
-- DEPENDS ON: nothing (first migration)
-- =============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -----------------------------------------------------------------------------
-- 1. PROFILES (extends auth.users)
-- -----------------------------------------------------------------------------
CREATE TABLE profiles (
  id            uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         text NOT NULL,
  display_name  text NOT NULL CHECK (char_length(display_name) BETWEEN 2 AND 50),
  avatar_url    text,
  birth_year    integer NOT NULL CHECK (birth_year BETWEEN 2005 AND 2019),
  role          text NOT NULL DEFAULT 'member'
    CHECK (role IN ('member', 'admin', 'teacher')),
  is_parent_consent_verified boolean NOT NULL DEFAULT false,
  parent_consent_email       text,
  parent_consent_verified_at timestamptz,
  settings      jsonb NOT NULL DEFAULT '{}',
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select_own" ON profiles FOR SELECT
  USING (id = auth.uid());

CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

CREATE INDEX idx_profiles_birth_year ON profiles(birth_year);
CREATE INDEX idx_profiles_role ON profiles(role);

-- -----------------------------------------------------------------------------
-- 2. CLASSES
-- -----------------------------------------------------------------------------
CREATE TABLE classes (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name          text NOT NULL CHECK (char_length(name) BETWEEN 3 AND 100),
  school_name   text NOT NULL CHECK (char_length(school_name) BETWEEN 2 AND 100),
  year          integer NOT NULL CHECK (year BETWEEN 1 AND 12),
  invite_code   text NOT NULL UNIQUE CHECK (char_length(invite_code) BETWEEN 6 AND 20),
  created_by    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  is_archived   boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE classes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "classes_select_member" ON classes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = classes.id
        AND class_members.profile_id = auth.uid()
        AND class_members.status = 'approved'
    )
    OR created_by = auth.uid()
  );

CREATE POLICY "classes_insert_admin" ON classes FOR INSERT
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "classes_update_admin" ON classes FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = classes.id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
    OR created_by = auth.uid()
  );

CREATE INDEX idx_classes_invite_code ON classes(invite_code);
CREATE INDEX idx_classes_created_by ON classes(created_by);

-- -----------------------------------------------------------------------------
-- 3. CLASS_MEMBERS
-- -----------------------------------------------------------------------------
CREATE TABLE class_members (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id      uuid NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  profile_id    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role          text NOT NULL DEFAULT 'member'
    CHECK (role IN ('member', 'admin')),
  status        text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected', 'banned')),
  invited_by    uuid REFERENCES profiles(id) ON DELETE SET NULL,
  joined_at     timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (class_id, profile_id)
);

ALTER TABLE class_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "class_members_select_own" ON class_members FOR SELECT
  USING (
    profile_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM class_members AS cm
      WHERE cm.class_id = class_members.class_id
        AND cm.profile_id = auth.uid()
        AND cm.role = 'admin'
        AND cm.status = 'approved'
    )
  );

CREATE POLICY "class_members_insert_admin" ON class_members FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM class_members AS cm
      WHERE cm.class_id = class_members.class_id
        AND cm.profile_id = auth.uid()
        AND cm.role = 'admin'
        AND cm.status = 'approved'
    )
  );

CREATE POLICY "class_members_update_admin" ON class_members FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM class_members AS cm
      WHERE cm.class_id = class_members.class_id
        AND cm.profile_id = auth.uid()
        AND cm.role = 'admin'
        AND cm.status = 'approved'
    )
  );

CREATE INDEX idx_class_members_class ON class_members(class_id, status);
CREATE INDEX idx_class_members_profile ON class_members(profile_id, status);

-- -----------------------------------------------------------------------------
-- 4. CHANNELS
-- -----------------------------------------------------------------------------
CREATE TABLE channels (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id      uuid NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  name          text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 50),
  description   text CHECK (char_length(description) <= 200),
  is_default    boolean NOT NULL DEFAULT false,
  sort_order    integer NOT NULL DEFAULT 0,
  created_by    uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE channels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "channels_select_member" ON channels FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = channels.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.status = 'approved'
    )
  );

CREATE POLICY "channels_insert_admin" ON channels FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = channels.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
  );

CREATE POLICY "channels_update_admin" ON channels FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM class_members
      WHERE class_members.class_id = channels.class_id
        AND class_members.profile_id = auth.uid()
        AND class_members.role = 'admin'
        AND class_members.status = 'approved'
    )
  );

CREATE INDEX idx_channels_class ON channels(class_id, sort_order);

-- -----------------------------------------------------------------------------
-- 5. MESSAGES
-- -----------------------------------------------------------------------------
CREATE TABLE messages (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id        uuid REFERENCES channels(id) ON DELETE CASCADE,
  dm_id             uuid,  -- future: for DMs (Phase 2), nullable for now
  sender_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content           text NOT NULL CHECK (char_length(content) BETWEEN 1 AND 2000),
  content_plain     text,  -- stripped of formatting for search/moderation
  moderation_status text NOT NULL DEFAULT 'pending'
    CHECK (moderation_status IN ('pending', 'approved', 'rejected', 'trimmed')),
  moderation_reason text,
  moderated_by      uuid REFERENCES profiles(id) ON DELETE SET NULL,
  moderated_at      timestamptz,
  parent_id         uuid REFERENCES messages(id) ON DELETE CASCADE,  -- threads (Phase 2)
  is_pinned         boolean NOT NULL DEFAULT false,
  deleted_at        timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT message_target_check CHECK (
    (channel_id IS NOT NULL AND dm_id IS NULL) OR
    (dm_id IS NOT NULL AND channel_id IS NULL)
  )
);

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "messages_select_member" ON messages FOR SELECT
  USING (
    deleted_at IS NULL
    AND (
      EXISTS (
        SELECT 1 FROM class_members
        JOIN channels ON channels.class_id = class_members.class_id
        WHERE channels.id = messages.channel_id
          AND class_members.profile_id = auth.uid()
          AND class_members.status = 'approved'
      )
      OR sender_id = auth.uid()
    )
  );

CREATE POLICY "messages_insert_own" ON messages FOR INSERT
  WITH CHECK (sender_id = auth.uid());

CREATE POLICY "messages_update_own" ON messages FOR UPDATE
  USING (
    sender_id = auth.uid()
    AND deleted_at IS NULL
  );

CREATE POLICY "messages_soft_delete_own" ON messages FOR DELETE
  USING (sender_id = auth.uid());

CREATE INDEX idx_messages_channel ON messages(channel_id, created_at DESC)
  WHERE deleted_at IS NULL;
CREATE INDEX idx_messages_sender ON messages(sender_id, created_at DESC);
CREATE INDEX idx_messages_moderation ON messages(moderation_status, created_at)
  WHERE moderation_status IN ('pending', 'rejected') AND deleted_at IS NULL;
