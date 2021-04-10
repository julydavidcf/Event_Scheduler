# Event Scheduler
Authors: David, Johnson

## What is the this?
For the project, we are consturcting mini event schedualer in prolog. This application includes functionalities such as add/remove events, and list them in various ways. The application also reads the local time from the PC and holidays throught and API to make date calculation and holiday checking.
## How to run
* make sure cd to the correct directory
* compile and start with the following
* load main.pl

## All Public Functions

### update:-
* clears all events that passed the due date
* 
### createEvent:-
* creates an event accoring to the user's information in KB
* calls on update when event is created

### checkOut:-
* removes an event from KB by id accoridng to the user

### checkAll:-
* reoves all exisitng events from KB

### listEvent:-
* lists all event existing in KB
* calls on update when listing
* press ";" until all event is shown

### Move.hs
* Contains a dataset of all available moves for the Pokemons

### Pokemon.hs
* Contains a dataset of all available Pokemons

### State.hs
* Contains functions related to game states
* important functions: State, Game

### Type.hs
* Contains a dataset of all multiplier with every pair of type(different elements in Pokemon) for damage calculation

### UserGetMove.hs
* Contains functions related to get user selected moves
* important functions: getMove, findChosenMove


### References:
Some Non-Pokemon Template Code is from: https://github.com/HeinrichApfelmus/threepenny-gui
