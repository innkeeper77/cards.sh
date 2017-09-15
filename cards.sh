#!/bin/bash
# cards.sh: command line flashcard study tool

main () { 
	# For readability main code is wrapped as a function, and called at bottom of script. 
	# This is so functions can be declared at the bottom of the code instead of the top 
	
selectedset=$2 # Second command line argument, saved as a variable for readability

if [ $# -eq 0 ]; then
  printf -- "No arguments provided. Use -h for help\n" # Stops script if no command line arguments provided
  
else 
while getopts "l:a:n:w:r:d:hs" opt; do  # using getopts to parse command line options
	case ${opt} in
		l ) 			# All code is seperated into fuctions, declared below
			LEARNED
			;;
		a )
			ALL 
			;;
		n ) 
			NEWSET
			;;
		w ) 
			WRITETO
			;;
		r ) 
			RESETLEARNED
			;;
		d ) 
			DELETESET
			;;
		h ) 
			HELP
			;;
		s ) 
			LIST
			;;
		\? ) printf -- "Incorrect argument. Use -h for help\n"
			;;
		esac
	done
fi
}

HELP () {
	printf "Usage:\n"
	printf "cards.sh <options> <flashcard set>\n\n"
	printf -- "-l: learned mode, play unlearned flashcards from a set: cards.sh -l exampleset\n"
	printf -- "-a: all mode: play both learned and unlearned from a set: cards.sh -a exampleset\n"
	printf -- "-n: create a new flashcard set: cards.sh -n setnamehere\n"
	printf -- "-w: write new flashcards in a set: cards.sh -w exampleset\n"
	printf -- "-r: reset all learned cards for a set: cards.sh -r exampleset\n"
	printf -- "-d: delete a flashcard set: cards.sh -d exampleset\n"
	printf -- "-s: List all available flashcard sets: cards.sh -s\n"
	exit 0
}

LIST () {	
	ls sets/*.cards
	exit 0
	# Todo- prevent sets/ from appearing in front of each filename, and remove .cards extention from display as well
} 

LEARNED () {	
	printf "Problem set selected: %s  --  Review unlearned only mode\n" $selectedset
	
	if [ ! -e sets/"${selectedset}.cards" ]; then # only runs if file does not exist
		printf "Flashcard set does not exist\n"
		exit 2
	else
		while true
		do
			echo #newline
			if [ ! -s sets/${selectedset}.cards ]; then # only runs if file is blank
			printf "Unlearned flashcard set is empty\n"
			exit 2
			fi
			
			# Main flashcard playback loop
			shuf -n 1 sets/${selectedset}.cards > .temp.cards # writes a random question to a temp file in the main directory
			printf "\nQuestion: "
			awk -F'======2======' '{print $1}' .temp.cards # Print question from temp file
			while true
			do
				echo # newline
				read -p "[a]nswer,[h]int,or [q]uit ? " choice
				case "$choice" in
					h|H ) 
						printf "Hint: "
						awk -F'======2======' '{print $3}' .temp.cards
						;;
					q|Q ) printf "quit\n"
						exit 0
						;;
					a|A|* )
						printf "\nAnswer: "
						awk -F'======2======' '{print $2}' .temp.cards
						break
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
					printf "Card left in unlearned set\n"
					;;
				* ) 
					printf "Assuming no\n"
					printf "Card left in unlearned set\n"
					;;
			esac
		done
	fi
	exit 0
}

ALL () {	
	printf "Problem set selected: %s  --  Review all fmode\n" $selectedset
	
	if [ ! -e sets/"${selectedset}.cards" ]; then # -d checks for directory of variable name. ! means code will run if false. Else, problem set directory must exist, and code continues
		printf "Flashcard set does not exist\n"
		exit 2
	else
		if [ ! -s sets/${selectedset}.cards ] && [ ! -s sets/${selectedset}.cards.learned ]; then # Simple check for empty flashcard set. Since this is the "all" mode, we techinically only need one to be not empty
		printf "Flashcard set appears to be empty\n"
		exit 2
		fi
		
		# Main flashcard playback loop
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
	if [ -e sets/"${selectedset}.cards" ]; then 
		printf "Flashcard set already exists\n"
		exit 2
	fi
	if [ ! -d sets ]; then 
		mkdir -p sets
		printf "Created sets directory\n"
		NEWSET
	fi
	:> sets/"$selectedset".cards
	:> sets/"$selectedset".cards.learned
	printf "Empty .cards and .cards.learned files created\n"
	printf "Would you like to write cards in this new set? "
	while true; do
				read -p "[Y|n] " choice
				case "$choice" in
					y|Y )
					WRITETO
					;;
					n|N  )
						printf "exit\n"
						exit 0
					;;
					* ) 
					printf "Assuming yes\n"
					WRITETO
					;;
				esac
			done
}


WRITETO () {	
	
	while true; do
	printf "Write a new flashcard to %s?" ${selectedset}
	read -p " [Y|n] " choice
				case "$choice" in
					y|Y )
					echo -n "Question:"
					read NQES # new question variable
					echo -n "Answer:"
					read NWAN # new answer variable
					echo -n "Hint (if any):"
					read NHIN # new hint variable
					echo "$NQES======2======$NWAN======2======$NHIN" >> sets/${selectedset}.cards #appends to bottom of unlearned list
					;;	
					
					n|N  )
						printf "exit\n"
						exit 0
					;;
					* ) 
					printf "Assuming yes\n"
					echo -n "Question:"
					read NQES # new question variable
					echo -n "Answer:"
					read NWAN # new answer variable
					echo -n "Hint (if any):"
					read NHIN # new hint variable
					echo "$NQES======2======$NWAN======2======$NHIN" >> sets/${selectedset}.cards #appends to bottom of unlearned list
					;;
				esac
		done
}

RESETLEARNED () {	
	if [ ! -e sets/"${selectedset}.cards" ]; then 
		printf "Flashcard set does not exist\n"
		exit 2
	fi
	cat sets/${selectedset}.cards.learned >> sets/${selectedset}.cards # Append contents of .cards.learned file to bottom of .cards file
	:> sets/${selectedset}.cards.learned # replace .cards.learned file with empty file of same name
	printf "All learned cards moved to unlearned set\nexit\n"
	exit 0
}

DELETESET () {	
	if [ ! -e sets/"${selectedset}.cards" ]; then
		printf "Flashcard set does not exist\n"
		exit 2
	fi
	printf "Delete flashcard set %s? "
	while true; do
				read -p "[Y|n] " choice
				case "$choice" in
					y|Y )
						rm -f sets/${selectedset}.cards.learned
						rm -f sets/${selectedset}.cards
						printf "Flashcard set deleted\nexit\n"
						exit 0
						;;
					n|N  )
						printf "User cancelled\n"
						exit 0
						;;
					* ) 
						printf "Invalid input. Operation cancelled\n"
						exit 0
						;;
				esac
			done
	
	exit 0
}

CRCT () { # function to move card from the unlearned list > learned list
	cat .temp.cards >> sets/${selectedset}.cards.learned
	grep -Fvx -f .temp.cards sets/${selectedset}.cards > remaining.list #Writes new file without correct car in it
	mv remaining.list sets/${selectedset}.cards #replaces cards list with the new file, missing the correct card, which is now in the .learned file
	printf "Moved card to learned list\n"
}

WRNG () { # function to move card from the learned list > unlearned list (if forgotten. Only used by review all mode)
	cat .temp.cards >> sets/${selectedset}.cards
	grep -Fvx -f .temp.cards sets/${selectedset}.cards.learned > remaining.list #Writes new file without incorrect card in it
	mv remaining.list sets/${selectedset}.cards.learned #replaces cards list with the new file, missing the incorrect card, which is now in the main unlearned file
	printf "Moved card to unlearned list\n\n"
}

main "$@" #calls main code from top, only after all functions have been processed (readability concerns) - bash does not allow forward declarations


