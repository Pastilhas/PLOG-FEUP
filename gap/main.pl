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

restrict_two(Sol,0) :- count(0,Sol,#=,2).

restrict_two(Sol,S) :-
	count(S,Sol,#=,2),
	Next is S-1,
	restrict_two(Sol,Next).

restrict_next_pair([],_,_).

restrict_next_pair([HX,HY|T],X,Y) :-
	#\((HX #= X + 1) #/\ (HY #= Y + 1)),
	#\((HX #= X + 1) #/\ (HY #= Y - 1)),
	#\((HX #= X - 1) #/\ (HY #= Y + 1)),
	#\((HX #= X - 1) #/\ (HY #= Y - 1)),
	#\((HX #= X + 1) #/\ (HY #= Y)),
	#\((HX #= X - 1) #/\ (HY #= Y)),
	#\((HX #= X) #/\ (HY #= Y - 1)),
	#\((HX #= X) #/\ (HY #= Y + 1)),
	#\((HX #= X) #/\ (HY #= Y)),
	restrict_next_pair(T,X,Y).

restrict_next_(_,[]).

restrict_next_(Prev,[X,Y|T]) :-
	append(Prev,T,L),
	restrict_next_pair(L,X,Y),
	append(Prev,[X,Y],Next),
	restrict_next_(Next,T).

restrict_next(List) :-
	restrict_next_([],List).

extractX_([],Res,Res).

extractX_([X,_|T],Acc,Res) :-
	extractX_(T,[X|Acc],Res).

extractX(List,Pairs) :-
	extractX_(List,[],Pairs).

extractY_([],Res,Res).

extractY_([_,Y|T],Acc,Res) :-
	extractY_(T,[Y|Acc],Res).

extractY(List,Pairs) :-
	extractY_(List,[],Pairs).

crescent_order([_,_]).

crescent_order([X1,Y1,X2,Y2|T]) :-
	X1 #>= X2, 
	#\((X1 #= X2) #<=> (Y1 #> Y2)),
	crescent_order([X2,Y2|T]).

crescent_order([H1,H2|T]) :-
	H1 #>= H2, 
	crescent_order([H2|T]).


gap(S,Points) :-
	Max is 4 * S,
	Dom is S -1,

	length(Points,Max),
	domain(Points,0,Dom),

	extractX(Points,XList),
	extractY(Points,YList),

	crescent_order(Points),

	restrict_two(XList,Dom),
	restrict_two(YList,Dom),

	restrict_next(Points),

	write(labeling), nl,

	labeling([],Points),
	display_gap(Points,S).
	

 
%	gap(+Side, -Out)
%	generate solutions for the gap puzzle
%	solutions come in the form of coordinates for black cells
% gap(S, Points) :-
% 	number(S),								% check S is number

% 	% get list of coordinates
% 	Max is S - 1,
% 	length(Left, S),
% 	length(Right, S),
% 	length(Up, S),
% 	length(Down, S),

% 	domain(Left, 0, Max),
% 	domain(Right, 0, Max),
% 	domain(Up, 0, Max),
% 	domain(Down, 0, Max),

% 	all_distinct(Left),
% 	all_distinct(Right),
% 	all_distinct(Up),
% 	all_distinct(Down),

% 	restrict(Left, Right, Up, Down, Points),
% 	nl,nl,write(Points),nl,nl,

% 	% find solution
% 	labeling([], Points),
% 	display_gap(Points,S).

% %	restrict(+Points)
% %	restrict all points
% restrict([], [], [], [], []) :- write('start').
% restrict([L|RL], [R|RR], [U|RU], [D1,D2|RD], Points) :-
% 	nl,write(L),write(R),write(U),write(D),nl,
% 	restrict(RL, RR, RU, RD, NPoints),
% 	R #> L + 1,
% 	D #> U + 1,
% 	domain([X,Z], 0, 9),
% 	X #> U + 1,
% 	Z #> U + 1,
% 	append([L,U, R,U, L,X, R,Z],NPoints,Points).
% restrict(_, _, _, _, []) :- write('start').

%	print(+Points)
%	print puzzle using coordinates
print_coords([]) :- true.
print_coords([X1,Y1,X2,_|R]) :-
	write('line '), write(Y1), write(': '), write(X1), write(' | '), write(X2),
	nl, print_coords(R).

print_points([]).
print_points([X|T]) :-
	write(X) ,nl, print_points(T).