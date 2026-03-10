move(Board, Player, NextBoard) :-
    append(Prefix,[Empty|Suffix],Board),
    Empty = e,
    append(Prefix, [Player|Suffix], NextBoard).

combo(0,1,2).
combo(3,4,5).
combo(6,7,8).
combo(0,3,6).
combo(1,4,7).
combo(2,5,8).
combo(0,4,8).
combo(2,4,6).

win(Board, Player) :-
    combo(A,B,C),
    nth0(A, Board, Player),
    nth0(B, Board, Player),
    nth0(C, Board, Player).
    

terminal(Board) :- win(Board,x).
terminal(Board) :- win(Board,o).
terminal(Board) :- \+(move(Board, _, _)).

utility(Board, U) :- 
    win(Board,x),
    U = 1.
utility(Board, U) :- 
    win(Board,o),
    U = -1.
utility(Board, U) :- 
    \+(move(Board, _, _)),
    U = 0.
