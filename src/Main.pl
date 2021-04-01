event(start_time(H,M),Duration,Name,Year,Month,Date):-
       integer(H),integer(M),integer(Duration),string(Name),integer(Year),integer(Month),integer(Date)