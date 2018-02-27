rose(cottage_beauty).
rose(golden_sunset).
rose(mountain_bloom).
rose(pink_paradise).
rose(sweet_dreams).

event(anniversary_party).
event(charity_auction).
event(retirement_banquet).
event(senior_prom).
event(wedding).

item(balloons).
item(candles).
item(chocolates).
item(place_cards).
item(streamers).

customer(hugh).
customer(ida).
customer(jeremy).
customer(leroy).
customer(stella).

solve :-
    rose(HughRose), rose(IdaRose), rose(JeremyRose), rose(LeroyRose), rose(StellaRose),
    all_different([HughRose, IdaRose, JeremyRose, LeroyRose, StellaRose]),
    event(HughEvent), event(IdaEvent), event(JeremyEvent), event(LeroyEvent), event(StellaEvent),
     all_different([HughEvent, IdaEvent, JeremyEvent, LeroyEvent, StellaEvent]),
     item(HughItem), item(IdaItem), item(JeremyItem), item(LeroyItem), item(StellaItem),
     all_different([HughItem, IdaItem, JeremyItem, LeroyItem, StellaItem]),
     Quads = [[hugh, HughRose, HughEvent, HughItem],
              [ida, IdaRose, IdaEvent, IdaItem],
              [jeremy, JeremyRose, JeremyEvent, JeremyItem],
              [leroy, LeroyRose, LeroyEvent, LeroyItem],
              [stella, StellaRose, StellaEvent, StellaItem]],
% Jeremy made a purchase for the senior prom. Stella(who didn't choose
% flowers for a wedding) picked the Cottage Beauty Variety.
    member([jeremy, _, senior_prom, _], Quads),
    \+ member([stella, _, wedding, _], Quads),
    member([stella, cottage_beauty, _, _], Quads),
% Hugh (who selected the Pink Paradise blooms) didn't choose flowers for
% either the charity auction or the wedding
   member([hugh, pink_paradise, _, _], Quads),
   \+ member([hugh, _, charity_auction, _], Quads),
   \+ member([hugh, _, wedding, _], Quads),
% The customer who picked roses for an anniversary party also bought
% streamers.  The one shopping for a wedding chose the balloons.
   member([_, _, anniversary_party, streamers], Quads),
   member([_, _, wedding, balloons], Quads),

   member([_, sweet_dreams, _, chocolates], Quads),
   \+ member([jeremy, mountain_bloom, _, _], Quads),

   member([leroy, _, retirement_banquet, _], Quads),
   member([_, _, senior_prom, candles], Quads),

  tell(hugh, HughRose, HughEvent, HughItem),
  tell(ida, IdaRose, IdaEvent, IdaItem),
  tell(jeremy, JeremyRose, JeremyEvent, JeremyItem),
  tell(leroy, LeroyRose, LeroyEvent, LeroyItem),
  tell(stella, StellaRose, StellaEvent, StellaItem).


all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(W, X, Y, Z) :-
   write(W), write(' got the '), write(X), write(' roses for the '), write(Y),
    write(' and also bought '), write(Z), write('.'), nl.
