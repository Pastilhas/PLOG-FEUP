/* List of lines */
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

/* List of blocks */
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

/* List of influence in each block */
board_influence([0,0,0,0,0,0,0,0,0]).

/* Retract board to destroy it
	destroy_board/3
	destroy_board(-BL, -BB, -BI) */
destroy_board(BL,BB,BI):-
	board_lin(BL), retract(BL),
	board_blk(BB), retract(BB),
	board_inf(BI), retract(BI).

/* Assert board to save it
	save_board/3
	save_board(+BL, +BC, +BB) */
save_board(BL,BC,BB):-
	assertz(BL),
	assertz(BC),
	assertz(BB).

/* Display board on the screen
	display_board/0
	display_board */
display_board:-display_board(0).

/* Display board on the screen
	Start printing with display_board(0)
	With display_board(9) it will print the final line

	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+
	|   |   |   |   |   |   |   |   |   |
	+---+---+---+---+---+---+---+---+---+

	display_board/1
	display_board(+I) */
display_board(9):-write('+---+---+---+---+---+---+---+---+---+'), nl.
display_board(I):-
	write('+---+---+---+---+---+---+---+---+---+'), nl,
	draw_line(I), nl,
	NI is I + 1,
	display_board(NI).

/* Display line I on the screen
	draw_line/1
	draw_line(+I) */
draw_line(I):-draw_line(I,0).

/* Display element J of line I on the screen
	With display_line(I,9) it will print the final separator
	draw_line/2
	draw_line(+I,+J) */
draw_line(I,9):-write('|').
draw_line(I,J):-
	write('| '),
	board(Board), nth0(I, Board, Line), nth0(J, Line, Elem),
	write(Elem),
	write(' '),
	NJ is J+1,
	draw_line(I, NJ).

/* Place a piece on the board
	make_move/3
	make_move(+X,+Y,+V) */
make_move(X,Y,V):-
	check_move(X,Y,V).


check_move(X,Y,V):-
	X >= 0, X <= 8,
	Y >= 0, Y <= 8,
	V >= 0, V <= 8,
	board(Board), nth0(Y, Board, Line),nth0(X, Line, Elem),
	Elem == ' '.

place_piece(X,Y,V):-
	board(Board), nth0(Y, Board, Line),nth0(X, Line, Elem),
	Elem is V,
	coords_to_block(X,Y,B,N),
	board_blocks(Board_blk), nth0(B, Board_blk, Block), nth0(N, Block, Elem_blk),
	Elem_blk is V,
	update_power(B,V),
	update_influence(B.N,V).

update_power(B,V):-
	B >= 0, B<= 8,
	board_influence(Board),
	nth0(B, Board, V).

update_influence(B,N,V):-
	(	(V == 0) -> false;
		(N == 4) -> false;
		(B == N) -> false;
		(B == 0, (N == 1; N == 3)) -> false;
		(B == 2, (N == 1; N == 5)) -> false;
		(B == 6, (N == 3; N == 7)) -> false;
		(B == 8, (N == 5; N == 7)) -> false;
		true),
	INF is div(V,2),
	(	(N == 0) -> (B_UP is B-3, B_LF is B-1, update_power(B_UP,INF), update_power(B_LF,INF));
		(N == 2) -> (B_UP is B-3, B_RT is B+1, update_power(B_UP,INF), update_power(B_RT,INF));
		(N == 6) -> (B_DN is B+3, B_LF is B+1, update_power(B_DN,INF), update_power(B_LF,INF));
		(N == 8) -> (B_DN is B+3, B_RT is B+1, update_power(B_DN,INF), update_power(B_RT,INF));

		(N == 1) -> (B_UP is B-3, update_power(B_UP,INF));
		(N == 3) -> (B_LF is B-1, update_power(B_LF,INF));
		(N == 5) -> (B_RT is B+1, update_power(B_RT,INF));
		(N == 7) -> (B_DN is B+3, update_power(B_DN,INF));
		true).

