:-use_module(library(lists)).

:-include('util.pl').
:-include('menu.pl').
:-include('board.pl').
:-include('display.pl').

mbrane:-
	main_menu(OP),
    (OP = '0',!,game,mbrane;
    OP = '1',!,instructions_menu,mbrane;
    OP = '2',!,about_menu,mbrane).

game:-
	player_select(OP),
	(OP = '0',!,game_2players,mbrane;
	OP = '1',!,game_player_bot,mbrane;
	OP = '2',!,game_2bots,mbrane).

display_game(Board,Player1,Player2):-
    game_ui(Player1,Player2),
    display_board(Board).

game_2players:-
	get_player(Player1),
	get_player(Player2),
	repeat,
		% game main loop
		game_loop_2players,
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

game_loop_2players:-
	% get and remove boards
	destroy_board(BL,BB,BI),
	% display board
	display_game(BL,Player1,Player2),
	% player 1 move,repeat until successful
	repeat,
		get_move(X,Y,V),
		make_move(X,Y,V,BL,BB,BI,RL,RB,RI),!,
	% display board
	display_game(BI,Player1,Player2),
	% player 2 move,repeat until successful
	repeat,
		get_move(X,Y,V),
		make_move(X,Y,V,BL,BB,BI,RL,RB,RI),!,
	% save board
	save_board(RL,RB,RI),
	% check complete board
	complete.

complete:- fail.
get_move(X,Y,V):-
	get_int('    X: ',X),
	get_int('    Y: ',Y),
	get_int('Value: ',V).

