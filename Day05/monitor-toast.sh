
---

### ✅ `monitor-toast.sh`

```bash
#!/bin/bash

declare -A URLS=(
  ["Web - Ubihrm Portal"]="https://accounts.ubihrm.com"
  ["App - GetInfo API"]="https://ubiattendanceapi.ubiattendance.com/getInfo?uid=2141411&refid=149007&platform=ubiAttendance_Android"
  ["Web - getInfo"]="https://i3zjpmhbry.ap-south-1.awsapprunner.com/getInfo?uid==AFVxIkVWZ1RltWMWVVb4VVWWB3VVpmQCZlRWlVUtVTV&refid=UtmSxV1aaNlUspFWT1GeXJ1aKVVVB1TP"
  ["Web - getAnonymousPermission"]="https://i3zjpmhbry.ap-south-1.awsapprunner.com/dashboard/getAnonymousPermission?userProfileId=VdlUzZVRaNVTVFjdT1WNXJ1aKVVVB1TP&orgId=UtmSxV1aaNlUspFWT1GeXJ1aKVVVB1TP"
  ["Web - getAllTabIds"]="https://i3zjpmhbry.ap-south-1.awsapprunner.com/dashboard/getAllTabIds?userProfileId=VdlUzZVRaNVTVFjdT1WNXJ1aKVVVB1TP&orgId=UtmSxV1aaNlUspFWT1GeXJ1aKVVVB1TP"
  ["Web - settingPermissions"]="https://i3zjpmhbry.ap-south-1.awsapprunner.com/dashboard/settingPermissions?userProfileId=VdlUzZVRaNVTVFjdT1WNXJ1aKVVVB1TP&orgId=UtmSxV1aaNlUspFWT1GeXJ1aKVVVB1TP"
  ["App - getAllPermission"]="https://ubiattendanceapi.ubiattendance.com/getAllPermission?organizationId=149007&employeeId=2085673&userprofileid=19187"
)

LOG_FILE="$HOME/url_monitor.log"

send_windows_notification() {
    local TITLE=$1
    local MSG=$2

    # Escape for PowerShell
    local ESCAPED_MSG=$(echo "$MSG" | sed 's/`/``/g; s/"/``"/g' | sed ':a;N;$!ba;s/\n/`n/g')

    powershell.exe -Command "
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = 'WindowsRuntime'] > \$null
\$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
\$xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(\$template)
\$texts = \$xml.GetElementsByTagName('text')
\$texts.Item(0).AppendChild(\$xml.CreateTextNode(\"$TITLE\")) > \$null
\$texts.Item(1).AppendChild(\$xml.CreateTextNode(\"$ESCAPED_MSG\")) > \$null
\$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
\$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('WSL')
\$notifier.Show(\$toast)"
}

check_all_urls() {
    local TIMESTAMP=$(TZ="Asia/Kolkata" date '+%Y-%m-%d %H:%M:%S %Z')
    local LOG_MSG="$TIMESTAMP"
    local POPUP_MSG=""
    local i=1
    local FAILED=()

    for NAME in "${!URLS[@]}"; do
        local URL="${URLS[$NAME]}"
        local STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL")

        if [[ "$STATUS" -eq 200 ]]; then
            LOG_MSG+="\n$i. $NAME is ✅ UP"
            POPUP_MSG+="$i. $NAME is ✅ UP"$'\n'
        else
            LOG_MSG+="\n$i. $NAME is ❌ DOWN (Status: $STATUS)"
            POPUP_MSG+="$i. $NAME is ❌ DOWN (Status: $STATUS)"$'\n'
            FAILED+=("$NAME")
        fi
        ((i++))
    done

    if (( ${#FAILED[@]} )); then
        POPUP_MSG+="⚠️ Issues: ${FAILED[*]}"
        send_windows_notification "❌ Some URLs are DOWN" "$POPUP_MSG"
    else
        send_windows_notification "✅ All URLs are UP" "$POPUP_MSG"
    fi

    LOG_MSG+="\n"
    tmpfile=$(mktemp)
    cat "$LOG_FILE" > "$tmpfile"
    echo -e "$LOG_MSG" >> "$tmpfile"

    # Keep only last 20 log blocks
    awk '
    BEGIN { RS=""; ORS="\n\n" }
    {
      blocks[NR] = $0
    }
    END {
      start = NR-19 > 0 ? NR-19 : 1
      for(i=start;i<=NR;i++) print blocks[i]
    }
    ' "$tmpfile" > "$LOG_FILE"

    rm "$tmpfile"
}

# Run the check
check_all_urls
