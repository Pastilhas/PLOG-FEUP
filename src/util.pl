% get_option
% Option    - return option
get_option(M, O) :- write(M), get_char(O), get_char(_).

% get_int
get_int(M, I) :- write(M), get_code(C), C > 47, C < 58, get_code(10), I is C - 48.
get_int(M,I) :- write('Invalid number\n'), get_int(M,I).

% abs
abs(N,Abs) :- number(N), N  >= 0, Abs = N.
abs(N,Abs) :- number(N), N < 0, Abs is -N.

% valid
valid(N) :- N >= 0, N =< 8.

% get_string
get_string(String) :- get_code(Ch), get_string_(Ch, [], InvString), reverse(InvString, String).
get_string_(10, Acc, Acc).
get_string_(Ch, Acc, String) :- get_code(NCh), get_string_(NCh, [Ch|Acc], String).

% get_player
% Player 	- player name
get_player(Player) :- write('Player name'), nl, write('     ?- '), get_string(Player).

% wait_enter
wait_enter :- get_char(_).

% replace
% List      - list to replace
% Index     - index of element start at 0
% Value     - value to replace
% NewList   - return list
replace([_|T], 0, V, [V|T]).
replace([H|T], I, V, [H|R]) :- I > 0, NI is I - 1, replace(T, NI, V, R).

% replace_matrix
% Matrix    - matrix to replace
% X         - x coordinate of cell
% Y         - y coordinate of cell
% Value     - value to replace
% NewMatrix - return matrix
replace_matrix([C|L], X, 0, V, [F|L]) :- replace(C, X, V, F).
replace_matrix([F|L], X, Y, V, [F|R]) :- Y > 0, NY is Y - 1, replace_matrix(L, X, NY, V, R).

% coords_to_blocks
% X, Y       - coordinates
% B, N       - return block and number
coords_to_blocks(X, Y, B, N) :- N is mod(X, 3) + mod(Y*3, 9), B is div(X, 3) + 3*div(Y, 3).


% get_move
% X, Y       - coordinates
% V         - value
get_move(X, Y, V) :- get_int('Value: ', V), get_int('    X: ', X), get_int('    Y: ', Y).

% d) even(N) -> True if N is even
even(N) :- 0 is mod(N,2).

% msg
msg(M) :- nl,write(M),nl.

% cls
cls :- write('\e[H\e[2J').
