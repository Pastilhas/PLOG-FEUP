 :- use_module(library(lists)).

 :- include('util.pl').
 :- include('menu.pl').
 :- include('board.pl').
 :- include('display.pl').
 :- include('bot.pl').

mbrane :- main_menu(OP), repeat, mbrane(OP).
mbrane('0') :- game, fail.
mbrane('1') :- instructions_menu, fail.
mbrane('2') :- about_menu, fail.
mbrane(_) :- true.

game :- player_select(OP), repeat, game(OP).
game('0') :- game_2players, fail.
game('1') :- game_player_bot, fail.
game('2') :- game_2bots, fail.
game(_) :- true.

display_game(B, P1, P2) :- game_ui(P1, P2), display_board(B).

% game_2players
game_2players :- 
	get_player(P1),
	get_player(P2),
	start_board(B),
	game_loop_2players(P1,P2,0,B),
	wait_enter.

% game_player_bot
game_player_bot :- 
	board(BB),
	get_player(Player),
	display_game(BB, Player, "Bot"),
	wait_enter.

% game_2bots
game_2bots :- 
	board(BB),
	display_game(BB, "Bot1", "Bot2"),
	wait_enter.

% game_loop_2players
game_loop_2players(P1, P2, Play, [BL,BB,BI]) :- 
	even(Play),
	% Player 1 plays
	display_game(BL, P1, P2),
	display_power(BI),
	write('Play '), write(Play),nl, !,
	player_turn([BL,BB,BI], 1, [RL|R]),!,
	% Check complete board
	game_over([BL,BB,BI],W),
	% Next play
	NextPlay is Play + 1,
	game_loop_2players(P1,P2,NextPlay,[RL|R]).

game_loop_2players(P1, P2, Play, [BL,BB,BI]) :-
	% Player 2 plays
	display_game(BL, P1, P2),
	display_power(BI),
	write('Play '), write(Play),nl, !,
	player_turn([BL,BB,BI], -1, [RL|R]),!,
	% Check complete board
	game_over([BL,BB,BI],W),
	% Next play
	NextPlay is Play + 1,
	game_loop_2players(P1,P2,NextPlay,[RL|R]).

% game_over
game_over([B|BI],W) :- 
	valid_moves(B, R),
	R = [],
	get_winner(BI,W).

% get_winner
get_winner(B,W) :-
	get_winner_(B,P1,P2),
	(P1 > P2, W is 1); W is -1.

get_winner_([],P1,P2) :- P1 is 0, P2 is 0.
get_winner_([H|T],P1,P2):-
	get_winner_(T,N1,N2),
	((H > 0, P1 is N1 + 1, P2 is N2);
		(H < 0, P1 is N1, P2 is N2 + 1)).
	
	

% player_turn
% get player input and make move
player_turn([BL,BB,BI], P, R) :- 
	repeat,
	get_move(X, Y, V),
	TV is P * V,
	check_move(X, Y, TV, BL, BB),!,
	move([X, Y, TV], [BL,BB,BI], R).
