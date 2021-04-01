event(start_time(H,M),Duration,Name,Year,Month,Date):-
       integer(H),integer(M),integer(Duration),string(Name),integer(Year),integer(Month),integer(Date).

event(start_time(3,4),3,test,2021,3,31).

