# cards.sh
A bashscript based flashcard application inspired by [Joliv: fla.sh](https://github.com/joliv/fla.sh), but independently written and designed differently

[![cardssh.gif](https://s26.postimg.org/3yd7sczfd/cardssh.gif)](https://postimg.org/image/km4puuu6t/)

## Installation
The script should be saved in a folder such as ~/ or ~/flashcards. It will create a sets folder in whatever directory it is ran from, where all flashcard sets are saved

"This script depends on GNU `shuf`, which comes bundled on most Linux distros, but not on OSX. 
For OSX install shuf using [Homebrew](http://brew.sh) with `brew install coreutils`
Then `shuf` is installed as `gshuf`, so alias it with (`alias shuf='gshuf'`) 
(Thanks [Joliv: fla.sh](https://github.com/joliv/fla.sh) for OSX info on shuf)

### Usage:
```
cards.sh <options> <flashcard set>

-l: learned mode, play unlearned flashcards from a set: cards.sh -l exampleset
-a: all mode: play both learned and unlearned from a set: cards.sh -a exampleset
-n: create a new flashcard set: cards.sh -n setnamehere
-w: write new flashcards in a set: cards.sh -w exampleset
-r: reset all learned cards for a set: cards.sh -r exampleset
-d: delete a flashcard set: cards.sh -d exampleset
-s: List all available flashcard sets: cards.sh -s
```

Flashcard files are text files, named <setname>.cards - Learned cards are saved in a seperate text file,  named <setname>.cards.learned

Each line within each flashcard file is an entire flashcard in the format:

`<question>======2======<answer>======2======<hint>`

