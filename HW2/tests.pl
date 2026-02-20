% ------------------------------------------------------------
% REQUIRED TEST CASES
% ------------------------------------------------------------
?- safe([3,3,left]).
?- safe([1,2,left]).
?- move([3,3,left], S2, A).
?- solve_bfs(P).
?- solve_dfs(P).
?- solve_bfs(P), length(P,L).
?- solve_dfs(P), length(P,L).
?- solve_bfs(P), valid_path(P).
?- solve_dfs(P), valid_path(P).