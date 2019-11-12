:- dynamic(board/1).
:- dynamic(board_blocks/1).
:- dynamic(board_influence/1).

board([
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ']] ).

board_blocks([
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ']] ).

board_influence([0,0,0,0,0,0,0,0,0]).

destroy_board(BL,BB,BI):-
	board(BL),retract(board(BL)),
	board_blocks(BB),retract(board_blocks(BB)),
	board_influence(BI),retract(board_influence(BI)).

save_board(BL,BC,BB):-
	assertz(BL),
	assertz(BC),
	assertz(BB).

display_board(Board):-display_board(Board,0).
display_board(Board,9):-write('+---+---+---+---+---+---+---+---+---+'),nl.
display_board(Board,I):-
	write('+---+---+---+---+---+---+---+---+---+'),nl,
	nth0(I,Board,Line),
	draw_line(Line),nl,
	NI is I + 1,
	display_board(Board,NI).

draw_line(Line):-draw_line(Line,0).
draw_line(Line,9):-write('|').
draw_line(Line,J):-
	write('| '),
	nth0(J,Line,Elem),
	write(Elem),
	write(' '),
	NJ is J+1,
	draw_line(Line,NJ).

make_move(X,Y,V):-
	check_move(X,Y,V).

check_move(X,Y,V):-
	X >= 0,X =< 8,
	Y >= 0,Y =< 8,
	V >= 0,V =< 8,
	board(Board),nth0(Y,Board,Line),nth0(X,Line,Elem),
	Elem == '  '.

place_piece(X,Y,V):-
	board(Board),nth0(Y,Board,Line),nth0(X,Line,Elem),
	Elem is V,
	coords_to_block(X,Y,B,N),
	board_blocks(Board_blk),nth0(B,Board_blk,Block),nth0(N,Block,Elem_blk),
	Elem_blk is V,
	update_power(B,V),
	update_influence(B,N,V).

update_power(B,V):-
	B >= 0,B=< 8,
	board_influence(Board),
	nth0(B,Board,V).

update_influence(B,N,V):-
	(	V = 0, !, false;
		N = 4, !, false;
		B = N, !, false;
		B = 0, (N = 1; N = 3), !, false;
		B = 2, (N = 1; N = 5), !, false;
		B = 6, (N = 3; N = 7), !, false;
		B = 8, (N = 5; N = 7), !, false;
		true),
	INF is div(V,2),
	(	N = 0, !, (B_UP is B-3,B_LF is B-1,update_power(B_UP,INF),update_power(B_LF,INF));
		N = 2, !, (B_UP is B-3,B_RT is B+1,update_power(B_UP,INF),update_power(B_RT,INF));
		N = 6, !, (B_DN is B+3,B_LF is B+1,update_power(B_DN,INF),update_power(B_LF,INF));
		N = 8, !, (B_DN is B+3,B_RT is B+1,update_power(B_DN,INF),update_power(B_RT,INF));

		N = 1, !, (B_UP is B-3,update_power(B_UP,INF));
		N = 3, !, (B_LF is B-1,update_power(B_LF,INF));
		N = 5, !, (B_RT is B+1,update_power(B_RT,INF));
		N = 7, !, (B_DN is B+3,update_power(B_DN,INF));
		true).

get_player(Payer) :- 
	write('Player name'), nl,
	write('     ?- '),
	read(Player),
	clear.

game :- 
	get_player(Player),
	destroy_board(BL,BB,BI),
	write(Player),
	display_game(BL,Player).