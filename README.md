# cards.sh
A bashscript based flashcard application for simple studying in the terminal. 
The program remembers which questions have not yet been answered correctely, and only reviews those if desired.

## Installation
On Linux the script should not depend on any programs not included in most distros. Mac OS users will need to ensure GNU Shuf is installed.

The script should be saved in a folder such as ~/ or ~/flashcards. It will create a sets folder in whatever directory it is ran from, 
where all flashcard sets are saved.

Ensure the script is executable. If it will not run, run "chmod +x cards.sh in the script directory



### Starting program
```
./cards.sh <options> <flashcard set>

-l: learned mode, play unlearned flashcards from a set: cards.sh -l exampleset
-a: all mode: play both learned and unlearned from a set: cards.sh -a exampleset
-n: create a new flashcard set: cards.sh -n setnamehere
-w: write new flashcards in a set: cards.sh -w exampleset
-r: reset all learned cards for a set: cards.sh -r exampleset
-d: delete a flashcard set: cards.sh -d exampleset
-s: List all available flashcard sets: cards.sh -s
```



### Usage

##### Create a flashcard set
To use this program to create flashcard sets in the terminal, call the program with ```./cards.sh -n <setname>```
If desired you may create sets by using the specific file format below. It may be beneficial to create a sample set within the program to demonstrate the correct file format. 

##### Study off flashcards
When studying, you can use two different modes. Learned, and all. Learned mode will only ask you questions you did not previously answer correctly, while all mode will ask you questions from anywhere in the set.

```./cards.sh -l <setname>``` for learned mode

```./cards.sh -a <setname>``` for all mode

When you are asked a question, think about or write down your answer. Use a hint if you need to by pressing 'h'. Once you are done, check your answer by pressing "a"
If you knew the answer, press "y". This will transfer this question into your 'learned' set, so it will not ask you again when in learned mode. If you wish to review, 
you may reset all questions to "unlearned" by calling the program with ```./cards.sh -r <setname>```

#### File Format
Flashcard files are text files, named <setname>.cards - Learned cards are saved in a separate text file,  named <setname>.cards.learned
As of Oct. 5 18, flashcard files will now be csv files instead of the "proprietary" format used before. Using | as delimiter- please do
not include "|" in your set answers if you are creating it manually. The script will remove any "|" if you are creating a set using the script

These set files are saved within a subdirectory, sets/

Each line within each flashcard file is an entire flashcard in the format ```<question>|<answer>|<hint>```

