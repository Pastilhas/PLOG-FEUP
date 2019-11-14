:-use_module(library(lists)).

:-include('util.pl').
:-include('menu.pl').
:-include('board.pl').
:-include('display.pl').

mbrane:-main_menu(OP),repeat,mbrane(OP).
mbrane('0'):-game,fail.
mbrane('1'):-instructions_menu,fail.
mbrane('2'):-about_menu,fail.
mbrane(_):-!.

game:-player_select(OP),repeat,game(OP).
game('0'):-game_2players,fail.
game('1'):-game_player_bot,fail.
game('2'):-game_2bots,fail.
game(_):-!.

display_game(B,P1,P2):-game_ui(P1,P2),display_board(B).

game_2players:-
	get_player(P1),
	get_player(P2),
	repeat,
		% game main loop
		game_loop_2players(P1,P2),
	wait_enter.

game_player_bot:-
	board(BB),
	get_player(Player),
	display_game(BB,Player,"Bot"),
	wait_enter.

game_2bots:-
	board(BB),
	display_game(BB,"Bot1","Bot2"),
	wait_enter.

game_loop_2players(P1,P2):-
	% Player 1 plays
	destroy_board(BL1,BB1,BI1),
	display_game(BL1,P1,P2),
	repeat,
		player_turn(BL1,BB1,BI1,1),
	% Player 2 plays
	destroy_board(BL2,BB2,BI2),
	display_game(BL2,P1,P2),
	repeat,
		player_turn(BL2,BB2,BI2,-1),
	% Check complete board
	complete, !.

complete:-fail.

player_turn(BL,BB,BI,P):-get_move(X,Y,V),!,TV is P * V,make_move(X,Y,TV,BL,BB,BI,RL,RB,RI),save_board(RL,RB,RI),!.