MAIN := modal
OBJS := ast.cmo lexer.cmo parser.cmo pprint.cmo eval.cmo main.cmo set.cmo kripke.cmo

%.cmo: %.ml
	ocamlc -c $<

%.cmi: %.mli
	ocamlc -c $<

$(MAIN): $(OBJS)
	ocamlc -o $@ $^

lexer.ml: lexer.mll
	ocamllex -q $<

parser.ml: parser.mly
	ocamlyacc -q $<

parser.mli: parser.mly
	ocamlyacc -q $<

clean:
	rm -f *.cmo *.cmi lexer.ml parser.ml parser.mli $(MAIN)

# Dependencies generated by `ocamldep -bytecode *.mli *.ml`.
ast.cmo :
eval.cmo : ast.cmo kripke.cmo
kripke.cmo : set.cmo
lexer.cmo : parser.cmi
main.cmo : parser.cmi lexer.cmo eval.cmo
parser.cmo : ast.cmo parser.cmi
parser.cmi : ast.cmo
pprint.cmo : ast.cmo
