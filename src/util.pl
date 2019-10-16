/* Get first char and return
    get_option/1
    get_option(-OP) */
get_option(OP):-
    get_char(OP),
    get_char(_).

/* Wait for enter input
    get_option/0
    get_option */
wait_enter:-get_char(_).