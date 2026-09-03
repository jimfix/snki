CXX ?= gcc
CXXFLAGS ?= -std=c++17 -g

snki: snek-lex.o snek-parse.o snek-ast.o snek-util.o snki.o
	$(CXX) $(CXXFLAGS) -o snki snek-util.o snek-lex.o snek-ast.o snek-parse.o snki.o 

snek-ast.o: snek-ast.cc snek-ast.hh snek-util.hh
	$(CXX) $(CXXFLAGS) -c snek-ast.cc

snek-lex.o: snek-lex.cc snek-lex.hh snek-util.hh
	$(CXX) $(CXXFLAGS) -c snek-lex.cc

snek-util.o: snek-util.cc snek-util.hh
	$(CXX) $(CXXFLAGS) -c snek-util.cc

snek-parse.o: snek-parse.cc snek-parse.hh snek-ast.hh snek-util.hh snek-lex.hh
	$(CXX) $(CXXFLAGS) -c snek-parse.cc

snki.o: snki.cc snek-lex.hh snek-ast.hh snek-parse.hh snek-util.hh
	$(CXX) $(CXXFLAGS) -c snki.cc

clean:
	rm -f *.o snki


