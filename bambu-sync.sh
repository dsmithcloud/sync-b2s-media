#!/bin/zsh

# Bambu P2S FTPS settings
PRINTER_IP="192.168.1.50"        # TODO: set your printer IP
ACCESS_CODE="YOUR_ACCESS_CODE"   # TODO: set your printer access code
REMOTE_DIR="/"                   # TODO: adjust after you inspect via lftp - use \ escape char for spaces in path
LOCAL_DIR="$HOME/bambu-timelapse"

# Create local dir if missing
mkdir -p "$LOCAL_DIR"

# Run ipcam lftp mirror
lftp -u bblp,$ACCESS_CODE -e \
  "set ssl:verify-certificate no; \
   set net:max-retries 2; \
   set net:timeout 20; \
   mirror --only-newer --verbose '${REMOTE_DIR}/ipcam' '${LOCAL_DIR}/ipcam'; \
   bye" \
  ftps://$PRINTER_IP:990

# Run timelapselftp mirror
lftp -u bblp,$ACCESS_CODE -e \
  "set ssl:verify-certificate no; \
   set net:max-retries 2; \
   set net:timeout 20; \
   mirror --only-newer --verbose '${REMOTE_DIR}/timelapse' '${LOCAL_DIR}/timelapse'; \
   bye" \
  ftps://$PRINTER_IP:990
