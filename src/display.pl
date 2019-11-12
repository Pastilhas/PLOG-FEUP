display_board(Board) :- display_board(Board,0).
display_board(Board,9) :- write('+---+---+---+---+---+---+---+---+---+'),nl.
display_board(Board,I) :-
	write('+---+---+---+---+---+---+---+---+---+'),nl,
	nth0(I,Board,Line),
	draw_line(Line),nl,
	NI is I + 1,
	display_board(Board,NI).

draw_line(L) :- draw_line(L,0).
draw_line(L,9) :- write('|').
draw_line(L,J) :-
	write('| '),
	nth0(J,L,E),
	write(E),
	write(' '),
	NJ is J+1,
	draw_line(L,NJ).

display_game(B,P) :-
    game_ui(P),
    display_board(B).