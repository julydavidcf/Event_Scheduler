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

### createEvent:-
* creates an event accoring to the user's information in KB
* The user needs to specify a name, starting hour, starting minute, duration, year, month, day, and a tag for the event.
* The event created will be givin a tag in range 1000->9999
* calls on update when event is created

### checkOut:-
* removes an event from KB by id accoridng to the user

### checkAll:-
* reoves all exisitng events from KB

### listEvent:-
* lists all event existing in KB
* calls on update when listing
* press ";" until all event is shown

### todaysEvent:-
* lists all event existing in KB that is due today
* calls on update when listing
* press ";" until all event is shown
* greets the user according to the date & if today is a BC holiday

### tagged(Tag):-
* lists all event existing in KB that has the specific tag
* calls on update when listing
* press ";" until all event is shown

### checkId:-
* get an event by ID

### modifyName
* modifies the name of an event with the givin ID

### modifyNTag
* modifies the tag of an event with the givin ID

### holiday
* tells the user about the next BC holiday



### References:
The Canadian Holiday API: https://canada-holidays.ca/api
