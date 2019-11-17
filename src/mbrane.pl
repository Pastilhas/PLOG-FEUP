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
	incomplete_board(RL),
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
	incomplete_board(RL),
	% Next play
	NextPlay is Play + 1,
	game_loop_2players(P1,P2,NextPlay,[RL|R]).

% incomplete_board
% true if board incomplete
incomplete_board(RL) :- 
	true.

% player_turn
% get player input and make move
player_turn([BL,BB,BI], P, R) :- 
	repeat,
	get_move(X, Y, V),
	TV is P * V,
	check_move(X, Y, TV, BL, BB),!,
	make_move([X, Y], TV, [BL,BB,BI], R).
