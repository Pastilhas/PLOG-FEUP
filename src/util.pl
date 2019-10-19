get_option(OP):-
    get_char(OP),
    get_char(_).

wait_enter:-get_char(_).