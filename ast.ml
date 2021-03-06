(* Variables. *)
type var = string

type world = string

type info = (int * int) * (int * int)

(* Boolean expressions. *)
and bexp =
| True
| False
| Implies of bexp * bexp
| Iff of bexp * bexp
| Not of bexp
| And of bexp * bexp
| Or of bexp * bexp
| Var of var
| Unknown of var * bexp
| Square of bexp
| Diamond of bexp

(* Commands. *)
and com =
| Assign of var * bexp
| AssignMexp of var * kripke_bexp
| Seq of com * com
| Print of bexp
| Intro of var
| Intros of var
| CreateEmptyKripke of var
| AddWorldToKripke of (var * world)
| AddWorldsToKripke of (var * world)
| AddAccessToKripke of (var * (world * world))
| AddAccessesToKripke of (var * (world))
| AddValuationToKripke of (var * (var * world))
| AddValuationsToKripke of (var * (var * world))
| LatexIt of (var * var)

and kripke_bexp =
| GetTruthValueFromKripke of (var * (world * bexp))
