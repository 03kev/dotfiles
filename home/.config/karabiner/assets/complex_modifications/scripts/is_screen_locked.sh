#!/bin/bash
if python3 -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); print(d)' | grep "CGSSessionScreenIsLocked = 1" > /dev/null; then
    exit 0
else
    exit 1
fi

#"shell_command": "if /Users/kevinmuka/.config/karabiner/assets/complex_modifications/is_screen_locked.sh; then exit 0; else sleep 0.2 && pmset sleepnow; fi"