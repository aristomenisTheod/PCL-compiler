.PHONY: all clean

CXX=g++
CXXFLAGS=-Wall -std=c++11

all: pcl

lexer.cpp: lexer.l
	flex -s -o lexer.cpp lexer.l

lexer.o: lexer.cpp parser.hpp lexer.hpp
	$(CXX) -c -o $@ $<

parser.hpp parser.cpp: parser.y
	bison -dv -o parser.cpp parser.y

parser.o: parser.cpp lexer.hpp
	$(CXX) -c -o $@ $<

pcl: lexer.o parser.o
	$(CXX) $(CXXFLAGS) -o $@ $^

clean:
	$(RM) lexer.cpp parser.cpp parser.hpp parser.output *.o pcl
