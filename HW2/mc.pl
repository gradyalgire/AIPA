% ============================================================
% Missionaries & Cannibals
%
% State format: [ML, CL, Side]
%   ML = missionaries on LEFT bank (0..3)
%   CL = cannibals on LEFT bank (0..3)
%   Side = left | right  (boat position)
%
% Implemented:
%   - safe/1
%   - move/3
%   - solve_dfs/1 (DFS with cycle checking)
%
% TODO:
%   - solve_bfs/1 (BFS shortest path)
%
% Run:
%   ?- run(dfs).
%   ?- run(bfs).   % after BFS implemented
% ============================================================

start([3,3,left]).
goal([0,0,right]).

% ------------------------------------------------------------
% SAFETY RULES
% ------------------------------------------------------------
safe([ML,CL,_]) :-
    between(0,3,ML),
    between(0,3,CL),
    MR is 3 - ML,
    CR is 3 - CL,
    bank_safe(ML,CL),
    bank_safe(MR,CR).

bank_safe(M,C) :-
    M =:= 0 ;
    M >= C.

% ------------------------------------------------------------
% PASSENGER COMBINATIONS (1 or 2 total)
% ------------------------------------------------------------
passengers(2,0).
passengers(0,2).
passengers(1,0).
passengers(0,1).
passengers(1,1).

% ------------------------------------------------------------
% MOVE GENERATION
% move(State1, State2, Action)
% Action = boat(M,C)
% ------------------------------------------------------------
move([ML,CL,left], [ML2,CL2,right], boat(M,C)) :-
    passengers(M,C),
    ML >= M,
    CL >= C,
    ML2 is ML - M,
    CL2 is CL - C,
    safe([ML2,CL2,right]).

move([ML,CL,right], [ML2,CL2,left], boat(M,C)) :-
    passengers(M,C),
    MR is 3 - ML,
    CR is 3 - CL,
    MR >= M,
    CR >= C,
    ML2 is ML + M,
    CL2 is CL + C,
    safe([ML2,CL2,left]).

% ============================================================
% DFS WITH CYCLE CHECKING
% ============================================================
solve_dfs(Path) :-
    start(S),
    dfs(S, [S], RevPath),
    reverse(RevPath, Path).

dfs(S, Visited, Visited) :-
    goal(S).

dfs(S, Visited, Path) :-
    move(S, S2, _),
    \+ member(S2, Visited),
    dfs(S2, [S2|Visited], Path).

% ============================================================
% BFS (TODO)
% ============================================================
% TODO: Implement solve_bfs(Path) to return the shortest path
%       from start to goal, with cycle checking.
solve_bfs(_Path) :-
    write('TODO: BFS not implemented yet.'), nl,
    fail.

% ============================================================
% RUNNER
% ============================================================
run(dfs) :-
    solve_dfs(P),
    print_solution(P).

run(bfs) :-
    solve_bfs(P),
    print_solution(P).

% ------------------------------------------------------------
% OUTPUT HELPERS
% ------------------------------------------------------------
print_solution(Path) :-
    nl,
    write('Solution path:'), nl,
    print_states_and_actions(Path),
    length(Path, L),
    Crossings is L - 1,
    nl,
    write('Number of crossings: '),
    write(Crossings), nl.

print_states_and_actions([S]) :-
    write(S), nl.
print_states_and_actions([S1,S2|Rest]) :-
    write(S1), nl,
    ( move(S1, S2, A) ->
        write('  '), write(A), nl
    ;   write('  **no move found between these states**'), nl
    ),
    print_states_and_actions([S2|Rest]).

% ============================================================
% PATH VALIDITY CHECKER
% ============================================================
valid_path([_]).
valid_path([S1,S2|Rest]) :-
    move(S1,S2,_),
    valid_path([S2|Rest]).