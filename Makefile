CPFLAGS = -Wall

all: lex.yy.cc lexerc

lex.yy.cc: lexer.l
	flex lexer.l

lexerc: lex.yy.cc
	g++ $(CPFLAGS) -o lexerc lex.yy.cc
