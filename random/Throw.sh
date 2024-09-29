#!/bin/bash
# Throw.sh v1.0

# Feel free to change and customize =)
# Throw usage : throw so much dices you want, of the type you want, how you want, in one invocation

# Option :
#	--in-a-pipe : Makes output more suitable for a script or a pipe



### Defaults ###

Left_Separator='['
Right_Separator=']'



### Time to do some code ;) ###

function Throw() # Firstly intended as function in Bash configuration file
{

if [ -z "$1" ]	# If you don't gave dices to throw
then		# Then explain how it works

	echo -e "$0: \"Throw 2D6 1D4\""
	echo -e "--> Same as throwing 2 dices of 6 and 1 of 4 =)\n"


else		# Else, okay, user is not a noob

	if [  "$1" = "--in-a-pipe" ]		# If option invoked
	then					# Then
		shift  && no_nice_output="noes"		# No nice output
		Left_Separator=''			# No left separator
		Right_Separator=''			# No right separator
	fi					# End of if option

	
	
	
	while [ ! -z "$1" ]			#So long as there are dices and they match pattern of dice
	do


		[ -z "$no_nice_output" ] && echo -n "$1: "			#Echo dice it is

		
		if [[ ! $1 = *D* ]] && [[ ! $1 = *d* ]]				# if it's not a dice
		then								# Then
			[ -z "$no_nice_output" ] && echo -n " ...Nah"			# Signal it
			err_code=$(( ${err_code:-0} + 1 ))				# +1 in error code
			
			
		else								# Else, be nice

			if [[ $1 = *D* ]]
			then
			  how_much_thrown=${1%%D*}
			  number_of_faces=${1##*D}
			
			elif [[ $1 = *d* ]] 
			then
			  how_much_thrown=${1%%d*}
			  number_of_faces=${1##*d}
			fi
			
			
			for i in $(seq 1 "$how_much_thrown" )			# For each dice to be thrown
			do							# do
				result=$[($RANDOM % $number_of_faces) + 1]		# Throw the dice
				echo -n "$Left_Separator$result$Right_Separator"	# Display it.
				echo -n ' '						# let a space
			done							# done
			
			
		fi							# End pattern-test
		shift ; [ -z "$no_nice_output" ] && echo		# Next dices, and new line.


	done													
	echo && return ${err_code:-0}		# Nothing went wrong =D



fi		#End of test if params

 } #End function Throw


# As i choosed to post it as a script on DeviantArt...
Throw $*
