# cards.sh
WIP: Terminal based flashcard application

I am sure it already exists, but I need a flashcard study application. In order to get some scripting practice, I have decided to write my own in bashscript. As of this point, the program can play back flashcard sets in two modes. Unlearned cards only, and review all mode. 

Flashcard files must be saved in a "sets" folder within the directory housing the script

Flashcard files are text files, named <setname>.cards

Each line within the file is the format <question>======2======<answer>======2======<hint>
======2======

Todo:
1. flashcard set creation
2. flashcard writing to existing set
3. reset learned cards for a set function
4. flashcard set deletion
5. flashcard set listing function
