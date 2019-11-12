:-use_module(library(lists)).

:-include('util.pl').
:-include('calc.pl').
:-include('menu.pl').
:-include('board.pl').
:-include('display.pl').

mbrane:-
	main_menu(OP),
    (OP = '0',game,mbrane;
    OP = '1',instructions_menu,mbrane;
    OP = '2',about_menu,mbrane).

game :-
	get_player(Player),
	destroy_board(BL,BB,BI),
	write(Player),
	display_game(BL,Player).
