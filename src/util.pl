get_option(OP):-
    get_char(OP),
    get_char(_).

wait_enter:-get_char(_).


get_string_(10,Acc,Acc).

get_string_(Ch,Acc,String) :-
    get_code(NCh),
    get_string_(NCh,[Ch|Acc],String).

get_string(String) :-
    get_code(Ch),
    get_string_(Ch,[],InvString),
    reverse(InvString, String).  
    


get_player(Player) :- 
	write('Player name'), nl,
	write('     ?- '),
	get_string(Player),
	clear.