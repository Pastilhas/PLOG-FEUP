:-use_module(library(lists)).

:-include('util.pl').
:-include('calc.pl').
:-include('menu.pl').
:-include('board.pl').

/* Start game
    mbrane/0
    mbrane */
mbrane:-
	main_menu(OP),
    (OP = '0', !, game, mbrane;
    OP = '1', !, instructions_menu, mbrane;
    OP = '2', !, about_menu, mbrane).


display_game(Board,Player1,Player2):-
    /* temporary board(Board) */
    board(Board),
    game_ui(Player1,Player2),
    display_board(Board).

game :-
	player_select(OP),
	(OP = '0', !, game_2players, mbrane;
	OP = '1', !, game_player_bot, mbrane;
	OP = '2', !, game_2bots, mbrane).

game_2players :-
	get_player(Player1),
	get_player(Player2),
	board(BB),
	display_game(BB,Player1,Player2),
	wait_enter.
	%to complete

game_player_bot :-
	board(BB),
	get_player(Player),
	display_game(BB,Player,"Bot"),
	wait_enter.

game_2bots :-
	board(BB),
	display_game(BB,"Bot1","Bot2"),
	wait_enter.
