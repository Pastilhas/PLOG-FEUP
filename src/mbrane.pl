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
    (OP == '0' -> game, mbrane;
     OP == '1' -> instructions_menu, mbrane;
     OP == '2' -> about_menu, mbrane).


display_game(Board,Player):-
    /* temporary board(Board) */
    board(Board),
    game_ui(Player),
    display_board(Board).