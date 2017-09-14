### Usage
cards.sh #Main program, if called without arguments, should give usage instructions, and return 0.
<br />
Note: consider implementing an optional hint system
```
Usage:
cards.sh <options> <flashcard set>

-l: learned mode (default) Play only flashcards not marked as learned: cards.sh -l exampleset
-a: play all flashcards randomly, ignore learned list: cards.sh -a exampleset
-n: create a flashcard set: cards.sh -n setnamehere
-w: write to flashcards in a set: cards.sh -w exampleset
-r: reset learned cards for a set: cards.sh -r exampleset
-d: delete flashcard set: cards.sh -d exampleset
-s: List all flashcard sets in folder: cards.sh s
```
<br />

### Program setup and structure
Script is designed to run in any folder, such as ~/flashcards <br />
Flashcard sets will simply be subfolders within the flashcard folder, with the folder name being the set name <br />
Flashcards themselves are individual files within the set subfolder, one per card. <br />
  Name of file is the question, to prevent issues like deleting number 15 and having to resort, or having to use resources to count number of existing cards<br />
  Within file: "Answer:" is at start, program writes or reads answer after that header
  Later, "Hint:" may become an option. Having the "answer:" header allows this to easily be integrated
Learned flashcards are stored in a single file for that problem set. "learned.setname" This file is stored in the main flashcards directory, not within the set itself. It should be readable in plain english if the user wishes to edit the learned list manually
If user types anything into 
<br />


### Playing a set
```
cards.sh biology
9: In photosynthesis, what opens to let in air, and release oxygen? 
  (user presses enter when ready, and can type in their answer if desired, which is stored in learned.setname file)
Answer: Stomata 
Correct? [Y/N/x] #user presses enter when ready. If nothing entered, assumed not learned. If learned, add to learned.setname file
47: What is an enzyme?
Answer: Enzymes are macromolecular biological catalysts that accelerate chemical reactions. 
Correct? [Y/N/Yx/x]x #user entered x, so program exists
```

