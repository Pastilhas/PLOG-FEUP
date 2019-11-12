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

board1([
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ']] ).

board2([
	[ 6 , 4 , 0 , 1 , 5 , 2 , 3 , 8 , 7 ],
	[ 5 ,' ', 8 , 3 , 0 , 7 , 6 , 1 , 4 ],
	[ 3 , 1 , 7 , 6 , 8 , 4 , 5 , 2 ,' '],
	[ 2 , 3 , 6 , 7 , 1 ,' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' '],
	[' ',' ',' ',' ', 7 , 6 ,' ',' ',' '],
	[' ', 8 ,' ',' ',' ',' ', 4 ,' ',' '],
	[' ',' ',' ',' ',' ',' ',' ',' ',' ']] ).

board3([
	[ 6 , 4 , 0 , 1 , 5 , 2 , 3 , 8 , 7 ],
	[ 5 ,' ', 8 , 3 , 0 , 7 , 6 , 1 , 4 ],
	[ 3 , 1 , 7 , 6 , 8 , 4 , 5 , 2 ,' '],
	[ 2 , 3 , 6 , 7 , 1 , 5 , 8 , 4 , 0 ],
	[ 4 , 5 ,' ',' ', 6 , 8 , 2 , 3 , 1 ],
	[ 1 , 7 ,' ', 2 , 3 ,' ',' ', 5 , 6 ],
	[' ',' ', 3 , 8 , 7 , 6 , 1 , 0 , 2 ],
	[ 0 , 8 ,' ', 5 , 2 , 1 , 4 , 6 , 3 ],
	[ 7 , 6 , 1 , 0 , 4 , 3 ,' ', 8 , 5 ]] ).