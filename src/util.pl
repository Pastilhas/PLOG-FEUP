% get_option
% Option    - return option
get_option(OP) :-
    get_char(OP),
    get_char(_).

% wait_enter
wait_enter:-get_char(_).

% replace
% List      - list to replace
% Index     - index of element start at 0
% Value     - value to replace
% NewList   - return list
replace([_|T],0,V,[V|T]).
replace([H|T],I,V,[H|R]) :-
    I > 0,NI is I - 1,
    replace(T,NI,V,R),!.

% replace_matrix
% Matrix    - matrix to replace
% X         - x coordinate of cell
% Y         - y coordinate of cell
% Value     - value to replace
% NewMatrix - return matrix
replace_matrix([C|L],X,0,V,[F|L]) :- replace(C,X,V,F).
replace_matrix([F|L],X,Y,V,[F|R]) :-
    Y > 0,NY is Y - 1,
    replace_matrix(L,X,NY,V,R),!.

% coords_to_blocks
% X,Y       - coordinates
% B,N       - block and number
coords_to_blocks(X,Y,B,N) :-
    N is mod(X,3) + mod(Y*3,9),
    B is div(X,3) + 3*div(Y,3).

% get_player
% Player 	- player name
get_player(Payer) :-
	write('Player name'),nl,
	write('     ?- '),
	read(Player),
	clear.