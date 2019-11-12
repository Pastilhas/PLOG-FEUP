display_board(B):- display_board(B,9).
display_board(_,0):- write('+---+---+---+---+---+---+---+---+---+'),nl.
display_board([L|T],I):-
	I > 0,!,
	write('+---+---+---+---+---+---+---+---+---+'),nl,
	draw_line(L),nl,
	NI is I - 1,
	display_board(T,NI).

draw_line(L):- draw_line(L,9).
draw_line(_,0):- write('|').
draw_line([H|T],J):-
	J > 0,!,
	write('| '),
	write(H),
	write(' '),
	NJ is J - 1,
	draw_line(T,NJ).

display_game(B,P):-
    game_ui(P),
    display_board(B).