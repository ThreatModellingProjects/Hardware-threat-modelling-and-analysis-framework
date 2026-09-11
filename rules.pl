% Manufacturing lifecycle phases
lifecycle_phases([design, proof_of_concept, fabrication, integration, production, boxing, delivery]).


% Lets prolog know which phases are after each other
next_phase(P1, P2) :-
    lifecycle_phases(L), append(_, [P1, P2 | _], L).

:- dynamic create_m/3, becomes_m/3, causes_m/3, targets_m/3, protects_m/4.
:- multifile vulnerable_m/3, mitigated_m/3.
:- table vulnerable_m/3, mitigated_m/3, susceptible_m/4.

% Rule 1
mitigated_m(A, V, P2) :-
    mitigated_m(A, V, P1), next_phase(P1, P2).

% Rule 2
vulnerable_m(B, V2, P) :-
    vulnerable_m(A, V, P), \+ mitigated_m(A, V, P), becomes_m(A, B, P), causes_m(V, V2, B).

% Rule 3
vulnerable_m(B, V2, P) :-
    vulnerable_m(A, V, P), \+ mitigated_m(A, V, P), create_m(A, B, P), causes_m(V, V2, B).

% Rule 4
vulnerable_m(A, V2, P) :-
    vulnerable_m(A, V, P), \+ mitigated_m(A, V, P), causes_m(V, V2, A).

% Rule 5
vulnerable_m(A, V, P2) :-
    vulnerable_m(A, V, P1), next_phase(P1, P2), \+ mitigated_m(A, V, P2).

% Rule 6
susceptible_m(A, V, T, P) :-
    vulnerable_m(A, V, P), \+ mitigated_m(A, V, P), targets_m(T, V, P), \+ protects_m(_, A, T, P).

:- dynamic contain_d/2, depend_d/2, control_d/2, generate_d/2, receive_d/2, mitigated_d/2, causes_d/3, triggers_d/3, targets_d/2, effect_d/3,
           backup_d/3, protects_d/3, deployed_component/1.
:- multifile vulnerable_d/2.
:- table vulnerable_d/2, susceptible_d/3, exposed_d/2.

% Rule 7
vulnerable_d(X, V2) :-
    vulnerable_d(A, V), \+ mitigated_d(A, V), contain_d(X, A), causes_d(V, V2, X).

% Rule 8
vulnerable_d(A, V2) :-
    vulnerable_d(X, V), \+ mitigated_d(X, V), contain_d(X, A), causes_d(V, V2, A).

% Rule 9
vulnerable_d(A, V2) :-
    vulnerable_d(B, V), \+ mitigated_d(B, V), depend_d(A, B), causes_d(V, V2, A).

% Rule 10
vulnerable_d(B, V2) :-
    vulnerable_d(A, V), \+ mitigated_d(A, V), control_d(A, B), causes_d(V, V2, B).

% Rule 11
vulnerable_d(Y, V2) :-
    vulnerable_d(X, V), \+ mitigated_d(X, V), generate_d(X, S), receive_d(Y, S), causes_d(V, V2, Y).

% Rule 12
vulnerable_d(S, V2) :-
    vulnerable_d(X, V), \+ mitigated_d(X, V), generate_d(X, S), causes_d(V, V2, S).

% Rule 13
vulnerable_d(Y, V2) :-
    vulnerable_d(S, V), \+ mitigated_d(S, V), receive_d(Y, S), causes_d(V, V2, Y).

% Rule 14
vulnerable_d(A, V2) :-
    vulnerable_d(A, V), \+ mitigated_d(A, V), causes_d(V, V2, A).

% Rule 15
susceptible_d(A, V, T) :-
    vulnerable_d(A, V), \+ mitigated_d(A, V), targets_d(T, V), \+ protects_d(_, A, T).

% Rule 16
exposed_d(A, E) :-
    vulnerable_d(A, V), \+ mitigated_d(A, V), targets_d(T, V), \+ protects_d(_, A, T), effect_d(T, V, E).

% Rule 17
exposed_d(X, E2) :-
    exposed_d(A, E), \+ backup_d(X, A, E), contain_d(X, A), triggers_d(E, E2, X).

% Rule 18
exposed_d(A, E2) :-
    exposed_d(X, E), \+ backup_d(A, X, E), contain_d(X, A), triggers_d(E, E2, A).

% Rule 19
exposed_d(A, E2) :-
    exposed_d(B, E), \+ backup_d(A, B, E), depend_d(A, B), triggers_d(E, E2, A).

% Rule 20
exposed_d(B, E2) :-
    exposed_d(A, E), \+ backup_d(B, A, E), control_d(A, B), triggers_d(E, E2, B).

% Rule 21
exposed_d(Y, E2) :-
    exposed_d(X, E), \+ backup_d(Y, X, E), generate_d(X, S), receive_d(Y, S), triggers_d(E, E2, Y).

% Rule 22
exposed_d(S, E2) :-
    exposed_d(X, E), \+ backup_d(S, X, E), generate_d(X, S), triggers_d(E, E2, S).

% Rule 23
exposed_d(Y, E2) :-
    exposed_d(S, E), \+ backup_d(Y, S, E), receive_d(Y, S), triggers_d(E, E2, Y).

% Rule 24
exposed_d(A, E2) :-
    exposed_d(A, E), \+ backup_d(A, A, E), triggers_d(E, E2, A).

% Rule 25
vulnerable_d(A, V) :-
    vulnerable_m(A, V, delivery), \+ mitigated_m(A, V, delivery), deployed_component(A).

% Prints all derived predicates
run :-
    nl, write('=== Part 1: derived V_m at delivery ==='), nl,
    forall(vulnerable_m(A, V, delivery), format("  V_m(~w, ~w, delivery)~n", [A, V])),
    nl, write('=== Part 1: derived S_m ==='), nl,
    forall(susceptible_m(A, V, T, P), format("  S_m(~w, ~w, ~w, ~w)~n", [A, V, T, P])),
    nl, write('=== Part 2 and 3: derived V_d ==='), nl,
    forall(vulnerable_d(A, V), format("  V_d(~w, ~w)~n", [A, V])),
    nl, write('=== Part 2: derived S_d ==='), nl,
    forall(susceptible_d(A, V, T), format("  S_d(~w, ~w, ~w)~n", [A, V, T])),
    nl, write('=== Part 2: derived Ex_d ==='), nl,
    forall(exposed_d(A, E), format("  Ex_d(~w, ~w)~n", [A, E])),
    nl.
