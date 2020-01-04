/**	PLOG 2019/2020
 *	Joao Campos e Leonardo Moura
 *	Gap puzzle
 *	Two shaded squares in every row and column
 *	Shaded squares do not touch, even at corners.
 *	Numbers on the side indicate number of squares between shaded squares in that row or column.
 *
 *	Main file
 */

:-use_module(library(clpfd)).
:-include('display.pl').

%	gap(+Side, -Out)
%	generate solutions for the gap puzzle
%	solutions come in the form of coordinates for black cells
gap(S, Points) :-
	number(S),								% check S is number

	% get list of coordinates
	N is 4 * S,
	Max is S - 1,
	length(Points, N),

	%restrict the coordinates
	domain(Points, 0, Max),
	restrict(Points),

	% find solution
	labeling([], Points),
	print_coords(Points).

%	restrict(+Points)
%	restrict all points
restrict(Points) :-
	restrict_first_line(Points, Rest, Prev),
	restrict_all_lines(Rest, Prev).

%	restrict_first_line(+Points, -Rest, -Line)
%	restrict first line and return the Rest of the list and the first Line
restrict_first_line([X1,Y1,X2,Y2|R], R, [X1,Y1,X2,Y2]) :-
	Y1 #= Y2,
	X2 #> X1 + 1.

%	restrict_all_lines(+Points, +Prev)
%	restrict all lines in board based on Previous line
restrict_all_lines([], _) :- true.
restrict_all_lines([X3,Y3,X4,Y4|R], [X1,Y1,X2,_]) :-
	Y3 #= Y4,
	X4 #> X3 + 1,

	Y3 #= Y1 + 1,

	X3 #\= X1,
	X3 #\= X1 + 1,
	X3 #\= X1 - 1,

	X4 #\= X2,
	X4 #\= X2 + 1,
	X4 #\= X2 - 1,
	restrict_all_lines(R, [X3,Y3,X4,Y4]).

%	print(+Points)
%	print puzzle using coordinates
print_coords([]) :- true.
print_coords([X1,Y1,X2,Y2|R]) :-
	write('('), write(X1), write(' , '), write(Y1), write(')    ('), write(X2), write(' , '), write(Y2), write(')'),
	nl, print_coords(R).