-- Rename real_debrid_key to debrid_token if it exists
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_settings' AND column_name = 'real_debrid_key'
  ) THEN
    ALTER TABLE "user_settings" RENAME COLUMN "real_debrid_key" TO "debrid_token";
  END IF;
END $$;

-- Add debrid_token column if it doesn't exist (in case it was never created)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_settings' AND column_name = 'debrid_token'
  ) THEN
    ALTER TABLE "user_settings" ADD COLUMN "debrid_token" VARCHAR(255);
  END IF;
END $$;

-- Add debrid_service field if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'user_settings' AND column_name = 'debrid_service'
  ) THEN
    ALTER TABLE "user_settings" ADD COLUMN "debrid_service" VARCHAR(255);
  END IF;
END $$;

-- Set default service to 'realdebrid' for existing users who have a token
UPDATE "user_settings" SET "debrid_service" = 'realdebrid' WHERE "debrid_token" IS NOT NULL AND "debrid_service" IS NULL;
