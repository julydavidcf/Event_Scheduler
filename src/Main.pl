event(start_time(H,M),Duration,Name,Year,Month,Date):-
       integer(H),integer(M),integer(Duration),integer(Year),integer(Month),integer(Date).




%event(start_time(3,4),3,test,2021,3,31).

createEvent(R):-
    write("What is this event"),
    flush_output(current_output),
    readln(Ln),

    write("What hour is the event starting?"),
    flush_output(current_output),
    readln(Ln1),

    write("What miniute the event starting?"),
    flush_output(current_output),
    readln(Ln2),

    write("How Long will the event last?"),
    flush_output(current_output),
    readln(Ln3),

    write("What year the event starting?"),
    flush_output(current_output),
    readln(Ln4),

    write("What month the event starting?"),
    flush_output(current_output),
    readln(Ln5),

    write("What day the event starting?"),
    flush_output(current_output),
    readln(Ln6),

    write(Ln),write(Ln1),write(Ln2),write(Ln3),write(Ln4),write(Ln5),write(Ln6),
    event(start_time(Ln1,Ln2),Ln3,Ln,Ln4,ln5,ln6).

