/*	PLOG 2019/2020
 *	Leonardo Moura & Joao Campos
 *	File for generating moves using different strategies
 */

% TODO random_bot

% TODO normal_bot

% TODO  smart_bot

% TODO random_move

% valid_moves(+Board, -Result)
valid_moves([BL,BB], R) :-
    check_all(BL,L),
    test_all(L,[BL,BB],R).


% check_all(+Board, -List)
check_all(B,L) :- check_all_cells(8,8,B,L).

% check_all_cells(+X, +Y, +Board, -List)
check_all_cells(0, 0, B, [H]) :- check_cell(0, 0, B), H = [0,0].
check_all_cells(0, 0, _, _) :- true.
check_all_cells(0, Y, B, [H|T]) :- 
    check_cell(0, Y, B), H = [0,Y], 
    NY is Y - 1, check_all_cells(8, NY, B, T).
check_all_cells(0, Y, B, L) :-
    NY is Y - 1, check_all_cells(8, NY, B, L).
check_all_cells(X, Y, B, [H|T]) :-
    check_cell(X, Y, B), H = [X,Y], 
    NX is X - 1, check_all_cells(NX, Y, B, T).
check_all_cells(X, Y, B, L) :- 
    NX is X - 1, check_all_cells(NX, Y, B, L).

% test_all(+Input, +Board, -Result)
test_all(I, B, R) :- test_all_cells(8, I, B, R).

% test_all_cells(+Value, +Coords, +Board, -Result)
test_all_cells(0, [[X,Y]], [BL,BB], [H]) :-
    check_move(X, Y, 0, BL, BB), H = [X,Y,0].

test_all_cells(0, [_], _, _) :- true.
test_all_cells(0, [[X,Y]|T], [BL,BB], [H|R]) :-
    check_move(X, Y, 0, BL, BB),
    H = [X,Y,0],
    test_all_cells(8, T, [BL,BB], R).

test_all_cells(0, T, [BL,BB], R) :-
    test_all_cells(8, T, [BL,BB], R).

test_all_cells(V, [[X,Y]|T], [BL,BB], [H|R]) :-
    check_move(X, Y, V, BL, BB),
    H = [X,Y,V],
    NV is V - 1, 
    test_all_cells(NV, [[X,Y]|T], [BL,BB], R).

test_all_cells(V, I, [BL,BB], R) :-
    NV is V - 1,
    test_all_cells(NV, I, [BL,BB], R).

% TODO get_best_move

