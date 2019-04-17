CXX=g++
CXXFLAGS=-Wall

all: lexer.cpp lexer

lexer.cpp: lexer.l
	flex -s -o lexer.cpp lexer.l

lexer: lexer.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	$(RM) lexer.cpp lexer
