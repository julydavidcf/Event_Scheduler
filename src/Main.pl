%initialization
%====================================================================
:-dynamic add_event/9, delete_event/9, checkAll/0, dateCal/6.
dateCal/6.
:-[holiday].
:- use_module(library(persistency)).

:- persistent(event(hour:integer,minute:integer,duration:integer,name:atom,year:integer,month:integer,date:integer,tag:atom,id:integer)).

:- initialization(db_attach('scheduleKeeper.pl',[])).

%user functions
%===================================================================================

%clears all event that passed the due date
update:-
    today(G,L,J),deleteBeforeToday(G,L,J).

%creats an event according to the user
createEvent:-
    write("What is this event?(must start with a lowercase letter)   "),
    flush_output(current_output),
    readln([Ln|X]),  atom(Ln),

    write("What hour is the event starting?(0-23)   "),
    flush_output(current_output),
    readln([Ln1|X]), integer(Ln1),Ln1>=0,Ln1<24,

    write("What miniute the event starting?(0-59)   "),
    flush_output(current_output),
    readln([Ln2|X]),integer(Ln2),Ln2>=0,Ln2=<59,

    write("How many hours will the event last?(min 1 hr)   "),
    flush_output(current_output),
    readln([Ln3|X]),integer(Ln3), Ln3>0,

    write("What year the event starting?   "),
    flush_output(current_output),
    readln([Ln4|X]),integer(Ln4),Ln4>0,

    write("What month the event starting?   "),
    flush_output(current_output),
    readln([Ln5|X]),integer(Ln5),Ln5>0, Ln5<13,

    write("What day the event starting?   "),
    flush_output(current_output),
    readln([Ln6|X]),integer(Ln6),Ln6>0,validDate(Ln4,Ln5,Ln6),

    write("Specify a tag.(must start with a lowercase letter)  "),
    flush_output(current_output),
    readln([Ln7|X]),  atom(Ln7),

    idGen(1000,ID),
    write("Your event is created with ID: "), write(ID),
    write("   press ENTER to contiune"),

%    addValidEvent(event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6,Ln7,ID)),
     add_event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6,Ln7,ID),
     update.

createEvent:-
    write("Hey, please follow the format :("),false.

%removes a event by user
checkOut:-
    update,
    write("What's the id of the event you want to remove? "),
    flush_output(current_output),
    readln([ID|_]),
    removeEvent(_,_,_,_,_,_,_,_,ID),
    write("Event "),write(ID),write(" removed.").

%clears all events from KB
checkAll:-
   with_mutex(event_db, retractall_event(_,_,_,_,_,_,_,_,_)).


%lists all events in KB
listEvent:-
    today(G,L,J),deleteBeforeToday(G,L,J),
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).

%lists all events that is due today and greets the user according to the date today & holidays
todaysEvent:-
    today(Year,Month,Date),deleteBeforeToday(Year,Month,Date),isTodayHoliday(Year,Month,Date),nearestHoliday(_,XX),
    write("Today is "),write(XX),write("! Get some rest in this extra break day."),
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).

todaysEvent:-
    today(Year,Month,Date),deleteBeforeToday(Year,Month,Date),not(isTodayHoliday(Year,Month,Date)),
    isTodayWeekend(Year,Month,Date),
    write("It's weekend! Take a good break!\n"),
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).

todaysEvent:-
    today(Year,Month,Date),deleteBeforeToday(Year,Month,Date),not(isTodayHoliday(Year,Month,Date)),
    not(isTodayWeekend(Year,Month,Date)),
    write("Today is a work day! Don't overwork yourself, and make sure to get some exercise afterward!\n"),
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).

%lists all events with a speific tag
tagged(Tag):-
   today(G,L,J),deleteBeforeToday(G,L,J),
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).


%get an event by id
checkId:-
   write("What's the id of the event? "),
   flush_output(current_output),
   readln([ID|_]),
    update,
    event(H,M,Duration,Name,Year,Month,Date,Tag,ID),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R).


%modifies the name of a specific event
modifyName:-
   update,
   write("What's the id of the event? "),
   flush_output(current_output),
   readln([ID|_]),
   event(_,_,_,Nx,_,_,_,_,ID),
   write("What would you like the original name '"), write(Nx),write("' to?   "),
   flush_output(current_output),
   readln([Ln6|_]),
   removeEvent(Hour,Minute,Duration,_,Year,Month,Date,Tag,ID),
   add_event(Hour,Minute,Duration,Ln6,Year,Month,Date,Tag,ID),
   today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
   printEvent(event(Hour,Minute,Duration,Ln6,Year,Month,Date,Tag,ID),R).

%modifies the tag of a specific event
modifyTag:-
   update,
   write("What's the id of the event? "),
   flush_output(current_output),
   readln([ID|_]),
   event(_,_,_,_,_,_,_,Nx,ID),
   write("What would you like the original tag '"), write(Nx),write("' to?   "),
   flush_output(current_output),
   readln([Ln6|_]),
   removeEvent(Hour,Minute,Duration,Name,Year,Month,Date,_,ID),
   add_event(Hour,Minute,Duration,Name,Year,Month,Date,Ln6,ID),
   today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
   printEvent(event(Hour,Minute,Duration,Name,Year,Month,Date,Ln6,ID),R).

%tells the user about the next BC holiday
holiday:-
    write("The next holiday is "), nearestHoliday(K,X), write(X),write(" on "), write(K), write(", be prepared for it!").


%helper functions.
%==================================================================================
%adds an event to the KB
add_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag,ID):-
   with_mutex(event_db, assert_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag,ID)).


%delete a specific event from KB
delete_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag,ID):-
   with_mutex(event_db, retract_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag,ID)).




%checks if the dats is valid
validDate(Y,2,D):- (X is mod(Y,4)),(D=<29),X==0.
validDate(Y,2,D):- (_ is mod(Y,4)),(D=<28).
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M<8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M>=8),X==0.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M>=8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M<8),(M-2>0),X==0.

%seconday call on delete event
removeEvent(H,M,Duration,Name,Year,Month,Date,Tag,ID):-
    delete_event(H,M,Duration,Name,Year,Month,Date,Tag,ID).



%generates a unique id for an event from 1000->9999
idGen(A,B):-
    not(event(_,_,_,_,_,_,_,_,A)), B is A.
idGen(A,B):-
    X is A+1,
    X<10000,
    idGen(X,B).
idGen(_,_):-
    write("You've got too many events!"),false.

%prints a event
printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R):-
    H>=10,
    M>=10,
    write("id: "),write(ID),write("  "),write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").

printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R):-
    H<10,
    M>=10,
    write("id: "),write(ID),write("  "),write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write("0"),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").

printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R):-
    M<10,
    H>=10,
    write("id: "),write(ID),write("  "),write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write(H),write(":"),write("0"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").

printEvent(event(H,M,Duration,Name,Year,Month,Date,Tag,ID),R):-
    M<10,
    H<10,
    write("id: "),write(ID),write("  "),write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write("0"),write(H),write(":"),write("0"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").


%returns the system time for today
today(Year,Month,Day) :-
    get_time(T),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    stamp_date_time(T, DateTime, local).



%calculate the number of days between the two given dates
%second date must be later than the first date
dateCal(Y1,M1,D1,Y1,M1,D2,R):-
    R is (D2-D1).

dateCal(Y1,2,D1,Y1,M2,D2,R):-
    (X is mod(Y1,4)),X==0,dateCal(Y1,3,0,Y1,M2,D2,Y),dif(M2,2),
    (R is (29-D1)+Y).

dateCal(Y1,2,D1,Y1,M2,D2,R):-
    (X is mod(Y1,4)),X>0,
    dateCal(Y1,3,0,Y1,M2,D2,Y),dif(M2,2),
    (R is (28-D1)+Y).

dateCal(Y1,M1,D1,Y1,M2,D2,R):-
    (X is mod(M1,2)),X==1,M1<8,M is M1+1,dif(M2,M1),dateCal(Y1,M,0,Y1,M2,D2,Y),(R is (31-D1)+Y).

dateCal(Y1,M1,D1,Y1,M2,D2,R):-
    (X is mod(M1,2)),X==0,M1<8,M is M1+1,dif(M2,M1),dateCal(Y1,M,0,Y1,M2,D2,Y),(R is (30-D1)+Y),dif(M1,2).

dateCal(Y1,M1,D1,Y1,M2,D2,R):-
    (X is mod(M1,2)),X==1,M1>=8,M is M1+1,dif(M2,M1),dateCal(Y1,M,0,Y1,M2,D2,Y),(R is (30-D1)+Y).

dateCal(Y1,M1,D1,Y1,M2,D2,R):-
    (X is mod(M1,2)),X==0,M1>=8,M is M1+1,dif(M2,M1),dateCal(Y1,M,0,Y1,M2,D2,Y),(R is (31-D1)+Y),dif(M1,2).

dateCal(Y1,M1,D1,Y2,M2,D2,R):-
    Y is Y1+1,dif(Y2,Y1),
    dateCal(Y,1,0,Y2,M2,D2,A),dateCal(Y1,M1,D1,Y1,12,31,Z),
    (R is Z+A).

%removes all events from the KB before a certain date
deleteBeforeToday(Year,Month,Day):-
   event(A,B,C,D,X,E,F,G,H),
   X < Year,
   removeEvent(A,B,C,D,X,E,F,G,H),
   deleteBeforeToday(Year,Month,Day).

deleteBeforeToday(Year,Month,Day):-
   event(A,B,C,D,Year,X,E,F,G),
   X<Month,
   removeEvent(A,B,C,D,Year,X,E,F,G),
   deleteBeforeToday(Year,Month,Day).

deleteBeforeToday(Year,Month,Day):-
   event(A,B,C,D,Year,Month,X,E,F),
   X<Day,
   removeEvent(A,B,C,D,Year,Month,X,E,F),
   deleteBeforeToday(Year,Month,Day).

deleteBeforeToday(_,_,_):-
   true.



