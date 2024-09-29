#!/bin/bash
# Made by Stella - littlepastelworld@gmail.com

######## FOR WHO READS THIS ########
# WHAT: Create a menu entry for a file or folder, so you can put it on any dock, or open from an app launcher
# INSTALL: Copy in ~/.local/share/applications/nautilus/scripts
# USAGE: Right-click on a file or folder, then on "script", then on "pin". Voilà.
# FEATURES: Right-clicks options allow to open location of the file or folder, edit the .desktop file, or 
# LOCALIZATION: EN, DE, FR, ES, zh_CN
# KNOWN BUGS: Not sure if icon thingy is 100% reliable


######## INIT VARIABLES ########
THING="$1"
SAVEAS=$HOME/.local/share/applications/dockmark.desktop
ICON="folder-recent"

######## SCRIPT ########
cat << EOF > "$SAVEAS"
[Desktop Entry]
Name = dockmark
Comment = Updates right click
Exec = $PWD/$0
Icon = $ICON
Type = Application
Keywords = recent
Terminal = false
Categories = FileManager;
EOF

for i in
do

done

echo "Actions = Location;Edit;Unpin;" >> "SAVEAS"

for i in
do

cat << EOF > "$SAVEAS"
[Desktop Action Location]
Name = Open location
Name[de] = Standort öffnen
Name[fr] = Ouvrir l'emplacement
Name[es] = Abierta la localización 
Name[zh_CN] = 打开位置
Name[id] = Buka Lokasi
Name[aceh] = Buka Lokasi
Exec = xdg-open '$PWD'
EOF
done


