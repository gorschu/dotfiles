#!/bin/bash
STATUS_FILE="/var/lib/resticprofile/status.json"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ ! -f "$STATUS_FILE" ]; then
  echo -e "${GREEN} Not yet${NC}"
  exit 0
fi

SUCCESS_COUNT=$(jq -r '.profiles | to_entries[] | select(.value.backup.success == true) | .key' "$STATUS_FILE" 2>/dev/null | wc -l)
FAILED_PROFILES=$(jq -r '.profiles | to_entries[] | select(.value.backup.success == false) | .key' "$STATUS_FILE" 2>/dev/null | paste -sd ',' -)
FAILED_COUNT=$([ -n "$FAILED_PROFILES" ] && echo "$FAILED_PROFILES" | tr ',' '\n' | wc -l || echo 0)

if [ "$SUCCESS_COUNT" -eq 0 ] && [ "$FAILED_COUNT" -eq 0 ]; then
  echo -e "${GREEN}󰂠 Idle${NC}"
elif [ "$FAILED_COUNT" -gt 0 ]; then
  echo -e "${RED} $FAILED_PROFILES ($FAILED_COUNT failed)${NC}"
else
  # Get the most recent successful backup time
  LAST_SUCCESS=$(jq -r '.profiles | to_entries[] | select(.value.backup.success == true) | .value.backup.time' "$STATUS_FILE" 2>/dev/null | sort -r | head -1)

  if [ -n "$LAST_SUCCESS" ]; then
    LAST_TIME=$(date -d "$LAST_SUCCESS" +%s 2>/dev/null)
    NOW=$(date +%s)
    DIFF=$((NOW - LAST_TIME))

    if [ "$DIFF" -lt 3600 ]; then
      echo -e "${GREEN} Fresh${NC}"
    elif [ "$DIFF" -lt 86400 ]; then
      HOURS=$((DIFF / 3600))
      echo -e "${GREEN}󰅐 ${HOURS}h ago${NC}"
    else
      DAYS=$((DIFF / 86400))
      echo -e "${GREEN}󰅐 ${DAYS}d ago${NC}"
    fi
  else
    echo -e "${GREEN} OK${NC}"
  fi
fi
