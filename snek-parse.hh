#ifndef _snek_parse_
#define _snek_parse_

#include <vector>
#include "snek-lex.hh"
#include "snek-ast.hh"

//
// snek-parse.hh
//
// A recursive descent parser for the Snek programming language. It is defined
// by several `parse*` procedures that process a TokenStream.
//
// See snek-parse.cc for details.
//

Expn_ptr parseLeaf(TokenStream& tks);
Expn_ptr parseMult(TokenStream& tks);
Expn_ptr parseAddn(TokenStream& tks);
Expn_ptr parseExpn(TokenStream& tks);
Stmt_ptr parseStmt(TokenStream& tks);
Blck_ptr parseBlck(TokenStream& tks);
Prgm_ptr parsePrgm(TokenStream& tks);
Prgm_ptr parse(TokenStream& tks);

#endif
