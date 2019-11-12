% get_option
% Option    - return option
get_option(M,O):-
    write(M),
    get_char(O),
    get_char(_).

get_int(M,I):-
    write(M),
    get_code(C),
    get_char(_),
    I is C - 48.

wait_enter:-get_char(_).

get_string_(10,Acc,Acc).

get_string_(Ch,Acc,String):-
    get_code(NCh),
    get_string_(NCh,[Ch|Acc],String).

get_string(String):-
    get_code(Ch),
    get_string_(Ch,[],InvString),
    reverse(InvString,String).

get_player(Player):-
	write('Player name'),nl,
	write('     ?- '),
	get_string(Player).

% wait_enter
wait_enter:-get_char(_).

% replace
% List      - list to replace
% Index     - index of element start at 0
% Value     - value to replace
% NewList   - return list
replace([_|T],0,V,[V|T]).
replace([H|T],I,V,[H|R]):-
    I > 0,NI is I - 1,
    replace(T,NI,V,R),!.

% replace_matrix
% Matrix    - matrix to replace
% X         - x coordinate of cell
% Y         - y coordinate of cell
% Value     - value to replace
% NewMatrix - return matrix
replace_matrix([C|L],X,0,V,[F|L]):- replace(C,X,V,F).
replace_matrix([F|L],X,Y,V,[F|R]):-
    Y > 0,NY is Y - 1,
    replace_matrix(L,X,NY,V,R),!.

% coords_to_blocks
% X,Y       - coordinates
% B,N       - block and number
coords_to_blocks(X,Y,B,N):-
    N is mod(X,3) + mod(Y*3,9),
    B is div(X,3) + 3*div(Y,3).

% get_player
% Player 	- player name
get_player(Payer):-
	write('Player name'),nl,
	write('     ?- '),
	read(Player).
