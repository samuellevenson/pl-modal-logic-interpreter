%{
open Ast
open Printf
open Lexing

let merge (fn,pos1,_) (_,_,pos2) = (fn,pos1,pos2)
%}

%token <Ast.info * string> VAR FILE SET PAIRSET
%token <Ast.info>
  LPAREN RPAREN TRUE FALSE
  NOT AND OR
  SQUARE DIAMOND
  LBRACE RBRACE
  IMPLIES IFF 
  ASSIGN SEMI PRINT
  INTRO INTROS
  GETTRUTH CREATEKRIPKE ADDWORLD ADDACCESS ADDVALUE 
  ADDWORLDS ADDACCESSES ADDVALUES
  LATEXIT
%token EOF

%type <Ast.bexp> b
%type <Ast.com> c
%type <Ast.kripke_bexp> kb
%type <Ast.com> p

%start p

%%
/* Boolean Expressions */
b : b IMPLIES b           { Implies($1, $3) }
  | b IFF b               { Iff ($1, $3) }
  | db                    { $1 }

db: db OR cb              { Or($1, $3) }
  | cb                    { $1 }

cb: cb AND nb             { And($1, $3) }
  | nb                    { $1 }

nb: NOT b                 { Not($2) }
  | ab                    { $1 }

ab : TRUE                 { True }
   | FALSE                { False }
   | LPAREN b RPAREN      { $2 }
   | VAR                  { Var(snd $1) }
   | mb                   { $1 }

mb: SQUARE b              { Square($2) }
  | DIAMOND b             { Diamond($2) }

/* Commands */
c : ac SEMI c             { Seq($1, $3) }
  | ac                    { $1 }

ac: VAR ASSIGN b          { Assign(snd $1, $3) }
  | VAR ASSIGN kb         { AssignMexp(snd $1, $3) }
  | INTRO VAR             { Intro (snd $2) }
  | INTROS SET            { Intros (snd $2) }
  | LBRACE c RBRACE       { $2 }
  | PRINT b               { Print $2 }
  | kc                    { $1 }

/* kripke boolean expressions */
kb : VAR VAR GETTRUTH b { GetTruthValueFromKripke(snd $1, (snd $2, $4)) }

/* Kripke Commands */
kc : CREATEKRIPKE VAR     { CreateEmptyKripke(snd $2) }
  | VAR ADDWORLD VAR      { AddWorldToKripke(snd $1, snd $3) }
  | VAR ADDACCESS VAR VAR { AddAccessToKripke(snd $1, (snd $3, snd $4)) }
  | VAR ADDACCESSES PAIRSET { AddAccessesToKripke(snd $1, snd $3) }
  | VAR ADDVALUE VAR VAR  { AddValuationToKripke(snd $1, (snd $4, snd $3)) }
  | VAR ADDWORLDS SET     { AddWorldsToKripke(snd $1, snd $3) }
  | VAR ADDVALUES VAR SET { AddValuationsToKripke(snd $1, (snd $4, snd $3)) }
  | LATEXIT VAR FILE          { LatexIt(snd $2, snd $3) }

/* Programs */
p : c EOF                 { $1 }
