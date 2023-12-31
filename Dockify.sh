#!/bin/bash
# USAGE : ~/.local/share/applications/nautilus/scripts

######## INIT VARIABLES ########
THING="$1"
DESKTOPFILE=~/.local/share/applications/${THING:-randomlol}.desktop

#shift # Remove first argument
#KEYWORDS="$*"


######## SCRIPT ########
notify-send "$DESKTOPFILE"

cat << EOF > "$DESKTOPFILE"
[Desktop Entry]
Name = $THING
Comment = Pinned folder
Exec = xdg-open $PWD/${THING// /\\ }
Icon = folder
Type = Application
Keywords = folder;manager;explore;disk;filesystem
Terminal = false
Categories = FileManager;
EOF




