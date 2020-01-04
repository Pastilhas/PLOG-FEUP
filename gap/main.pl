/**	PLOG 2019/2020
 *	Joao Campos e Leonardo Moura
 *	Gap puzzle
 *	Two shaded squares in every row and column
 *	Shaded squares do not touch, even at corners.
 *	Numbers on the side indicate number of squares between shaded squares in that row or column.
 *
 *	Main file
 */

:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-include('display.pl').

%	gap(+Side, -Out)
%	generate solutions for the gap puzzle
%	solutions come in the form of coordinates for black cells
gap(S, Points) :-
	number(S),								% check S is number

	% get list of coordinates
	Max is S - 1,
	length(Left, S),
	length(Right, S),
	length(Up, S),
	length(Down, S),

	domain(Left, 0, Max),
	domain(Right, 0, Max),
	domain(Up, 0, Max),
	domain(Down, 0, Max),

	all_distinct(Left),
	all_distinct(Right),
	all_distinct(Up),
	all_distinct(Down),

	restrict(Left, Right, Up, Down, Points),
	nl,nl,write(Points),nl,nl,

	% find solution
	labeling([], Points),
	display_gap(Points,S).

%	restrict(+Points)
%	restrict all points
restrict([], [], [], [], []) :- write('start').
restrict([L|RL], [R|RR], [U|RU], [D1,D2|RD], Points) :-
	nl,write(L),write(R),write(U),write(D),nl,
	restrict(RL, RR, RU, RD, NPoints),
	R #> L + 1,
	D #> U + 1,
	domain([X,Z], 0, 9),
	X #> U + 1,
	Z #> U + 1,
	append([L,U, R,U, L,X, R,Z],NPoints,Points).
restrict(_, _, _, _, []) :- write('start').

%	print(+Points)
%	print puzzle using coordinates
print_coords([]) :- true.
print_coords([X1,Y1,X2,_|R]) :-
	write('line '), write(Y1), write(': '), write(X1), write(' | '), write(X2),
	nl, print_coords(R).