:- begin_tests(ttt_minimax).
:- consult('ttt_minimax.pl').

test(win_x) :-
    win([x,x,x, e,o,e, o,e,e], x).

test(terminal_win) :-
    terminal([o,o,o, x,x,e, e,e,x]).

test(utility_x_win) :-
    utility([x,x,x, o,o,e, e,e,e], 1).

test(utility_o_win) :-
    utility([o,o,o, x,x,e, e,e,e], -1).

test(utility_draw) :-
    utility([x,o,x, x,o,o, o,x,x], 0).

test(minimax_immediate_win, [true(V=1)]) :-
    clear_count,
    minimax_value([x,x,e, o,o,e, e,e,e], x, V).

test(best_move_wins, [true(BestValue=1)]) :-
    best_move([x,x,e, o,o,e, e,e,e], x, _BestBoard, BestValue).

% From empty board, perfect play -> draw (0)
test(minimax_empty_draw, [true(V=0)]) :-
    clear_count,
    minimax_value([e,e,e, e,e,e, e,e,e], x, V).

:- end_tests(ttt_minimax).
