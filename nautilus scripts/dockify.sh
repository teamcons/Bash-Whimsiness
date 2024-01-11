#!/bin/bash
# USAGE : Copy in ~/.local/share/applications/nautilus/scripts
# Now from a right click->"scripts"->Dockify you can get a menu entry for any file or folder

######## INIT VARIABLES ########
THING="$1"
DESKTOPFILE=~/.local/share/applications/${THING}.desktop

ICON=$(gio info "$THING" | grep standard::icon | cut -d ' ' -f 5 | cut -d ',' -f 1)

# TODO Categories and keywords

if [ -d $THING ] ; then KEYWORDS="pinned;folder;manager;explore;filesystem;"
elif [ -f $THING ] ; then KEYWORDS="pinned;file;"
else KEYWORDS="pinned;"
fi

######## SCRIPT ########
cat << EOF > "$DESKTOPFILE"
[Desktop Entry]
Name = $THING
Comment = $PWD/$THING
Exec = xdg-open $PWD/${THING// /\\ }
Icon = $ICON
Type = Application
Keywords = $KEYWORDS
Terminal = false
Categories = FileManager;
Actions = Unpin;Edit;

[Desktop Action Unpin]
Name = Unpin
Exec = rm -f $HOME/.local/share/applications/${THING// /\\ }.desktop && notify-send "Dockify" "Removed $THING"

[Desktop Action Edit]
Name = Edit
Exec = xdg-open $HOME/.local/share/applications/${THING// /\\ }.desktop

EOF

notify-send "Dockify" "$THING"
