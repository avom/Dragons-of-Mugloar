# Dragons of Mugloar

Plays the game at http://www.dragonsofmugloar.com/ and consistently winning.

## Usage

Release binary is compiled for Windows. It is a command line application which takes one argument: the number of games to play. For example to play 100 games use:

    DragonsOfMugloar.exe 100

## Code, tools

Compiled and tested with Delphi XE5 in Windows. Uses (included in repository) superobject library for working with JSON.

## Strategy

### Everyday regular normal weather

This one is the only weather that actually requires some effort to beat. For that there's a table of winning dragon for each possible knight:

* Knights attribute never exceeds 8 and his attributes sum up to 20. This means that there are 381 possible distinct knights.
* For two knights that have the same attribute values, but allocated differently (i. e. two different permutation of same set of attribute values), if a dragon can beat one of the knights then another dragon with same attributes in corresponding permutation can beat the second knight. For example if a knight with attack 8, armor 7, agility 3 and endurance 2 is beaten by a dragon with scale thickness 10, claw sharpness 5, wing strength 4 and fire breath 1, then we also know that knight with attack 3, armor 8, agility 2, endurance 7 is beaten by a dragon with scale thickness 4, claw sharpness 10, wing strength 1 and fire breath 5. There are 27 different sets of attribute values for knight, so that's the number of entries in the table of solutions.
* Building that table isn't too large of task. Since maximum attribute of a dragon is 10, we have 891 possible different dragons. This means that expected number of games that need to be played is 105 + 27 * (891 - 1) = 24135. Actually only a fraction of this is needed since for each knight we can stop search for winning dragon as soon as we find first.

If we already building the table we just look up for the correct entry and find the return the correct permutation of winning dragon attributes.

### Storm

Easy to beat. Don't send anything (don't put a dragon argument).

### Heavy rain with floods

Looks like easy win as well. It seems using scale thickness and claw sharpness 10 kills any incoming knight.

### The long dry

Seems another easy win. The description hints that a balanced dragon should be sent. Sending a dragon with all attributes at 5 seems to be winning everything.

### Fog

Probably the easiest to win. Any dragon wins as long as you assign valid attribute values.
