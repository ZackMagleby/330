teacher(ms_appleton).
teacher(ms_gross).
teacher(mr_knight).
teacher(mr_mcevoy).
teacher(ms_parnell).

subject(english).
subject(gym).
subject(history).
subject(math).
subject(science).

state(california).
state(florida).
state(maine).
state(oregon).
state(virginia).

activity(antiquing).
activity(camping).
activity(sightseeing).
activity(spelunking).
activity(water-skiing).

solve :-
    subject(appletonSubject), subject(grossSubject), subject(knightSubject), subject(mcevoySubject), subject(parnellSubject),
    all_different([appletonSubject, grossSubject, knightSubject, mcevoySubject, parnellSubject]),
    state(appletonState), state(grossState), state(knightState), state(mcevoyState), state(parnellState),
    all_different([appletonState, grossState, knightState, mcevoyState, parnellState]),
    activity(appletonActivity), activity(grossActivity), activity(knightActivity), activity(mcevoyActivity), activity(parnellActivity),
    all_different([appletonActivity, grossActivity, knigthActivity, mcevoyActivity, parnellActivity]),
    Quads = [[ms_appleton, appletonSubject, appletonState, appletonActivity],
             [ms_gross, grossSubject, grossState, grossActivity],
             [mr_knight, knightSubject, knightState, knightActivity],
             [mr_mcevoy, mcevoySubject, mcevoyState, mcevoyActivity],
             [ms_parnell, parnellSubject, parnellState, parnellActivity]],

    %Ms. Gross teaches either math or science.  If Ms. Gross is going antiquing, then she is going to Florida; otherwise, she is going to California.
    (member([ms_gross, math, _, _], Quads) ; member([ms_gross, science, _, _], Quads)),
    (member([ms_gross, _, _, antiquing], Quads) -> member([ms_gross, _, florida, _], Quads); member([ms_gross, _, california, _], Quads)),

    %The science teacher (who is going water-skiing) is going to travel to either California or Florida.  Mr. McEvoy (who is the history teacher) is going to either Maine or Oregon.
     member([_, science, _, water-skiing], Quads),
     (member([_, science, california, _], Quads) ; member([_, science, florida, _], Quads)),
     member([mr_mcevoy, history, _, _], Quads),
     (member([mr_mcevoy, _, maine, _], Quads) ; member([mr_mcevoy, _, oregon, _], Quads)),

    %If the woman who is going to Virginia is the English teacher, then she is Ms. Appleton; otherwise, she is Ms. Parnell (who is going spelunking).
    member([ms_parnell, _, _, spelunking], Quads),
    \+ member([ms_gross, english, _, _], Quads),
    (member([_, english, virginia, _], Quads) -> member([ms_appleton, english, _, _], Quads); member([ms_parnell, english, _, _], Quads)),


    %The person who is going to Maine (who isn't the gym teacher) isn't the one who is going sightseeing. (DONE)
     \+ member([_, gym, maine, _], Quads),
     \+ member([_, _, maine, sightseeing], Quads),

    %Ms. Gross isn't the woman who is going camping. One woman is going antiquing on her vacation.
    \+ member([ms_gross, _, _, camping], Quads),
    \+ member([mr_knight, _, _, camping], Quads),
    \+ member([mr_mcevoy, _, _, camping], Quads),
    (   member([ms_appleton, _, _, camping], Quads) ; member([ms_parnell, _, _, camping], Quads)),
    \+ member([mr_knight, _, _, antiquing], Quads),
    \+ member([mr_mcevoy, _, _, antiquing], Quads),

    tell(ms_appleton, appletonSubject, appletonState, appletonActivity),
  tell(ms_gross, grossSubject, grossState, grossActivity),
  tell(mr_knight, knightSubject, knightState, knightActivity),
  tell(mr_mcevoy, mcevoySubject, mcevoyState, mcevoyActivity),
  tell(ms_parnell, parnellSubject, parnellState, parnellActiity).



all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(W, X, Y, Z) :-
   write(W), write(' teaches'), write(X), write(' and is going to '), write(Y),
    write(' to go '), write(Z), write('.'), nl.















