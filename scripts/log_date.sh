#!/bin/bash

LOG_DIR="/home/matefio17/projekt/logs/"
LOG_FILE="$LOG_DIR/activity.log"

if [ -d "$LOG_DIR" ]; then
    echo "Folder  istnieje."
else
    echo "Folder nie istnieje. Tworzę folder."
    mkdir -p "$LOG_DIR"
    echo "Folder utworzony -> ~/projekt/logs"
    echo "Tworzę plik activity.log"
    touch "$LOG_FILE"
    echo "Plik utworzony -> ~/projekt/logs/activity.log"
fi

echo "Skrypt uruchomiony: $(date)" >> "$LOG_FILE"