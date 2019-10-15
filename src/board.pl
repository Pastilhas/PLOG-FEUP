:-use_module(library(lists))

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
