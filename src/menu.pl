/* Display main menu on the screen
    main_menu/1
    main_menu(-OP) */
main_menu(OP):-
    clear,
    write('+------------------------------------------+'), nl,
    write('|                                          |'), nl,
    write('|                  Mbrane                  |'), nl,
    write('|                                          |'), nl,
    write('|    1) Start                              |'), nl,
    write('|    2) Instructions                       |'), nl,
    write('|    3) About                              |'), nl,
    write('|    4) Quit                               |'), nl,
    write('|                                          |'), nl,
    write('     ?- '),
    get_option(OP),
    clear.

instructions_menu:-
    clear,
    write('+------------------------------------------+'), nl,
    write('|                                          |'), nl,
    write('|               Instructions               |'), nl,
    write('|                                          |'), nl,
    write('|   Place pieces from 0 - 8 on the board   |'), nl,
    write('|   Gain points to conquer blocks          |'), nl,
    write('|   Convert enemy pieces to gain more      |'), nl,
    write('|   points                                 |'), nl,
    write('|   Player with more blocks wins           |'), nl,
    write('|                                          |'), nl,
    wait_enter,
    clear.

about_menu:-
    clear,
    write('+------------------------------------------+'), nl,
    write('|                                          |'), nl,
    write('|                   About                  |'), nl,
    write('|                                          |'), nl,
    write('|          Game by                         |'), nl,
    write('|               Joao Campos                |'), nl,
    write('|               Leonardo Moura             |'), nl,
    write('|                                          |'), nl,
    write('|                                          |'), nl,
    write('|                                          |'), nl,
    write('|                16/10/2018                |'), nl,
    write('|                                          |'), nl,
    wait_enter,
    clear.


/* Clear screen for better board display
	clear/0
	clear */
clear:- write('\e[2J').
