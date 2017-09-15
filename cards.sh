#!/bin/bash
# cards.sh: command line flashcard study tool

# Adding in argument count processing code. Currently I am just seeing what works

# First, check for arguments. If none, print help and exit

main () { # Main code is wrapped, and called at bottom of script. 
	#This is so functions can be declared at the bottom of the code instead of the top, 
	#for improved readability
	
selectedset=$2

if [ $# -eq 0 ]; then
  printf -- "No arguments. Use -h for help\n"
  
elif [ "$opt" = "?" ]
then
  echo "Default option executed (by default)"
else # using getopts to parse command line options
while getopts "l:a:n:w:r:d:hs" opt; do #lanwrd - all take one argument
	case ${opt} in
		l ) #learned mode playback
			LEARNED
			;;
		a )
			ALL #all mode playback- ignore learned
			;;
		n ) # New flashcard set
			NEWSET
			;;
		w ) # Write flashcards to existing set
			WRITETO
			;;
		r ) # reset learned list
			RESETLEARNED
			;;
		d ) # delete flashcard set and learned list
			DELETESET
			;;
		h ) #show help
			HELP
			;;
		s ) #process -s (list)
			LIST
			;;
		\? ) printf -- "Incorrect argument. Use -h for help\n"
			;;
		esac
	done
fi
}

#Help function
HELP () {
	printf "Usage:\n"
	printf "cards.sh <options> <flashcard set>\n\n"
	printf -- "-l: learned mode, play only flashcards not marked as learned: cards.sh -l exampleset\n"
	printf -- "-a: play all flashcards randomly, ignore learned list: cards.sh -a exampleset\n"
	printf -- "-n: create a flashcard set: cards.sh -n setnamehere\n"
	printf -- "-w: write to flashcards in a set: cards.sh -w exampleset\n"
	printf -- "-r: reset learned cards for a set: cards.sh -r exampleset\n"
	printf -- "-d: delete flashcard set: cards.sh -d exampleset\n"
	printf -- "-s: List all flashcard sets in folder: cards.sh s\n"
	exit 0
}

#TODO: Write list function that is just a ls of dirs in the directory
LIST () {	
	printf "Code not yet implemented. Todo: incorporate list function\n"
}

LEARNED () {	
	printf "Problem set selected: %s  --  Ignore learned flashcardscards mode\n" $selectedset
	
	if [ ! -e sets/"${selectedset}.cards" ]; then # -d checks for directory of variable name. ! means code will run if false. Else, problem set directory must exist, and code continues
		printf "Flashcard set does not exist\n"
		exit 2
	else
		printf "Flashcard set exists!\n\n"
		while true
		do
			echo #newline
			# Simple check for empty flashcard set
			if [ ! -s sets/${selectedset}.cards ]; then
			printf "Flashcard set appears to be empty\n"
			exit 2
			fi
			
			shuf -n 1 sets/${selectedset}.cards > .temp.cards # writes a random question to a temp file in the main directory
			printf "\nQuestion: "
			awk -F'======2======' '{print $1}' .temp.cards # Print question from temp file
			while true
			do
				echo # newline
				read -p "[a]nswer,[h]int,or [q]uit ? " choice
				case "$choice" in
					a|A )
						printf "Answer: "
						awk -F'======2======' '{print $2}' .temp.cards
						break
						;;
					#* ) 
					#	printf "Answer: " #This is to make the default behavior answer mode
					#	awk -F'=' '{print $2}' .temp.cards
					#	break
					#	;;
					h|H ) 
						printf "Hint: "
						awk -F'======2======' '{print $3}' .temp.cards
						;;
					q|Q ) printf "quit\n"
						exit 0
						;;
				esac
			done
			printf "\nDid you get the answer correct? "
			read -p "Y/n " choice
			case "$choice" in
				y|Y )
					echo #newline
					CRCT
					;;
				n|N )
					# WRNG would move to unlearned pile. No need to do anything in the learned mode- just leave the card in the main unlearned file
					printf "Card left in unlearned set\n\n"
					;;
				* ) 
					printf "Assuming no\n"
					printf "Card left in unlearned set\n\n"
					;;
			esac
		done
	fi
	exit 0
}

ALL () {	
	printf "Problem set selected: %s  --  Review all flashcardscards mode\n" $selectedset
	
	if [ ! -e sets/"${selectedset}.cards" ]; then # -d checks for directory of variable name. ! means code will run if false. Else, problem set directory must exist, and code continues
		printf "Flashcard set does not exist\n"
		exit 2
	else
		printf "Flashcard set exists!\n\n"
		# Simple check for empty flashcard set
		if [ ! -s sets/${selectedset}.cards ] && [ ! -s sets/${selectedset}.cards.learned ]; then
		printf "Flashcard set appears to be empty\n"
		exit 2
		fi
		while true
		do
			if (( $RANDOM % 2 == 0 )); 
			then ## Pull from unlearned cards
				if [ ! -s sets/${selectedset}.cards ]; then 
					printf "\nWARNING: UNLEARNED SET EMPTY, RECCOMEND AT LEAST ONE UNLEARNED FLASHCARD BE LEFT IN\n"
					continue ## This should break and retry random number if the unleared cards set is blank. Inefficient, yes. This could be fixed with better design later
				fi
				
				shuf -n 1 sets/${selectedset}.cards > .temp.cards # writes a random question to a temp file in the main directory
				printf "\nQuestion: "
				awk -F'======2======' '{print $1}' .temp.cards # Print question from temp file
				while true
				do
					echo # newline
					read -p "[a]nswer,[h]int,or [q]uit ? " choice
					case "$choice" in
						a|A )
							printf "\nAnswer: "
							awk -F'======2======' '{print $2}' .temp.cards
							break
							;;
						#* ) 
						#	printf "Answer: " #This is to make the default behavior answer mode
						#	awk -F'=' '{print $2}' .temp.cards
						#	break
						#	;;
						h|H ) 
							printf "\nHint: "
							awk -F'======2======' '{print $3}' .temp.cards
							;;
						q|Q ) printf "\nquit\n"
							exit 0
							;;
					esac
				done
				printf "\nDid you get the answer correct? "
				read -p "Y/n " choice
				case "$choice" in
					y|Y )
						echo #newline
						CRCT
						;;
					n|N )
						# WRNG would move to unlearned pile. No need to do anything in the learned mode- just leave the card in the main unlearned file
						printf "Card left in unlearned set\n\n"
						;;
					* ) 
						printf "\nAssuming no\n"
						printf "Card left in unlearned set\n\n"
						;;
				esac
			else
				# pull from learned set
				if [ ! -s sets/${selectedset}.cards.learned ]; then 
					printf "\nWARNING: LEARNED SET EMPTY, RECCOMEND AT LEAST ONE LEARNED FLASHCARD FOR THIS MODE\n"
					continue ## This should break and retry random number if the unleared cards set is blank. Inefficient, yes. This could be fixed with better design later
				fi
				
				shuf -n 1 sets/${selectedset}.cards.learned > .temp.cards # writes a random question to a temp file in the main directory
				printf "\nQuestion: "
				awk -F'======2======' '{print $1}' .temp.cards # Print question from temp file
				while true
				do
					echo # newline
					read -p "[a]nswer,[h]int,or [q]uit ? " choice
					case "$choice" in
						a|A )
							printf "Answer: "
							awk -F'======2======' '{print $2}' .temp.cards
							break
							;;
						#* ) 
						#	printf "Answer: " #This is to make the default behavior answer mode
						#	awk -F'${qsep}' '{print $2}' .temp.cards
						#	break
						#	;;
						h|H ) 
							printf "Hint: "
							awk -F'======2======' '{print $3}' .temp.cards
							;;
						q|Q ) printf "quit\n"
							exit 0
							;;
					esac
				done
				printf "\nDid you get the answer correct? "
				read -p "Y/n " choice
				case "$choice" in
					y|Y )
						printf "Card left in learned set\n\n"
						# Do nothing, this is from the learned set, so it is already in the right place
						;;
					n|N )
						echo #newline
						WRNG
						;;
					* ) 
						echo #newline
						printf "Assuming no\n"
						WRNG
						;;
				esac
			fi
		done	
	exit 0
	fi
}

NEWSET () {	
	printf "Code not yet implemented. Todo: incorporate new set function\n"
	## When done, prompt to go to card creation in new set
}

WRITETO () {	
	printf "Code not yet implemented. Todo: incorporate write cards function\n"
}

RESETLEARNED () {	
	printf "Code not yet implemented. Todo: create function to reset learned list\n"
}

DELETESET () {	
	printf "Code not yet implemented. Todo: create function to delete a set and related files\n"
}

CRCT () {
	cat .temp.cards >> sets/${selectedset}.cards.learned
	#NOT WORKING - could be faster if fixed - awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 .temp.cards f=2 sets/${selectedset}.cards
	grep -Fvx -f .temp.cards sets/${selectedset}.cards > remaining.list #Writes new file without correct car in it
	mv remaining.list sets/${selectedset}.cards #replaces cards list with the new file, missing the correct card, which is now in the .learned file
	printf "Moved card to learned list\n\n"
}

WRNG () {
	cat .temp.cards >> sets/${selectedset}.cards
	grep -Fvx -f .temp.cards sets/${selectedset}.cards.learned > remaining.list #Writes new file without incorrect card in it
	mv remaining.list sets/${selectedset}.cards.learned #replaces cards list with the new file, missing the incorrect card, which is now in the main unlearned file
	printf "Moved card to unlearned list\n\n"
}

main "$@" #calls main code from top, only after all functions have been processed (readability concerns)


