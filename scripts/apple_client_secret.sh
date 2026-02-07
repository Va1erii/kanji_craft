#!/bin/bash
#
# Generate an Apple OAuth client secret (JWT) from a .p8 private key.
# Zero dependencies — uses only openssl and base64 (both ship with macOS).
#
# Usage:
#   ./scripts/apple_client_secret.sh \
#       --key-id XXXXXXXXXX \
#       --team-id YOUR_TEAM_ID \
#       --client-id com.kanjicraft.app \
#       --key-file path/to/AuthKey_XXXXXXXXXX.p8

set -euo pipefail

KEY_ID=""
TEAM_ID=""
CLIENT_ID="com.kanjicraft.app"
KEY_FILE=""
EXPIRY_DAYS=180

while [[ $# -gt 0 ]]; do
    case $1 in
        --key-id)    KEY_ID="$2"; shift 2 ;;
        --team-id)   TEAM_ID="$2"; shift 2 ;;
        --client-id) CLIENT_ID="$2"; shift 2 ;;
        --key-file)  KEY_FILE="$2"; shift 2 ;;
        --expiry-days) EXPIRY_DAYS="$2"; shift 2 ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$KEY_ID" || -z "$TEAM_ID" || -z "$KEY_FILE" ]]; then
    echo "Usage: $0 --key-id KEY_ID --team-id TEAM_ID --key-file PATH [--client-id ID] [--expiry-days N]" >&2
    exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
    echo "Error: key file not found: $KEY_FILE" >&2
    exit 1
fi

b64url() {
    openssl base64 -e -A | tr '+/' '-_' | tr -d '='
}

NOW=$(date +%s)
EXP=$((NOW + EXPIRY_DAYS * 86400))

HEADER=$(printf '{"alg":"ES256","kid":"%s","typ":"JWT"}' "$KEY_ID" | b64url)
PAYLOAD=$(printf '{"iss":"%s","iat":%d,"exp":%d,"aud":"https://appleid.apple.com","sub":"%s"}' \
    "$TEAM_ID" "$NOW" "$EXP" "$CLIENT_ID" | b64url)

SIGNATURE=$(printf '%s.%s' "$HEADER" "$PAYLOAD" | \
    openssl dgst -sha256 -sign "$KEY_FILE" -binary | b64url)

printf '%s.%s.%s\n' "$HEADER" "$PAYLOAD" "$SIGNATURE"
