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
	N is 4 * S,
	Max is S - 1,
	length(Points, N),

	%restrict the coordinates
	domain(Points, 0, Max),
	restrict(Points),

	% find solution
	labeling([], Points).

%	restrict(+Points)
%	restrict all points
restrict(Points) :-
	write('Start restrict'),nl,
	restrict(Points, 0, [], [], []).

%	restrict(+Points, N, PrevX, OccX, OccY)
%	restrict all points. 
% N is number of line, 
% PrevX is list of invalid X (cells will touch), 
% OccX is list of occupied X, OccY is list of occupied Y
restrict([X1,Y1,X2,Y2,X3,Y3,X4,Y4 | R], N, PrevX, OccX, OccY) :-
	% if N was already used -> jump to next
	count_duplicate(OccY,N,I)												,
	I = 0																						,
	% restrict X
	all_distinct([X1,X3|PrevX])											,
	X3 #> X1 + 1																		,
	% restrict P1 and P2
	X1 #= X2																				, 
	Y1 #= N 																				, 
	Y2 #> Y1 + 1																		,
	% restrict P3 and P4
	X3 #= X4																				, 
	Y3 #= N 																				, 
	Y4 #> Y3 + 1																		,
	% prepare next iteration
	append([Y1,Y2,Y3,Y4],OccY,NewOccY)							,
	append([X1,X3],OccX,NewOccX)										,
	BX1 #= X1 - 1																		, 
	AX1 #= X1 + 1																		, 
	BX3 #= X3 - 1																		, 
	AX3 #= X3 + 1																		, 
	NN is N + 1																			,
	% restrict rest of Points, PrevX are all that would touch in next line
	% OccX is X1 and X3 appended to the previous
	% OccY is twice N, Y2 and Y4 appended to the previous
	restrict(R, NN, [BX1,X1,AX1,BX3,X3,AX3], NewOccX, NewOccY).

restrict([X1,Y1 | R], N, PrevX, OccX, OccY) :-
	% if N was used twice -> jump to next
	count_duplicate(OccY,N,I),
	I = 1,
	% restrict X
	all_distinct([X1|PrevX]),
	% restrict P1 and P2
	X1 #= X2, Y1 #= N, Y2 #> Y1 + 1,
	% prepare next iteration
	append([Y1,Y2],OccY,NewOccY),
	append([X1],OccX,NewOccX),
	BX1 #= X1 - 1, AX1 #= X1 + 1,
	NN is N + 1,
	% restrict rest of Points, PrevX are all that would touch in next line
	% OccX is X1 and X3 appended to the previous
	% OccY is twice N, Y2 and Y4 appended to the previous
	restrict(R, NN, [BX1,X1,AX1,BX3,X3,AX3], NewOccX, NewOccY).

count_duplicate([], _, 0).
count_duplicate([E|T], E, NI) :- count_duplicate(T,E,I), NI is I + 1.
count_duplicate([H|T], E, I) :- count_duplicate(T,E,I).

%	print(+Points)
%	print puzzle using coordinates
print_coords([]) :- true.
print_coords([X1,Y1,X2,_|R]) :-
	write('line '), write(Y1), write(': '), write(X1), write(' | '), write(X2),
	nl, print_coords(R).