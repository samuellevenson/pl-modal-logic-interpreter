%{
open Ast
open Printf
open Lexing

let merge (fn,pos1,_) (_,_,pos2) = (fn,pos1,pos2)
%}

%token <Ast.info * string> VAR
%token <Ast.info>
  LPAREN RPAREN TRUE FALSE
  NOT AND OR
  LBRACE RBRACE
  IMPLIES IFF 
  ASSIGN SEMI PRINT
  INTRO
%token EOF

%type <Ast.bexp> b
%type <Ast.com> c
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

/* Commands */
c : ac SEMI c             { Seq($1, $3) }
  | ac                    { $1 }

ac: VAR ASSIGN b          { Assign(snd $1, $3) }
  | INTRO VAR             { Intro (snd $2) }
  | LBRACE c RBRACE       { $2 }
  | PRINT b               { Print $2 }

/* Programs */
p : c EOF                 { $1 }