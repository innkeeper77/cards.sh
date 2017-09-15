# cards.sh
A bashscript based flashcard application

I am sure it already exists, but I need a flashcard study application. In order to get some scripting practice, I have decided to write my own in bashscript. 

The script should be saved in a folder such as ~/ or ~/flashcards. It will create a sets folder in whatever directory it is ran from, where all flashcard sets are saved

Flashcard files are text files, named <setname>.cards - Learned cards are saved in a seperate text file,  named <setname>.cards.learned

Each line within each flashcard file is an entire flashcard in the format `<question>======2======<answer>======2======<hint>`

