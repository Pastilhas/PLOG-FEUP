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
    (OP = '1' -> game, mbrane;
     OP = '2' -> instructions_menu, mbrane;
     OP = '3' -> about_menu, mbrane;
     OP = '4';
    mbrane).