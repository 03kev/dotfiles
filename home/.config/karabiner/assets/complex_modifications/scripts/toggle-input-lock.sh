#!/bin/zsh

set -e

ACTION="${1:-toggle}"

HS_CLI="/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs"
LOG_FILE="/tmp/input-lock-debug.log"

{
  echo "=============================="
  echo "date: $(date)"
  echo "action: $ACTION"

  case "$ACTION" in
    toggle)
      echo "auth: sudo -v"
      sudo -v

      echo "calling Hammerspoon: toggleInputLock"
      "$HS_CLI" -c 'if toggleInputLock then toggleInputLock() else print("toggleInputLock is nil") end'
      ;;

    unlock_no_auth)
      echo "calling Hammerspoon: disableInputLock without auth"
      "$HS_CLI" -c 'if disableInputLock then disableInputLock() else print("disableInputLock is nil") end'
      ;;

    *)
      echo "Unknown action: $ACTION"
      exit 1
      ;;
  esac

  echo "done"
} >> "$LOG_FILE" 2>&1
