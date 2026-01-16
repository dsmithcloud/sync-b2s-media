# sync-b2s-media

Sync media from a Bambu P2S 3D Printer USB stick to a directory of your choosing using FTPS.

## Overview

This repository contains a simple shell script that automatically downloads timelapse videos and other media files from your Bambu P2S 3D printer's USB storage to your local machine. The script uses FTPS (FTP over SSL) to securely connect to the printer and mirror files using `lftp`.

## Features

- 🔄 **Automatic sync**: Downloads only newer files to avoid unnecessary transfers
- 🔒 **Secure connection**: Uses FTPS for encrypted file transfers
- 📁 **Configurable paths**: Customize both remote and local directory locations
- ⚡ **Efficient mirroring**: Only transfers files that are new or updated
- 🛡️ **Error handling**: Built-in retry logic and timeout settings

## Requirements

- macOS or Linux with zsh shell
- `lftp` command-line tool
- Network access to your Bambu P2S printer
- Printer access code

### Installing lftp

**macOS (using Homebrew):**
```bash
brew install lftp
```

**Ubuntu/Debian:**
```bash
sudo apt-get install lftp
```

**CentOS/RHEL:**
```bash
sudo yum install lftp
```

## Setup

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/sync-b2s-media.git
   cd sync-b2s-media
   ```

2. **Make the script executable:**
   ```bash
   chmod +x bambu-sync.sh
   ```

3. **Configure the script:**
   Edit the `bambu-sync.sh` file and update the following variables:

   ```bash
   PRINTER_IP="192.168.1.50"        # Your printer's IP address
   ACCESS_CODE="YOUR_ACCESS_CODE"   # Your printer's access code
   REMOTE_DIR="/usb/timelapse"      # Remote directory path on printer
   LOCAL_DIR="$HOME/bambu-timelapse" # Local directory for downloaded files
   ```

### Finding Your Printer's IP and Access Code

1. **IP Address**: Check your router's admin panel or use network scanning tools to find your printer's IP
2. **Access Code**: This can be found in your printer's settings or generated through the Bambu Studio/Handy app

### Exploring Remote Directories

Before setting up automated sync, you may want to explore the available directories on your printer:

```bash
lftp -u "bblp,YOUR_ACCESS_CODE" -e "
  set ssl:verify-certificate no;
  ls;
  bye
" "ftps://YOUR_PRINTER_IP:990"
```

## Usage

### Manual Sync

Run the script manually to sync files:

```bash
./bambu-sync.sh
```

### Automated Sync

Set up a cron job to run the sync automatically. Edit your crontab:

```bash
crontab -e
```

Add a line to run the sync every hour:
```bash
0 * * * * /path/to/sync-b2s-media/bambu-sync.sh
```

Or every 30 minutes:
```bash
*/30 * * * * /path/to/sync-b2s-media/bambu-sync.sh
```

## Configuration Options

The script includes several `lftp` settings that can be customized:

- `ssl:verify-certificate no`: Disables SSL certificate verification (needed for printer's self-signed cert)
- `net:max-retries 2`: Maximum number of retry attempts for failed connections
- `net:timeout 20`: Connection timeout in seconds
- `mirror --only-newer`: Only downloads files that are newer than local copies
- `--verbose`: Enables verbose output for debugging

## Troubleshooting

### Connection Issues
- Verify printer IP address and access code
- Ensure printer is on the same network
- Check firewall settings

### SSL Certificate Errors
The script disables SSL certificate verification due to the printer using a self-signed certificate. This is normal for local network devices.

### File Permission Issues
Make sure the local directory has proper write permissions:
```bash
chmod 755 /path/to/your/local/directory
```

### Debugging
Run `lftp` manually to test connection and explore directories:
```bash
lftp -u "bblp,YOUR_ACCESS_CODE" ftps://YOUR_PRINTER_IP:990
```

## File Structure

```
sync-b2s-media/
├── bambu-sync.sh    # Main sync script
├── README.md        # This documentation
└── LICENSE          # GPL v3 license
```

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this tool.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is not officially supported by Bambu Lab. Use at your own risk and always ensure you have proper backups of important files.
