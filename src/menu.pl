/* Display main menu on the screen
    main_menu/0
    main_menu */
main_menu:-
    clear,
    write('+------------------------------------------+'), nl,
    write('|                                          |'), nl,
    write('|                  Mbrane                  |'), nl,
    write('|                                          |'), nl,
    write('|    1) Start                              |'), nl,
    write('|    2) Instructions                       |'), nl,
    write('|    3) Quit                               |'), nl,
    write('|                                          |'), nl,
    write('     ?- '),
    get_option(OP),
    clear.


/* Clear screen for better board display
	clear/0
	clear */
clear:- write('\e[2J').
