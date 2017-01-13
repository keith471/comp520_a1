CC = gcc

CFLAGS = -Wall -ansi -pedantic

# target: dependencies
# [tab] system command

all: y.tab.c lex.yy.c
	$(CC) lex.yy.c y.tab.c -o out -ll

y.tab.c y.tab.h: parser.y
	bison --yacc --defines parser.y

lex.yy.c: scanner.l y.tab.h
	flex scanner.l

flex: scanner.l
	flex scanner.l; $(CC) lex.yy.c -o scanner -ll

check:
	./check

clean:
	rm y.tab.* lex.yy.*; rm scanner; rm out
