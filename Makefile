snki: snek-lex.o snek-parse.o snek-ast.o snek-util.o snki.o
	g++ -g -o snki snek-util.o snek-lex.o snek-ast.o snek-parse.o snki.o 

snek-ast.o: snek-ast.cc snek-ast.hh snek-util.hh
	g++ -std=c++17 -g -c snek-ast.cc

snek-lex.o: snek-lex.cc snek-lex.hh snek-util.hh
	g++ -std=c++17 -g -c snek-lex.cc

snek-util.o: snek-util.cc snek-util.hh
	g++ -std=c++17 -g -c snek-util.cc

snek-parse.o: snek-parse.cc snek-parse.hh snek-ast.hh snek-util.hh snek-lex.hh
	g++ -std=c++17 -g -c snek-parse.cc

snki.o: snki.cc snek-lex.hh snek-ast.hh snek-parse.hh snek-util.hh
	g++ -std=c++17 -g -c snki.cc

clean:
	touch snki foo~ foo.o
	rm *~ *.o snki


