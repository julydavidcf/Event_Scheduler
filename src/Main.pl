:- module(
  event,
  [
    add_event/8, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer, +Tag:atom
    delete_event/8, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer, +Tag:atom
    delete_all_event/0, % +Hour:integer, +Minute:integer, +Duration:integer, +Name:atom, +Year:integer, +Month:integer, +Date:integer, +Tag:atom
    current_event/8 % ?Hour:integer, ?Minute:integer, ?Duration:integer, ?Name:atom, ?Year:integer, ?Month:integer, ?Date:integer, ?Tag:atom
  ]
).
dateCal/6.

:- use_module(library(persistency)).

:- persistent(event(hour:integer,minute:integer,duration:integer,name:atom,year:integer,month:integer,date:integer,tag:atom)).

:- initialization(db_attach('scheduleKeeper.pl',[])).


add_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag):-
   with_mutex(event_db, assert_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag)).

current_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag):-
    with_mutex(event_db,event(Hour,Minute,Duration,Name,Year,Month,Date,Tag)).


delete_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag):-
   with_mutex(event_db, retract_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag)).

delete_all_event:-
   with_mutex(event_db, retractall_event(Hour,Minute,Duration,Name,Year,Month,Date,Tag)).




createEvent:-
    write("What is this event?   "),
    flush_output(current_output),
    readln([Ln|X]),

    write("What hour is the event starting?(0-23)   "),
    flush_output(current_output),
    readln([Ln1|X]),

    write("What miniute the event starting?(0-59)   "),
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

    write("Specify a tag.  "),
    flush_output(current_output),
    readln([Ln7|X]),
    addValidEvent(event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6,Ln7)),
     add_event(Ln1,Ln2,Ln3,Ln,Ln4,Ln5,Ln6,Ln7).

addValidEvent(event(H,M,Duration,Name,Year,Month,Date,Tag)):-
    event(H,M,Duration,Name,Year,Month,Date,Tag),
    write("Hey, this event already exists.").

addValidEvent(event(H,M,Duration,Name,Year,Month,Date,Tag)):-
   integer(H),integer(M),integer(Duration),integer(Year),integer(Month),integer(Date), H>=0,H<24,M>=0,M=<59,Duration>0,Year>0,Month>0,Date>0,Month=<12,validDate(Year,Month,Date).


addValidEvent(event(H,M,Duration,Name,Year,Month,Date,Tag)):-
    write("Hey, don't put weird stuff :("),false.

validDate(Y,2,D):- (X is mod(Y,4)),(D=<29),X==0.
validDate(Y,2,D):- (X is mod(Y,4)),(D=<28).
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M<8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<31),(M>=8),X==0.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M>=8),X==1.
validDate(_,M,D):- (X is mod(M,2)),(D=<30),(M<8),(M-2>0),X==0.

removeEvent(H,M,Duration,Name,Year,Month,Date,Tag):-
    %retract(event(H,M,Duration,Name,Year,Month,Date)),
    delete_event(H,M,Duration,Name,Year,Month,Date,Tag).

listEvent:-
    event(H,M,Duration,Name,Year,Month,Date,Tag),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").

todaysEvent:-
    today(Year,Month,Date),
    event(H,M,Duration,Name,Year,Month,Date,Tag),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    write(Name),write("("),write(Tag),write(")"),write(" starts today at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       "),write("due today.").

tagged(Tag):-
    event(H,M,Duration,Name,Year,Month,Date,Tag),today(X,Y,Z),dateCal(X,Y,Z,Year,Month,Date,R),
    write(Name),write("("),write(Tag),write(")"),write(" starts at "),write(Year),write("-"),write(Month),write("-"),
    write(Date),write(" at "),write(H),write(":"),write(M),write(" and lasts for "),write(Duration),
    write(" hour(s)       due in "),write(R),write(" days.").



today(Year,Month,Day) :-
    get_time(T),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    stamp_date_time(T, DateTime, local).

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




