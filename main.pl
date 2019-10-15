board_lin([]). 							/* Board of lines     */
board_col([]). 							/* Board of columns   */
board_blk([]). 							/* Board of blocks    */
board_inf([]).                          /* Bord of influences */

/* 
	Retract board to destroy it
	destroy_board(-BL, -BC, -BB, -BI)
*/
destroy_board(BL,BC,BB,BI):-
	board_lin(BL), retract(BL),
	board_col(BC), retract(BC),
	board_blk(BB), retract(BB),
	board_inf(BI), retract(BI).
	
/*
	Assert board to save it
	save_board(+BL, +BC, +BB)
*/
save_board(BL,BC,BB):-
	assertz(BL),
	assertz(BC),
	assertz(BB).

/*	
	Display board on the screen 
	Start printing with display_board(0)
	With display_board(9) it will print the final line
	display_board(+I)
*/
display_board(9):-
	write('+--+--+--+--+--+--+--+--+--+'), nl.
display_board(I):-
	write('+--+--+--+--+--+--+--+--+--+'), nl,
	draw_line(I), nl,
	NI is I + 1,
	display_board(NI).

/*
    Clear screen for better board display
*/
clear():- write('\e[2J').

