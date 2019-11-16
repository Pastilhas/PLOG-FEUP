% starting board list of lines
board([
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']] ).

% starting board list of blocks
board_blocks([
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']] ).

% starting board list of influences
board_influence([0, 0, 0, 0, 0, 0, 0, 0, 0]).

% get starting boards
start_board([BL,BB,BI]) :- board(BL), board_blocks(BB), board_influence(BI).

% make_move
make_move([X, Y], V, [BL, BB, BI], [RL, RB, RI]) :- check_move(X, Y, V, BL, BB), place_piece(X, Y, V, BL, BB, BI, RL, RB, RI).
make_move(_, _, _, _) :- msg('error move'), fail.

% check_move
check_move(X, Y, V, BL, BB) :- 
	check_x(X), check_y(Y), check_v(V), 
	check_cell(X, Y, BL), check_restrictions(X, Y, V, BL, BB).

% check_move auxiliar
check_x(X) :- valid(X).
check_y(Y) :- valid(Y).
check_v(V) :- abs(V,A), valid(A).
check_cell(X, Y, B) :- nth0(Y, B, L), nth0(X, L, ' ').
check_restrictions(X, Y, V, BL, BB) :- nl,check_line(8, Y, V, BL), check_column(X, 8, V, BL), coords_to_blocks(X, Y, B, _), check_block(B, 8, V, BB).
check_line(0, _, _, _) :- true.
check_line(X, Y, V, BL) :- nth0(Y, BL, L), nth0(X, L, V), fail.
check_line(X, Y, V, BL) :- NX is -1 + X, check_line(NX, Y, V, BL).
check_column(_, 0, _, _) :- true.
check_column(X, Y, V, BL) :- nth0(Y, BL, L), nth0(X, L, V), fail.
check_column(X, Y, V, BL) :- NY is -1 + Y, check_column(X, NY, V, BL).
check_block(_, 0, _, _) :- true.
check_block(B, N, V, BB) :- nth0(B, BB, L), nth0(N, L, V), fail.
check_block(B, N, V, BB) :- NN is -1 + N, check_block(B, NN, V, BB).

% place_piece
place_piece(X, Y, V, BL, BB, BI, RL, RB, RI) :- 
	place_piece_board(X, Y, V, BL, RL),
	coords_to_blocks(X, Y, B, N),
	place_piece_blocks(B, N, V, BB, RB),
	update_influence(BI, B, N, V, RI).

place_piece_board(X, Y, V, BL, RL) :- replace_matrix(BL, X, Y, V, RL).
place_piece_blocks(B, N, V, BB, RB) :- replace_matrix(BB, B, N, V, RB).

% update_influence
update_influence(BI, _, _, 0, BI) :- true.
update_influence(BI, B, B, V, RI) :- update_power(BI, B, V, RI).
update_influence(BI, B, 4, V, RI) :- update_power(BI, B, V, RI).
update_influence(BI, 0, 1, V, RI) :- update_power(BI, 0, V, RI).
update_influence(BI, 0, 3, V, RI) :- update_power(BI, 0, V, RI).
update_influence(BI, 2, 1, V, RI) :- update_power(BI, 2, V, RI).
update_influence(BI, 2, 5, V, RI) :- update_power(BI, 2, V, RI).
update_influence(BI, 6, 3, V, RI) :- update_power(BI, 6, V, RI).
update_influence(BI, 6, 7, V, RI) :- update_power(BI, 6, V, RI).
update_influence(BI, 8, 5, V, RI) :- update_power(BI, 8, V, RI).
update_influence(BI, 8, 7, V, RI) :- update_power(BI, 8, V, RI).
update_influence(BI, B, N, V, EI) :- update_power(BI, B, V, RI), INF is V/2, update_influence_(RI, B, N, INF, EI).

% update_influence auxiliar
update_influence_(BI, B, 0, V, EI) :- 
	B_UP is -3 + B, B_LF is -1 + B, 
	valid(B_UP), valid(B_LF),
	update_power(BI, B_UP, V, RI), update_power(RI, B_LF, V, EI).

update_influence_(BI, B, 1, V, RI) :- 
	B_UP is -3 + B, 
	valid(B_UP),
	update_power(BI, B_UP, V, RI).

update_influence_(BI, B, 2, V, EI) :- 
	B_UP is -3 + B, B_RT is B + 1, 
	valid(B_UP), valid(B_RT),
	update_power(BI, B_UP, V, RI), update_power(RI, B_RT, V, EI).
	
update_influence_(BI, B, 3, V, RI) :- 
	B_LF is -1 + B, 
	valid(B_LF),
	update_power(BI, B_LF, V, RI).

update_influence_(BI, B, 5, V, RI) :- 
	B_RT is B + 1, 
	update_power(BI, B_RT, V, RI).

update_influence_(BI, B, 6, V, EI) :- 
	B_DN is B + 3, B_LF is B + 1, 
	valid(B_DN), valid(B_LF),
	update_power(BI, B_DN, V, RI), update_power(RI, B_LF, V, EI).

update_influence_(BI, B, 7, V, RI) :- 
	B_DN is B + 3, 
	valid(B_DN),
	update_power(BI, B_DN, V, RI).

update_influence_(BI, B, 8, V, EI) :- 
	B_DN is B + 3, B_RT is B + 1,
	valid(B_DN), valid(B_RT),
	update_power(BI, B_DN, V, RI), update_power(RI, B_RT, V, EI).

% update_power
update_power([H|T], I, V, [H|R]) :- I > 0, NI is I - 1, update_power(T, NI, V, R).
update_power([OV|T], 0, V, [NV|T]) :- NV is OV + V.
