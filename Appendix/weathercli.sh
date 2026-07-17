#!/usr/bin/env bash
set -euo pipefail

# Resolución de config: variable de entorno > archivo por defecto > valores fijos
CONFIG_FILE="${WEATHERCLI_CONFIG:-$HOME/.config/weathercli/config.json}"

if [[ -f "$CONFIG_FILE" ]]; then
  CITY=$(jq -r '.city // empty' "$CONFIG_FILE")
  UNITS=$(jq -r '.units // "metric"' "$CONFIG_FILE")
  FORMAT=$(jq -r '.format // "compact"' "$CONFIG_FILE")
else
  CITY=""
  UNITS="metric"
  FORMAT="compact"
fi

# Replace spaces with underscores
CITY="${CITY// /_}"

case "$UNITS" in
  imperial) UNIT_FLAG="u" ;;
  *) UNIT_FLAG="m" ;;
esac

URL="https://wttr.in/${CITY}?${UNIT_FLAG}"
if [[ "$FORMAT" == "compact" ]]; then
  URL="${URL}&format=%l:+%c+%t"
fi

echo $URL

curl -fsS "$URL"

echo " "