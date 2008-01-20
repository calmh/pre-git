options {
	language="Cpp";
	genHashLines=true;
}

class LangParser extends Parser;

options {
//        k = 2;
        exportVocab=Lang;
	buildAST = true;
}

lines
  :
  | line lines
  ;

line
  : decl SEMI!
  ;

decl
  : TYPE IDENT^ ASSIGN^ ICON
  ;

class LangLexer extends Lexer;

options {
//	k = 2;
        exportVocab=Lang;
	testLiterals = true;
}


WS      :       (' '
        |       '\t'
        |       '\n'
        |       '\r')
	{ $setType(ANTLR_USE_NAMESPACE(antlr)Token::SKIP); }
	;

TYPE
options {
	paraphrase = "type declaration";
}
  : "int"
  | "bool"
  ;

IDENT
options {
	paraphrase = "identifier";
}
  :  ('a'..'z' | 'A'..'Z' | '_' ) ( ('a'..'z' | 'A'..'Z' | '_') | ('0'..'9' ))*
  ;

ICON
options {
	paraphrase = "integer constant";
}
  : '0'..'9' ('0'..'9')*
  ;

SEMI
options {
	paraphrase = ";";
}
  : ';'
  ;

ASSIGN
options {
	paraphrase = "=";
}
  : '='
  ;
