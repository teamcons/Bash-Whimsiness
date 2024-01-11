#!/bin/bash
# USAGE : Copy in ~/.local/share/applications/nautilus/scripts
# Now from a right click->"scripts"->Dockify you can get a menu entry for any file or folder

######## INIT VARIABLES ########
THING="$1"
DESKTOPFILE=~/.local/share/applications/${THING}.desktop

#shift # Remove first argument
#KEYWORDS="$*"


######## SCRIPT ########

# TODO : Icon, get standard one from
# gio info -a standard::icon 

# Option: select an icon ? Open Zenity in wherever theme is
# Option: --setings option ?

cat << EOF > "$DESKTOPFILE"
[Desktop Entry]
Name = $THING
Comment = Pinned folder
Exec = xdg-open $PWD/${THING// /\\ }
Icon = folder
Type = Application
Keywords = folder;manager;explore;filesystem
Terminal = false
Categories = FileManager;
Actions = Unpin;

[Desktop Action Unpin]
Name = Unpin the folder
Exec = rm -f $HOME/.local/share/applications/${THING// /\\ }.desktop

EOF

