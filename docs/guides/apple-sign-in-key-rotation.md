# Apple Sign In — Key Rotation

The Apple OAuth client secret is a JWT that expires every 6 months (180 days). This guide covers regenerating it.

## Current Setup

| Item | Value |
|---|---|
| Bundle ID | `com.kanjicraft.app` |
| Service ID | `com.kanjicraft.app.sid` |
| Key ID | Found in Apple Developer > Keys |
| Team ID | Found in Apple Developer > Membership (top right) |
| Key file | `AuthKey_XXXXXXXXXX.p8` (stored locally, never committed) |

## When to Rotate

- **Current secret generated:** Feb 7, 2026
- **Expires:** ~Aug 6, 2026
- **Regenerate by:** early July 2026

## Steps

### 1. Generate a new secret

```bash
./scripts/apple_client_secret.sh \
    --key-id YOUR_KEY_ID \
    --team-id YOUR_TEAM_ID \
    --key-file path/to/AuthKey_XXXXXXXXXX.p8
```

This outputs a JWT string.

### 2. Update Supabase

**Local dev:**

Paste the new JWT into `supabase/.env`:

```
SUPABASE_AUTH_EXTERNAL_APPLE_SECRET=eyJhbG...
```

Restart local Supabase: `supabase stop && supabase start`

**Production:**

Go to Supabase Dashboard > Authentication > Providers > Apple, and paste the new secret.

### 3. Verify

Sign out of the app and sign back in with Apple. If it works, the new secret is active.

### 4. Update this doc

Update "Current secret generated" and "Expires" dates above so next rotation is easy.

## Notes

- The `.p8` key file itself does not expire — only the JWT secret derived from it does.
- If you lose the `.p8` file, create a new key in Apple Developer > Keys and update the Key ID everywhere.
- The script uses zero dependencies (bash + openssl).
