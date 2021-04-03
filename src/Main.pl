:- dynamic event/6.

validEvent(event(start_time(H,M),Duration,Name,Year,Month,Date)):-
    event(start_time(H,M),Duration,Name,Year,Month,Date),
    write("Hey, this event already exists.").

validEvent(event(start_time(H,M),Duration,Name,Year,Month,Date)):-
       integer(H),integer(M),integer(Duration),integer(Year),integer(Month),integer(Date),
       H>=0,H=<24,Duration>0.

validEvent(event(start_time(H,M),Duration,Name,Year,Month,Date)):-
    write("Hey, don't put weird stuff :("),false.


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

    %write(Ln),write(Ln1),write(Ln2),write(Ln3),write(Ln4),write(Ln5),write(Ln6),
    validEvent(event(start_time(Ln1,Ln2),Ln3,Ln,Ln4,Ln5,Ln6)),
    assert(event(start_time(Ln1,Ln2),Ln3,Ln,Ln4,Ln5,Ln6)).


%event(start_time(3,4),3,test,2021,3,31).

