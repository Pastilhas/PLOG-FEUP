:- dynamic(board/1).
:- dynamic(board_blocks/1).
:- dynamic(board_influence/1).

% starting board list of lines
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

% starting board list of blocks
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

% starting board list of influences
board_influence([0,0,0,0,0,0,0,0,0]).

% destroy_board
% BL,BB,BI - return boards
destroy_board(BL,BB,BI) :-
	board(BL),				retract(board(BL)),
	board_blocks(BB),		retract(board_blocks(BB)),
	board_influence(BI),	retract(board_influence(BI)).

% save_board
% BL,BB,BI - boards to assert
save_board(BL,BC,BB) :-
	assertz(board(BL)),
	assertz(board_blocks(BC)),
	assertz(board_influence(BB)).

% make_move
% X,Y 	- coordinates
% V		- value
make_move(X,Y,V) :-
	check_move(X,Y,V).

% check_move
% X,Y 	- coordinates
% V 	- value
check_move(X,Y,V) :-
	X >= 0,X =< 8,
	Y >= 0,Y =< 8,
	V >= 0,V =< 8,
	board(Board),nth0(Y,Board,Line),nth0(X,Line,Elem),
	Elem == ' '.

% update_power
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!! BAD
update_power(B,V) :-
	B >= 0,B=< 8,
	board_influence(Board),
	nth0(B,Board,V).

% update_influence
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!! BAD
update_influence(B,N,V) :-
	(	V = 0,!,false;
		N = 4,!,false;
		B = N,!,false;
		B = 0,(N = 1; N = 3),!,false;
		B = 2,(N = 1; N = 5),!,false;
		B = 6,(N = 3; N = 7),!,false;
		B = 8,(N = 5; N = 7),!,false
	),
	INF is div(V,2),
	(	N = 0,!,(B_UP is B-3,B_LF is B-1,update_power(B_UP,INF),update_power(B_LF,INF));
		N = 2,!,(B_UP is B-3,B_RT is B+1,update_power(B_UP,INF),update_power(B_RT,INF));
		N = 6,!,(B_DN is B+3,B_LF is B+1,update_power(B_DN,INF),update_power(B_LF,INF));
		N = 8,!,(B_DN is B+3,B_RT is B+1,update_power(B_DN,INF),update_power(B_RT,INF));

		N = 1,!,(B_UP is B-3,update_power(B_UP,INF));
		N = 3,!,(B_LF is B-1,update_power(B_LF,INF));
		N = 5,!,(B_RT is B+1,update_power(B_RT,INF));
		N = 7,!,(B_DN is B+3,update_power(B_DN,INF))
	).

place_piece(X,Y,V,BL,BB,BI,RL,RB,RI) :-
	place_piece_board(X,Y,V,BL,RL),
	coords_to_blocks(X,Y,B,N),
	place_piece_blocks(B,N,V,BB,RB),
	place_piece_influence(B,V,BI,RI).

place_piece_board(X,Y,V,BL,RL) :-  	replace_matrix(BL,X,Y,V,RL).
place_piece_blocks(B,N,V,BB,RB) :- 	replace_matrix(BB,B,N,V,RB).
place_piece_influence(B,V,BI,RI) :- replace(BI,B,V,RI).
