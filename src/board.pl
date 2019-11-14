:-dynamic(board/1).
:-dynamic(board_blocks/1).
:-dynamic(board_influence/1).

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

% destroy_board
% BL, BB, BI - return boards
destroy_board(BL, BB, BI):-board(BL), retract(board(BL)), board_blocks(BB), retract(board_blocks(BB)), board_influence(BI), retract(board_influence(BI)).

% save_board
% BL, BB, BI - boards to assert
save_board(BL, BB, BI):-assertz(board(BL)), assertz(board_blocks(BB)), assertz(board_influence(BI)).

% make_move
% X, Y 	- coordinates
% V		- value
make_move(X, Y, V, BL, BB, BI, RL, RB, RI):-check_move(X, Y, V, BL, BB), !, place_piece(X, Y, V, BL, BB, BI, RL, RB, RI).

% check_move
% X, Y 	- coordinates
% V 	- value
check_move(X, Y, V, BL, BB):-check_x(X), check_y(Y), check_v(V), check_cell(X, Y, BL), check_restrictions(X, Y, V, BL, BB).
check_move(_, _, _, _):-write('error move'), nl, fail.

% check_move auxiliar
check_x(X):-X >= 0, X =< 8.
check_y(Y):-Y >= 0, Y =< 8.
check_v(V):-V >= 0, V =< 8.
check_v(V):-V =< -1, V >=-8.
check_cell(X, Y, B):-nth0(Y, B, L), nth0(X, L, ' ').
check_restrictions(X, Y, V, BL, BB):-nl,check_line(8, Y, V, BL), check_column(X, 8, V, BL), coords_to_blocks(X, Y, B, _), check_block(B, 8, V, BB).
check_line(0, _, _, _):-true.
check_line(X, Y, V, BL):-nth0(Y, BL, L), nth0(X, L, V), fail.
check_line(X, Y, V, BL):-NX is -1 + X, check_line(NX, Y, V, BL).
check_column(_, 0, _, _):-true.
check_column(X, Y, V, BL):-nth0(Y, BL, L), nth0(X, L, V), fail.
check_column(X, Y, V, BL):-NY is -1 + Y, check_column(X, NY, V, BL).
check_block(_, 0, _, _):-true.
check_block(B, N, V, BB):-nth0(B, BB, L), nth0(N, L, V), fail.
check_block(B, N, V, BB):-NN is -1 + N, check_block(B, NN, V, BB).

% update_power
update_power([OV|_], 0, V, [NV|_]):-NV=OV + V.
update_power([H|T], B, V, [H|R]):-B >0, NB is -1 + B, update_power(T, NB, V, R).

% update_influence
update_influence(_, _, _, 0, _):-true.
update_influence(_, _, 4, _, _):-true.
update_influence(_, B, B, _, _):-true.
update_influence(_, 0, 1, _, _):-true.
update_influence(_, 0, 3, _, _):-true.
update_influence(_, 2, 1, _, _):-true.
update_influence(_, 2, 5, _, _):-true.
update_influence(_, 6, 3, _, _):-true.
update_influence(_, 6, 7, _, _):-true.
update_influence(_, 8, 5, _, _):-true.
update_influence(_, 8, 7, _, _):-true.
update_influence(BI, B, N, V, RI):-INF is V/2, update_influence_(BI, B, N, INF, RI).

% update_influence auxiliar
update_influence_(BI, B, 0, V, RI):-B_UP is -3 + B, B_LF is -1 + B, update_power(BI, B_UP, V, RI), update_power(BI, B_LF, V, RI).
update_influence_(BI, B, 1, V, RI):-B_UP is -3 + B, update_power(BI, B_UP, V, RI).
update_influence_(BI, B, 2, V, RI):-B_UP is -3 + B, B_RT is B + 1, update_power(BI, B_UP, V, RI), update_power(BI, B_RT, V, RI).
update_influence_(BI, B, 3, V, RI):-B_LF is -1 + B, update_power(BI, B_LF, V, RI).
update_influence_(BI, B, 4, V, RI):-B_UP is -3 + B, B_LF is -1 + B, update_power(BI, B_UP, V, RI), update_power(BI, B_LF, V, RI).
update_influence_(BI, B, 5, V, RI):-B_RT is B + 1, update_power(BI, B_RT, V, RI).
update_influence_(BI, B, 6, V, RI):-B_DN is B + 3, B_LF is B + 1, update_power(BI, B_DN, V, RI), update_power(BI, B_LF, V, RI).
update_influence_(BI, B, 7, V, RI):-B_DN is B + 3, update_power(BI, B_DN, V, RI).
update_influence_(BI, B, 8, V, RI):-B_DN is B + 3, B_RT is B + 1, update_power(BI, B_DN, V, RI), update_power(BI, B_RT, V, RI).

place_piece(X, Y, V, BL, BB, BI, RL, RB, RI):-
	place_piece_board(X, Y, V, BL, RL),
	coords_to_blocks(X, Y, B, N),
	place_piece_blocks(B, N, V, BB, RB),
	update_influence(BI, B, N, V, RI).

place_piece_board(X, Y, V, BL, RL):-replace_matrix(BL, X, Y, V, RL).
place_piece_blocks(B, N, V, BB, RB):-replace_matrix(BB, B, N, V, RB).
