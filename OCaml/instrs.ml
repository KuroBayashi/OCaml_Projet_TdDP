(* Instructions of the CAM *)

open Miniml;;

type instr =
  PrimInstr of primop
| Cons
| Push
| Swap
| Return
| Quote of value
| Cur of code
| App
| Branch of code * code
(* new for recursive calls *)
| Call of var
| AddDefs of (var * code) list
| RmDefs of int
and value =
  NullV 
| VarV of Miniml.var
| IntV of int
| BoolV of bool
| PairV of value * value
| ClosureV of code * value
and code = instr list
  
type stackelem = Val of value | Cod of code

(* Pour la partie recursion *)
type envelem = EVar of var | EDef of var list

let execArith m n op = match op with  
  BAadd -> m + n
| BAsub -> m - n
| BAmul -> m * n
| BAdiv -> m / n
| BAmod -> m mod n
;; 

let execComp m n op = match op with  
  BCeq -> m = n
| BCge -> m >= n
| BCgt -> m > n
| BCle -> m <= n
| BClt -> m < n
| BCne -> m != n
;;

(* "List.length fds = 0" pour eviter l'erreur possible si 'n' plus grand que le nombre d'element dans 'fds' *)
let rec chop n fds = 
  if n <= 0 || (List.length fds) = 0 then fds 
  else chop (n-1) (List.tl fds)
;;

(* Ajout de 'fds' pour la partie recursion *)
let rec exec = function
  (PairV(x, y), PrimInstr(UnOp(Fst))::c, st, fds) -> exec (x, c, st, fds)
| (PairV(x, y), PrimInstr(UnOp(Snd))::c, st, fds) -> exec (y, c, st, fds)

| (PairV(IntV(m), IntV(n)), PrimInstr(BinOp(BArith(op)))::c, st, fds)  -> exec (IntV(execArith m n op), c, st, fds)
| (PairV(IntV(m), IntV(n)), PrimInstr(BinOp(BCompar(op)))::c, st, fds) -> exec (BoolV(execComp m n op), c, st, fds)

| (t, Quote(v)::c, st, fds)       -> exec (v, c, st, fds)
| (x, Cons::c, Val(y)::st, fds)   -> exec (PairV(y, x), c, st, fds)
| (x, Push::c, st, fds)           -> exec (x, c, Val(x)::st, fds)
| (x, Swap::c, Val(y)::st, fds)   -> exec (y, c, Val(x)::st, fds)
| (x, Cur(d)::c, st, fds)         -> exec (ClosureV(d, x), c, st, fds)
| (x, Return::c, Cod(d)::st, fds) -> exec (x, d, st, fds)

| (PairV(ClosureV(cd, y), z), App::c, st, fds) -> exec (PairV(y, z), cd, Cod(c)::st, fds)

| (BoolV(true),  Branch(t, e)::c, Val(x)::st, fds) -> exec (x, t, Cod(c)::st, fds)
| (BoolV(false), Branch(t, e)::c, Val(x)::st, fds) -> exec (x, e, Cod(c)::st, fds)

| (t, (Call(f))::c, st, fds)       -> (t, (List.assoc f fds) @ c, st, fds)
| (t, (AddDefs(defs))::c, st, fds) -> (t, c, st, defs @ fds)
| (t, (RmDefs(n))::c, st, fds)     -> (t, c, st, chop n fds)

| cfg -> cfg
;;

(*
  Si c'est une EVar, on renvoie une liste de Fst/Snd avec 1 Fst pour chaque match fail et un Snd terminal.
  Exemple : [Fst; Fst; Snd] le match est reussi a la troisieme EVar teste

  Si c'est une EDef, on test toutes les valeurs contenu et si on match, on renvoie seulement [Call v]
  Si on arrive a la fin, env vide, alors v n'est pas defini, donc erreur

*)
let rec access v env = match env with
  [] -> failwith (v ^ " is not defined.")
| (EVar ev)::r ->
    if v = ev then [PrimInstr(UnOp(Snd))] 
    else (
      let x = (access v r) in match x with
        (Call _)::_ -> x
       | _ -> PrimInstr(UnOp(Fst))::x
    )
| (EDef ed)::r -> let rec rec_edef f def = match def with
    [] -> access v r
  | a::b -> if a = f then [Call v]
            else rec_edef f b
  in rec_edef v ed
;;


let rec compile = function 
  (env, Bool(b)) -> [Quote(BoolV(b))]
| (env, Int(i))  -> [Quote(IntV(i))]
| (env, Var(v))  -> access v env
| (env, Pair(a, b))        ->  [Push] @ compile (env, a) @ [Swap] @ compile (env, b) @ [Cons]
| (env, App(PrimOp(p), e)) -> compile (env, e) @ [PrimInstr(p)]
| (env, Fn(v, e))          -> [Cur((compile (EVar(v)::env, e)) @ [Return])]
| (env, App(f, a))         -> [Push] @ compile (env, f) @ [Swap] @ compile (env, a) @ [Cons; App]
| (env, Cond(i, t, e))     -> [Push] @ compile (env, i) @ [Branch(compile (env, t) @ [Return], compile (env, e) @ [Return])]

(* A corrigé *)
(*)
| (env, Fix(defs, e)) -> let rec get_functions_defs = function (* Recuperation des definitions de fonctions *)
                             [] -> []
                            | (EVar _)::r -> get_functions_defs r
                            | (EDef d)::r -> d @ (get_functions_defs r)
                          in 
                            let new_env = (get_functions_defs defs) @ env in  (* Construction du nouvel env*)
                              let rec comp_defs = function  (* Compilation des differentes fonctions *)
                                [] -> []
                                |a::r -> compile(new_env, a) @ (comp_defs r)
                              in 
                                let dc = (comp_defs defs) in
                                  let ec = (compile(new_env, e)) in 
                                    [AddDefs dc] @ ec @ [RmDefs (List.length dc)] 
*)
| _ -> failwith "Compile error" (* Pour enlever les warning avec make *)
;;

let compile_prog = function
	Prog(_, exp) -> compile([], exp)
;;