#!/bin/zsh

###
# CONFIG – EDIT THESE
###
PRINTER_IP="192.168.1.50"        # Your P2S IP
ACCESS_CODE="YOUR_ACCESS_CODE"   # Your printer access code
REMOTE_DIR="/usb/timelapse"      # Remote timelapse folder on the printer
LOCAL_DIR="$HOME/bambu-timelapse"
USER_NAME="$USER"                # Or hardcode, e.g. "alex"
LABEL="com.${USER_NAME}.bambu-timelapse"
PLIST_PATH="$HOME/Library/LaunchAgents/${LABEL}.plist"
SCRIPT_PATH="$HOME/scripts/bambu-sync.sh"
LOG_DIR="$HOME/Library/Logs"
LOG_OUT="$LOG_DIR/bambu-timelapse.log"
LOG_ERR="$LOG_DIR/bambu-timelapse.err"

echo "Creating sync script at: $SCRIPT_PATH"
mkdir -p "$(dirname "$SCRIPT_PATH")"
cat > "$SCRIPT_PATH" <<EOF
#!/bin/zsh

PRINTER_IP="$PRINTER_IP"
ACCESS_CODE="$ACCESS_CODE"
REMOTE_DIR="$REMOTE_DIR"
LOCAL_DIR="$LOCAL_DIR"

mkdir -p "\$LOCAL_DIR"

lftp -u "bblp,\$ACCESS_CODE" -e "
  set ssl:verify-certificate no;
  set net:max-retries 2;
  set net:timeout 20;
  mirror --only-newer --verbose \"\$REMOTE_DIR\" \"\$LOCAL_DIR\";
  bye
" "ftps://\$PRINTER_IP:990"
EOF

chmod +x "$SCRIPT_PATH"

echo "Creating launchd plist at: $PLIST_PATH"
mkdir -p "$(dirname "$PLIST_PATH")"
mkdir -p "$LOG_DIR"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>

  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>${SCRIPT_PATH}</string>
  </array>

  <key>StartInterval</key>
  <integer>900</integer>

  <key>RunAtLoad</key>
  <true/>

  <key>StandardOutPath</key>
  <string>${LOG_OUT}</string>

  <key>StandardErrorPath</key>
  <string>${LOG_ERR}</string>
</dict>
</plist>
EOF

echo "Loading launchd job: ${LABEL}"
launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl load "$PLIST_PATH"

echo "Done. Job '${LABEL}' is loaded and will run every 900 seconds."
echo "Test run with: $SCRIPT_PATH"
