#!/bin/bash
# USAGE : Copy in ~/.local/share/applications/nautilus/scripts
# Now from a right click->"scripts"->Dockify you can get a menu entry for any file or folder

######## INIT VARIABLES ########
THING="$1"
DESKTOPFILE=~/.local/share/applications/${THING}.desktop

#shift # Remove first argument
#KEYWORDS="$*"


######## SCRIPT ########

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

