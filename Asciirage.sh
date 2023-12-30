#!/bin/bash

#================================================================
# Fully interactive ascii-painting editor written in Bash
# Made by Stella -- stella.menier@gmx.de

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.



# Options : 
#	--help/-l : display...some help.
#	--load/-l : (not implemented)
#	--save/-s : (not implemented)
#	--version/-v : display version



#================================================================
# Settings

# Generic
NAME="Asciirage"
VERSION="2.0.2"



# Colors. Colors are fun.
CLOSE="$(tput sgr0 ; tput bold)"
STOP="$(tput sgr0 )"

red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
pink="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

RED="$(tput bold ; tput setaf 1)"
GREEN="$(tput bold ; tput setaf 2)"
YELLOW="$(tput bold ; tput setaf 3)"
BLUE="$(tput bold ; tput setaf 4)"
PINK="$(tput bold ; tput setaf 5)"
CYAN="$(tput bold ; tput setaf 6)"
WHITE="$(tput bold ; tput setaf 7)"

BG_RED="$(tput bold ; tput setab 1)"
BG_GREEN="$(tput bold ; tput setab 2)"
BG_YELLOW="$(tput bold ; tput setab 3)"
BG_BLUE="$(tput bold ; tput setab 4)"
BG_CYAN="$(tput bold ; tput setab 6)"
BG_WHITE="$(tput bold ; tput setab 7)"


 # Set some stuff
 DEFAULT_FILENAME="Rename-Me.map"	# Default name of new maps
 DEFAULT_BRUSH='#'			# Default character to use as brush
 DEFAULT_MENU="?"			# Default character to display menu

 CL_PAINT="$green"			# Colour of "painting mode"
 CL_NAVIGATE="$blue"			# Same for navigate
 CL_ERASER="$red"			# Same for eraser

 CL_MENU="$BG_BLUE"			# Menu highlights


#================================================================
### Internal functions ;) ###
 
 _drawbash_man()
 {
clear ; cat << EOF
$GREEN Drawbash, version $VERSION $CLOSE
Fully interactive ascii-painting editor written in Bash

$GREEN Commands :$CLOSE
Press space bar to switch between painting, navigating and the eraser
Press "$DEFAULT_MENU" for the menu (use arrows to navigate)
Press any other key to immediately change brush.
 If you change the size of your terminal window, press any key, drawbash adapt itself automatically to fit the new size!
 

$GREEN About :$CLOSE
 Drawbash$red is not given free${CLOSE}, it's a "Pay what you want" software.
 You are free to pay the price you want for it. You're free to pay nothing if you want.
 
 As i am a student, and thus, don't have much money, even a little price would be greatly appreciated.
 If you feel like to or want to report bugs, mail me at stella.menier@gmx.de ! (not my paypal address).
 Anyway, Feel free to change and customize it. And$GREEN have a nice day! =)$CLOSE
EOF
 }
 
 
 
 _drawbash_help()
 {
cat << EOF
 Options : 
	--help/-l : display...some help.
	--load/-l : load a file
	--save/-s : set a file where to save
	--version/-v : display version
      
EOF
 }
 
 

# Print a full line of something
printline()
{
	c=$1
	printf "%${TERMINAL_WIDTH}s" "" | sed s/' '/"${c:=_}"/g
}


# Print at the center
printcenter()
{
	chaine="$*"
	cols1=$(($TERMINAL_WIDTH / 2 + ${#chaine} / 2))
	cols2=$(($TERMINAL_WIDTH - ${cols1}))
	printf "%${cols1}s%${cols2}s" "$chaine" " "
}



# Quit Drawbash
 _drawbash_quit()
 {
	clear ; echo "$WHITE Surfs up! =)$STOP"
	echo ; exit 0 
 }

 
 
 # Initialisation of tools, mode, colors, environnement
_init_tools()
{
	brush="$DEFAULT_BRUSH"			# default brush is DEFAULT_BRUSH (o rly ? :p )
	mode="paint"				# start drawing =)
	cl="$CL_PAINT"				# set color

	TERMINAL_HEIGHT=$(tput lines)		# how much lines ?
	TERMINAL_WIDTH=$(tput cols)		# how much columns ?

	MAP_HEIGHT=$(( $TERMINAL_HEIGHT - 2))		#Update map size
	MAP_WIDTH=$(( $TERMINAL_WIDTH - 2 ))		#Update map size

	line=$(( $TERMINAL_HEIGHT / 2 ))	# brush start line
	column=$(( $TERMINAL_WIDTH / 2 ))	# brush start column
	tput cup $line $column			# cursor at start location
}





 #Update the top bar, where there is the menu
 _drawbash_updatetop()
 {
	tput cup 0 1							#Go at first line, let a space
	printf "Mode: [$cl${mode}$CLOSE]-----"				#display at right mode and eraser state

	tput cup 0 $(( $TERMINAL_WIDTH -23 ))				#go at left, let a space
	printf "Brush: [${brush}]---Menu: [$cl${DEFAULT_MENU}$CLOSE]"	#display last part of menu

	tput cup $line $column						#restore cursor position
}






 # Do the borders around the screen
 _init_screen()
{
tput cup 0 0			#go at first line
#printf "$BG_WHITE"		#background in white
printline '-'			#print line
#printf "$CLOSE"			#end white background (comment for white borders)

    for i in $(seq 1 $TERMINAL_HEIGHT )			#for each line
    do						#do
	tput cup $i && printf '|'				#Print separator at left
	tput cup $i $TERMINAL_WIDTH && printf '|'			#print separator at right
    done					# end of foreach
	
tput cup $(( $TERMINAL_HEIGHT - 1 ))	#go at last line
#printf "$BG_WHITE"		#background in white (useless if printf "$CLOSE" above is commented)
printline '-'			#print line
#printf "|$CLOSE" 		#disable white background
}




# Display a menu using the args
 _display_menu()
{

local largest_menu_entry=0	#init value
local menu_entry=""		#init value

OLDIFS="$IFS" ; IFS=""		#IFS cause troubles for parsing arguments. Disable it

for menu_entry in $@		# For each given menu entry
do				# do

	if [ ${#menu_entry} -gt $largest_menu_entry ]	# if it's the longuest one
	then largest_menu_entry=${#menu_entry}		# update value
	fi						# end of if

done				# end of going through menu entries


local half_width=$(( $largest_menu_entry /2 ))				#
local menu_width=$(( ($TERMINAL_WIDTH /2) - $half_width ))		#

local how_much_entries=$#						# How much menu entries do we have ?
local menu_height=$(( ($TERMINAL_HEIGHT /2) - $how_much_entries ))	#
local menu_index=1							#initialisation of number of menu entries


for menu_entry in $@			# again, for each menu entry
do					# do

	tput cup $(( menu_height + $menu_index)) $menu_width	# cursor at where it should be displayed
	eval printf \"\$highlight_$menu_index\"			# display highlight
	printf "${menu_index} $menu_entry $CLOSE"		# display menu entry and his number 
	local menu_index=$(( $menu_index + 1 ))			# increment menu number

done					# end of printing menu entries

IFS="$OLDIFS"			# make IFS come back, we need them
}



 
 # Let the user play with the menu
 _drawbash_menu()
 {
local MENU_ENTRY=6 ; local choice=1		#we need them only here

while [ true ]			#loop forever....
do


 ### display dynamically menu entries (reload with highlights)
_display_menu \
'Back to the Shit' \
'Save this Shit somewhere' \
'Load some Shit' \
'Shit display?' \
'Read the Shitty Manual' \
'Run Away from this Shit'


  ### User input
read -n 1 -s ans
 
  ###parse user answer
   if [ "$ans" == $(echo -en "\e") ]	#if strange string given (arrow)
then					#then parse it and send it to proper option
    read -sn1 ans				# Read another part of it
    test "$ans" == "[" || continue		# That's still an arrow, if not continue
    read -sn1 ans				# Last character is A B, C or D, so depending on which is it we know which arrow-key user pressed
    case $ans in
    
	A ) if [ "$choice" -gt 1 ] 		#if user isn't too deep in menu (first choices)
	    then 				#then
		eval highlight_$choice=""			#don't highlight actual choice
		choice=$(( $choice - 1))			#go deeper
	 	eval highlight_$choice="$CL_MENU"		# highlight new choice
	    
	    else				#else, user goes too low
		eval highlight_$choice=""			#duh, the same, but
		choice=$MENU_ENTRY				#new choice is the last (we jump from the last to the first)
		eval highlight_$choice="$CL_MENU"		#and... highlight

	    fi ;;				#end of if user go too deep
	       
	    
	B ) if [ "$choice" -lt $MENU_ENTRY ] 	#if we're too high because of drugs
	    then				#then
		eval highlight_$choice="" 			#the same as above.
		choice=$(( $choice + 1))			#same
	 	eval highlight_$choice="$CL_MENU"		#need coffee
	    	    
	    else				#else, the same as above, but we jump from last tho first
		    eval highlight_$choice=""			#duh, the same, but
		    choice=1					#new choice is the last (we jump from the last to the first)
		    eval highlight_$choice="$CL_MENU"		#and... highlight

	    fi ;;				#end of if user go too high

	    esac

    
  elif [[ "$ans" == [0-$MENU_ENTRY] ]]		#else, if user gave a number
then						#then jump to corresponding choice
    eval highlight_$choice=""				# Disable actual highlight
    choice=$ans						# Choice is what user entered
    eval highlight_$choice="$CL_MENU"			# Highlight choice


 elif [ -z "$ans" ]				#else, if user hit enter
then						#then, look at what is highlighted
    eval highlight_$choice=""				#reset highlightning
    case $choice in
    1 ) _drawbash_retab ; _system_termsize ; break ;;
    2 ) _system_save ; break ;;
    3 ) _system_browserhelp ; _system_browse ; _drawbash_load "$file" ; break ;;
    4 ) _drawbash_redraw ; break ;; 
    5 ) _drawbash_man ; read -n 1 -s; _drawbash_redraw ; break ;;
    6 ) _drawbash_quit ;;
    esac

fi	
done

 _system_termsize	 #check terminal size
 }				 #end _drawbash_menu

 
 
 

 _drawbash_retab()
 {
set -f		#go away, wildcard
# clear ; _init_screen ; _drawbash_updatetop		#clear all, reinit drawing
for l in $(seq $(( $TERMINAL_HEIGHT /2 -5 )) $(( $TERMINAL_HEIGHT /2 +2 )) )	#For each line
do								#do

	for k in $(seq $(( $TERMINAL_WIDTH / 2 - 14 )) $(( $TERMINAL_WIDTH / 2 + 14 )) )		#for each colum
	do									#do
	      tput cup $l $k								#go at position
	      eval to_rewrite=\"\$\{pix_line${l}_column[$k]\}\"				#load fake pixel
	      eval printf %b \'${to_rewrite:- }\'					#print it properly escaped	
	done							#end of foreach col

done							#end of foreach line

tput cup $line $column
set +f		 #wildcard back
}




_drawbash_goto()
{
### check if you can go in asked direction and change values
case "$1" in
	A ) [ $line -gt 1 ] && line=$((line - 1)) ;;
	B ) [ $line -lt $(( $TERMINAL_HEIGHT - 2 )) ] && line=$((line + 1)) ;;
	C ) [ $column -lt $(( $TERMINAL_WIDTH - 2 )) ] && column=$((column + 1 )) ;;
	D ) [ $column -gt 1 ] && column=$((column - 1 )) ;;
esac
tput cup $line $column	#go at position
}



_drawbash_paint()
{
    if [ "$mode" = "paint" ]	#if you can modify any ascii char
    then
	eval printf %b \'$brush\' ; tput cup $line $column	#then brush, back to where you were
	eval pix_line${line}_column[$column]=\'$brush\'		#remember, for the save function
	

    elif [ "$mode" = "eraser" ]			#if you use eraser
    then
	printf ' ' ; tput cup $line $column		#then put blank, back to where you were
	eval pix_line${line}_column[$column]=' '	#remember, for the save function
	
    fi					# end of checking paint
}



 _drawbash_switch_mode()
{
    if [ "$mode" = "paint" ]		#if you were painting
    then mode="navigation"			#then navigation
      cl="$CL_NAVIGATE"				#update color

    elif [ "$mode" = "navigation" ]	#if you were navigating
    then mode="eraser"				#then eraser on
      cl="$CL_ERASER"				#update color
    
    elif [ "$mode" = "eraser" ]		#if you were erasing
    then mode="paint"				#then back to paint
      cl="$CL_PAINT"				#update color
      
    fi					#end of switching mode
     _drawbash_updatetop		#update user interface
}




 _user_presskey()
{
set -f				#deactivate wildcard, cuz it's dangerous
  if [ "$ans" == $(echo -en "\e") ]	#if strange string given (arrow)
then					#then parse it and send it to proper option
	#Nb : important note :
	#when u hit arrow, you give to "read" command something like "^[[" followed by A, B, C or D
	#whe limited "read" to one character. following "read" will each take following characters
	#the last character, A, B, C or D, is the one that's interesting
	read -sn1 ans
	test "$ans" == "[" || continue
	read -sn1 ans
	_drawbash_goto "$ans"		#send it to proper specialized function

	
elif [ -z "$ans" ]		#if user wants to switch mode
then				#then switch mode ?
	_drawbash_switch_mode

elif [ "$ans" = "$brush" ]	#if you press your brush
then				#then brush
	_drawbash_switch_mode

elif [ "$ans" = "$DEFAULT_MENU" ]	#If user asked for menu
then				#then menu
	_drawbash_menu

else				#else, switch brush
	eval brush=\'$ans\'
	mode="paint"

fi				#end of the if
set +f			#activate teh wildcard again
}



 

_system_browserhelp()
{
# 'browse_light' is the minimal version for a file browser in Lands of Ascii
# This one is designed to search for a file where to save the stuff

clear
read -p "\

Enter the name of the file where you want to save it ${RED}(it will be overwritten)$CLOSE
Enter name of a directory to go into it.

Minibrowser's Commands :
$YELLOW CANCEL$CLOSE to... cancel. (return err 1, save under $DEFAULT_FILENAME )
$YELLOW MKDIR$CLOSE to make a new directory
$YELLOW NEWFILE$CLOSE to create new file (or type in a name)
$YELLOW OLD$CLOSE to go back (same as - )
$YELLOW HELP$CLOSE if you're lost and there are zombies 

Autocompletion is possible! ;)$STOP
Enter any key to start browsing for a file...
 
" -n 1 -s        #Yep. Autocompletion is possible, it's not a lie
}
 
 
 
 
 _system_browse()
{
### Loop for search :
while true                   #while user don't find a file
do                           #Output a prompt

clear ; read -e -p "\
$BG_GREEN #~ You are in: $PWD ~# $STOP
$(ls --group-directories-first --color=yes -F)
$BG_GREEN browse:$STOP " where_to_go


#Parse user answer
if [ -z "$where_to_go" ]		# if nothing
then	cd                     		# Nothing ? Back home

elif [ "$where_to_go" = "-" ]		# if dash (back to previous dir)
then	cd $OLDPWD                    	# back to previous directory
 
elif [ -d "$where_to_go" ]		# if directory
then cd "$where_to_go"      		# go to asked directory
 
elif [ -f "$where_to_go" ]		# if User input is a file
then	file="$where_to_go" && break	# found teh file

        
elif [ "$where_to_go" = CANCEL ] 	# if command
then	return 1 && break	        # Prefer cancelling.


elif [ "$where_to_go" = MKDIR ]		# if command
then					# then
  read -p "$yellow mkdir " mkdir	# ask for a name
  mkdir $mkdir  			# Create a directory


elif [ "$where_to_go" = NEWFILE ] 	# if command
then				 	# then
  read -p "$yellow touch$STOP " touch	# ask for a name
  touch $mkdir 				# Create a file


elif [ "$where_to_go" = OLD ] 		# if command
then	cd $OLDPWD			# Back previous directory


elif [ "$where_to_go" = HELP ] 		# if command
then	_system_browserhelp			# display tha help
 
       
elif [ ! -e "$where_to_go" ]		# if, finally, it doesn't exit
then	file="$where_to_go" ; break	# save function will overwrite it
   
     
fi				#end of parsing answer

done			# End of eternal loop
}
 


 
 _system_termsize()
 {
 #If the size of the terminal changed, update it
local TPUTCOLS=$(tput cols) 
local TPUTLINES=$(tput lines)



 if [ ! $TERMINAL_HEIGHT = $TPUTLINES ] \
 || [ ! $TERMINAL_WIDTH = $TPUTCOLS ]
 then
   
	if [ ! $TERMINAL_HEIGHT -lt $TPUTLINES ] \
	 || [ ! $TERMINAL_WIDTH -lt $TPUTCOLS ]		# if new terminal size is bigger
	then						# then we'll clean old separators

		for i in $(seq 1 $TERMINAL_HEIGHT )		# for each line
		do						# do
			tput cup $i $(( $TERMINAL_WIDTH - 1 ))		# go at left border
			printf ' '					# print blank (no border anymore)
    		done						#done


		tput cup $(( $TERMINAL_HEIGHT - 1 ))	#go at last line
    		printline ' '				#print blank line
  
	fi


   #update values
    TERMINAL_HEIGHT=$TPUTLINES			#Update TERMINAL_HEIGHT
    TERMINAL_WIDTH=$TPUTCOLS			#Update TERMINAL_WIDTH
    
    #bring back new fresh user interface
    _init_screen			#reinit user interface
    _drawbash_updatetop			#bring menu back
    tput cup $line $column		#reinit cursor
    
    
 fi		#end of updating terminal size	
		
 }



 
 _drawbash_check_drawingsize()
 {

 if [ ! $(( $TERMINAL_HEIGHT - 2 )) = $MAP_HEIGHT ] \
 || [ ! $(( $TERMINAL_WIDTH -2 )) = $MAP_WIDTH ]
 then
   
	if [ $(( $TERMINAL_HEIGHT - 2 )) -lt $MAP_HEIGHT ] \
	|| [ $(( $TERMINAL_WIDTH -2 )) -lt $MAP_WIDTH ]
	then
	
		clear
		echo "WARNING: Terminal is too small to display the full drawing"
		echo "Drawing size: ${MAP_HEIGHT}x${MAP_WIDTH}"
		echo "Need a terminal of $(( $MAP_HEIGHT + 2))x$(( $MAP_WIDTH + 2))"
		echo
		read -n 1 -s -p "$STOP enter any key to resize$CLOSE"

		MAP_HEIGHT=$(( $TERMINAL_HEIGHT - 2))		#Update map size
		MAP_WIDTH=$(( $TERMINAL_WIDTH - 2 ))		#Update map size
		_drawbash_redraw
    


	elif [ $(( $TERMINAL_HEIGHT -2 )) -gt $MAP_HEIGHT ] \
	  || [ $(( $TERMINAL_WIDTH -2 )) -gt $MAP_WIDTH ]
	then

		MAP_HEIGHT=$(( $TERMINAL_HEIGHT - 2))		#Update map size
		MAP_WIDTH=$(( $TERMINAL_WIDTH - 2 ))		#Update map size
		_drawbash_redraw

	fi


 fi		#end of updating terminal size	
		
 }




 _drawbash_recons()
 {
local char=""
for l in $(seq 1 $(( $TERMINAL_HEIGHT - 2 )) )		#For each line
do							#do

	if [ "$1" = let-space ]					# If asked
	then tput cup $l 1					# Let a space before (borders)
	fi							# End of if

	for k in $(seq 1 $(( $TERMINAL_WIDTH - 2)) )		#for each column
	do							#do
	    eval char=\$\{pix_line${l}_column[$k]\}		#find character, store it
	    printf %b "${char:- }"					#show character at taken line and column. If nothing, let a space
	done							#end of foreach colum
      printf "\n"						#New line

done							#end of foreach line
 }


 
 
 _drawbash_redraw()
{
	tput cup 1 0			# go at suited location
	_drawbash_recons let-space	# bring your drawing back using memory
	_init_screen 			# redraw borders
	_drawbash_updatetop 		# redraw updated menu
	tput cup $line $column		# back to previous cursor location
}


 
 
 

 _system_save()
{
clear				# clear screen

if [ -z "$file" ]
then

# Being nice is always nice
 echo "$green Oh, that's a nice drawing you made!
    Let's find it a nice place where to save it$CLOSE"

 _system_browserhelp 		# Display help for browser
 _system_browse			# Browse for a file to save
fi

 
tput sgr0 ; file=						# Disable colors
_drawbash_recons > "${file:=$DEFAULT_FILENAME}"		#redirect output to $file (if not: $DEFAULT_FILE)


read -n 1 -s -p "Done saving to $file!
$WHITE  Enter any key to go back drawing, or CTRL+C to quit! =)$CLOSE"


 _drawbash_redraw
}



########################
 _drawbash_convert_line()			# Take a line, parse it into words
{
local line_to_parse="$1"			#the first argument is the line we have to parse


    MAP_HEIGHT=$(( $MAP_HEIGHT + 1))			#another line, increment map size
    while [ ! -z "$line_to_parse" ]
    do
    
	[ $MAP_WIDTH -lt ${#line_to_parse} ] && MAP_WIDTH=${#line_to_parse}	#this line is longer than others ? then
	
	read -n 1 char <<< "$line_to_parse"
	eval pix_line${l}_column[$k]=\'"$char"\'

	line_to_parse="${line_to_parse#"$char"}"
	k=$(( $k + 1 ))

    done


}



########################

 _drawbash_load()
 {					# Take a file, parse it into lines

if [ ! -f ]
then
clear ; echo "$RED ERROR : This is not a file !$STOP"
exit 1
fi
 

# Init values
MAP_FILE="${1}"
MAPNAME=$(basename "${1:-nowhere}" )
MAP_HEIGHT=0 ; MAP_WIDTH=0
TPUTLINES=$(tput lines) ; TPUTCOLS=$(tput cols)


OLDIFS="$IFS" ; IFS=""		# disable IFS
set -f				# Had many trouble with wildcard for the trees. This disable it
l=1 ; k=1			# Init lines and columns for loading values

while read file_line				# for each line of the file
do						# do

	_drawbash_convert_line "$file_line"		# It looks closer at the line.
	tput cup $l 1 ; printf %b "$file_line"
	l=$(( l + 1 )) ; k=1				# next line! start at column 0 again

done < "$MAP_FILE"			# content of file to loop


set +f				# wildcard is back
IFS="$OLDIFS"			# Enable IFS again


_system_termsize
_drawbash_check_drawingsize	#

_init_screen 			# redraw borders
_drawbash_updatetop 		# redraw updated menu

tput cup $line $column
}





  _drawbash_run()
{
clear ; #trap _drawbash_quit INT

printf "$CLOSE" 	#every character is in bold naw

_init_tools	# Init values
_init_screen		# Prepare screen 
_drawbash_updatetop	# Put teh menu on top



while true
do
	read -s -n 1 ans		#user input
	_user_presskey			#read what user gave
	_drawbash_paint			#paint (...or not. eraser could be activated)
	_system_termsize 	#check terminal size
	_drawbash_check_drawingsize	#
done
}	# end of run function










#================================================================
### Run! ###

if [ ! -z "$1" ]
then

  case "$1" in
    --load | -l )	_drawbash_load "$2" ;;
    --save | -s )	file="$2" ;;
    --version | -v )	echo " Drawbash ${VERSION}" ; exit 0 ;;
    --help | -h | * )	_drawbash_man ; exit 0 ;;
  esac

fi							#end of check for help

  _drawbash_run $*					#run !


