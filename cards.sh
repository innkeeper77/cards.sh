#!/bin/sh
# cards.sh: command line flashcard study tool

# Adding in argument count processing code. Currently I am just seeing what works

# First, check for arguments. If none, print help and exit

main () { # Main code is wrapped, and called at bottom of script. This is so functions can be declared at the bottom of the code instead of the top, for improved readability

if [ $# -eq 0 ]; then
  printf -- "No arguments. Use -h for help\n"
fi
	
# using getopts to parse command line options
while getopts "l:a:n:w:r:d:hs" opt; do #lanwrd - all take one argument
	case ${opt} in
		l ) #learned mode playback
			LEARNED
			;;
		a )_#all mode playback- ignore learned
			ALL
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

}

#Help function
HELP () {
	printf "Usage:\n"
	printf "cards.sh <options> <flashcard set>\n\n"
	printf -- "-l: learned mode (default) Play only flashcards not marked as learned: cards.sh -l exampleset\n"
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
	printf "Code not yet implemented. Todo: incorporate learned playback function\n"
}

ALL () {	
	printf "Code not yet implemented. Todo: incorporate all mode playback function\n"
}

NEWSET () {	
	printf "Code not yet implemented. Todo: incorporate new set function\n"
	## When done, prompt to go to card creation in new set
}

WRITETO () {	
	printf "Code not yet implemented. Todo: incorporate write cards function\n"
}

RESETLEARNED() {	
	printf "Code not yet implemented. Todo: create function to reset learned list\n"
}

DELETESET() {	
	printf "Code not yet implemented. Todo: create function to delete a set and related files\n"
}

main "$@" #calls main code from top, only after all functions have been processed


