# How to Schedule `monitor.sh` Script with Cron

This guide explains how to use **cron** to run your `monitor.sh` script automatically at regular intervals.

---

## Step 1: Make sure your script is executable

```bash
chmod +x /full/path/to/monitor.sh
``` 
Replace /full/path/to/monitor.sh with your actual script path.

## Step 2: Open your crontab editor

- crontab -e

If asked, choose your preferred text editor (e.g., nano).

## Step 3: Add a cron job
- Add the following line at the end of the file:

```bash
*/10 * * * * /full/path/to/monitor.sh
```

- This runs the script every 10 minutes. Change */10 to any other interval as needed:

- Every minute: * * * * *

- Every 30 minutes: */30 * * * *

## Step 4: Save and exit
- If using nano, press Ctrl + O then Enter to save, and Ctrl + X to exit.

## Step 5: Check logs
- Your script will append results to the log file (e.g., ~/url_monitor.log).

## To view logs, run:

- cat ~/url_monitor.log

## Notes
- Ensure the script path is absolute.

- Cron runs in a minimal environment, so use full paths inside scripts.

If your script needs environment variables or special paths, consider adding them explicitly inside the script.

Happy automation!
---