:- module(
  event,
  [
    add_event/7, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer
    delete_event/7, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer
    delete_all_event/7, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer
    current_event/7 % ?Hour:integer, ?Minute:integer, ?Duration:integer, ?Name:atom, ?Year:integer, ?Month:integer, ?Date:integer
  ]
).

:- use_module(library(persistency)).

:- persistent(event(hour:integer,minute:integer,duration:integer,name:atom,year:integer,month:integer,date:integer)).

:- initialization(db_attach('scheduleKeeper.pl',[])).


add_event(Hour,Minute,Duration,Name,Year,Month,Date):-
   with_mutex(event_db, assert_event(Hour,Minute,Duration,Name,Year,Month,Date)).

current_event(Hour,Minute,Duration,Name,Year,Month,Date):-
    with_mutex(event_db,event(Hour,Minute,Duration,Name,Year,Month,Date)).


delete_event(Hour,Minute,Duration,Name,Year,Month,Date):-
   with_mutex(event_db, retract_event(Hour,Minute,Duration,Name,Year,Month,Date)).

delete_all_event(Hour,Minute,Duration,Name,Year,Month,Date):-
   with_mutex(event_db, retractall_event(Hour,Minute,Duration,Name,Year,Month,Date)).


createEvent(R):-
    write("What is this event?   "),
    flush_output(current_output),
    readln([Ln|X]),

    write("What hour is the event starting?   "),
    flush_output(current_output),
    readln([Ln1|X]),

    write("What miniute the event starting?   "),
    flush_output(current_output),
    readln([Ln2|X]),

    write("How many hours will the event last?(min 1 hr)   "),
    flush_output(current_output),
    readln([Ln3|X]),

    write("What year the event starting?   "),
    flush_output(current_output),
    readln([Ln4|X]),

    write("What month the event starting?   "),
    flush_output(current_output),
    readln([Ln5|X]),

    write("What day the event starting?   "),
    flush_output(current_output),
    readln([Ln6|X]),

    addValidEvent(event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6)),
     add_event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6).

addValidEvent(event(H,M,Duration,Name,Year,Month,Date)):-
    event(H,M,Duration,Name,Year,Month,Date),
    write("Hey, this event already exists.").

addValidEvent(event(H,M,Duration,Name,Year,Month,Date)):-
   integer(H),integer(M),integer(Duration),integer(Year),integer(Month),integer(Date), H>=0,H=<24,M>=0,M=<59,Duration>0,Year>0,Month>0,Date>0,Month=<12,validDate(Year,Month,Date),
  assert(event(H,M,Duration,Name,Year,Month,Date)).


addValidEvent(event(H,M,Duration,Name,Year,Month,Date)):-
    write("Hey, don't put weird stuff :("),false.

validDate(Y,2,D):- (X is mod(Y,4)),(D=<29),X==0.
validDate(Y,2,D):- (X is mod(Y,4)),(D=<28).
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M<8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M>=8),X==0.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M>=8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M<8),(M-2>0),X==0.

removeEvent(H,M,Duration,Name,Year,Month,Date):-
    retract(event(H,M,Duration,Name,Year,Month,Date)).
    delete_event(H,M,Duration,Name,Year,Month,Date).

listEvent:-
    event(H,M,Duration,Name,Year,Month,Date),
    write(Name),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)").

todaysEvent:-
    today(Year,Month,Date),
    event(H,M,Duration,Name,Year,Month,Date),
    write(Name),write(" starts today at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)").


today(Year,Month,Day) :-
    get_time(T),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    stamp_date_time(T, DateTime, local).



