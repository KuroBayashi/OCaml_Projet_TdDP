# BOISNIER Thomas
# Projet : Type de Données et Preuves 

## Travail effectué
2.1) Analyse lexicale et syntaxique (parse.mly) : 
- ajout de règles de grammaire pour des expressions avec opérateurs additifs (addition, soustrac-
tion), de comparaison et d'expressions booléennes et d'une règle pour des paires.

2.2) Execution de la CAM en Caml (instrs.ml) : 
 - ajout de la fonction "exec"

2.3) Execution de la CAM en Java (classes Java) :
 - BinOp
 - BoolV
 - Config : Implementation de "exec_step", "exec" et "step"
 - PairV

2.4) Générateur de code de Caml vers Java
 - ajout des fonctions "access", "compile" et "compile_prog"

2.5) Fonctions récursives (instrs.ml) :
 - ajout du type "envelem"
 - ajout des instructions "Call", "AddDefs", "RmDefs" a la fonction "exec"
 - essai de modification de "access" et "compile" (non terminé ; cf difficultés rencontrées)

 
## Difficultés rencontrées

### Fonction "access"
Pour la partie concernant la fonction "access", je ne suis pas sûr d'avoir compris le système des "Fst"/"Snd", dans l'exemple :  

    access "f" [EVar "g"; EDef["f"]] donne : [Call "f"] \

on obtient [Call "f"] car le premier élément trouvé est une EDef, donc pas de Fst, même si l'élément est en seconde position.

Et dans l'exemple : 

    access "f" [EVar "f"; EDef["f"]] donne : [Snd]

on obtient [Snd] car c'est une Evar qui est en premiere position, donc pas de Fst non plus.

Mais si on avait eu :

    access "f" [EDef["g"]; EVar "f"]

le résultat doit il être [Snd] ou [Fst; Snd] ? Car la variable est en seconde position, mais c'est la premiere variable définie. Pour ma part j'ai essayer de faire une fonction qui ne compte pas les EDef, mais je ne suis pas sûr.

### Fonction "compile"
Pour la fonction compile, je n'ai pas réussi a faire la partie Fix(defs, e).

    File "instrs.ml", line 123, characters 62-66:
    Error: This expression has type (Miniml.var * Miniml.mlexp) list
       but an expression was expected of type envelem list
       Type Miniml.var * Miniml.mlexp is not compatible with type envelem

J'ai du raté quelque chose dans le cours car je ne sais pas quoi modifié.

## Commande
parse "../Tests/test.ml";;

    - : Miniml.prog =
    Prog (None,
    Fix ([("x", Int 2)],
    Cond
    (Cond (Miniml.App (PrimOp (BinOp (BCompar BCgt)), Pair (Var "x", Int 1)),
        Miniml.App (PrimOp (BinOp (BCompar BClt)), Pair (Var "x", Int 10)),
        Bool false),
    Var "x",
    Miniml.App (PrimOp (BinOp (BArith BAsub)),
        Pair (Var "x",
        Miniml.App (PrimOp (BinOp (BArith BAmul)), Pair (Int 2, Var "x")))))))

parse "../Tests/ackermann_iter.ml";;

    - : Miniml.prog =
    Prog (None,
    Fix
    ([("succ",
        Fn ("n",
        Miniml.App (PrimOp (BinOp (BArith BAadd)), Pair (Var "n", Int 1))));
        ("iter",
        Fn ("f",
        Fn ("n",
        Cond
            (Miniml.App (PrimOp (BinOp (BCompar BCeq)), Pair (Var "n", Int 0)),
            Miniml.App (Var "f", Int 1),
            Miniml.App (Var "f",
            Miniml.App (Miniml.App (Var "iter", Var "f"),
            Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "n", Int 1))))))));
        ("ack",
        Fn ("m",
        Cond
        (Miniml.App (PrimOp (BinOp (BCompar BCeq)), Pair (Var "m", Int 0)),
        Var "succ",
        Miniml.App (Var "iter",
            Miniml.App (Var "ack",
            Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "m", Int 1)))))))],
    Miniml.App (Miniml.App (Var "ack", Int 3), Int 2)))

parse "../Tests/ackermann_trad.ml";;

    - : Miniml.prog =
    Prog (None,
    Fix
    ([("ack",
        Fn ("m",
        Fn ("n",
        Cond
            (Miniml.App (PrimOp (BinOp (BCompar BCeq)), Pair (Var "m", Int 0)),
            Miniml.App (PrimOp (BinOp (BArith BAadd)), Pair (Var "n", Int 1)),
            Cond
            (Miniml.App (PrimOp (BinOp (BCompar BCeq)), Pair (Var "n", Int 0)),
            Miniml.App
            (Miniml.App (Var "ack",
                Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "m", Int 1))),
            Int 1),
            Miniml.App
            (Miniml.App (Var "ack",
                Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "m", Int 1))),
            Miniml.App (Miniml.App (Var "ack", Var "m"),
            Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "n", Int 1)))))))))],
    Miniml.App (Miniml.App (Var "ack", Int 3), Int 2)))

parse "../Tests/even_odd.ml";;

    - : Miniml.prog =
    Prog (None,
    Fix
    ([("even",
        Fn ("n",
        Cond
        (Miniml.App (PrimOp (BinOp (BCompar BCeq)), Pair (Var "n", Int 0)),
        Bool true,
        Miniml.App (Var "odd",
            Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "n", Int 1))))));
        ("odd",
        Fn ("n",
        Cond
        (Miniml.App (PrimOp (BinOp (BCompar BCne)), Pair (Var "n", Int 0)),
        Miniml.App (Var "even",
            Miniml.App (PrimOp (BinOp (BArith BAsub)), Pair (Var "n", Int 1))),
        Bool false)))],
    Miniml.App (Var "even", Int 7)))


Pour tout ce qui est compilation j'ai toujours le même message d'erreur "personnalisé" du fait du non support de Fix(defs, e) dans la fonction compile.

compile_prog (parse "../Tests/test.ml");;

    Exception: Failure "Compile error".
