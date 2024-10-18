SHELL=/bin/sh
LEX=flex
YACC=bison
CC=gcc
CFLAGS=-g -std=c11 -pedantic -Wall
LDFLAGS=
# --nounput: ne génère pas la fonction yyunput() inutile
# --DYY_NO_INPUT: ne prend pas en compte la fonction input() inutile
# -D_POSIX_SOURCE: déclare la fonction fileno()
LEXOPTS=-D_POSIX_SOURCE -DYY_NO_INPUT --nounput
YACCOPTS=

PROG=projet

all: $(PROG)

stack_algo.o: stack_algo.c stack_algo.h
	$(CC) $(CFLAGS) -c stack_algo.c

tsym.o: tsym.c tsym.h 
	$(CC) $(CFLAGS) -c tsym.c

$(PROG): lex.yy.o stack_algo.o $(PROG).tab.o tsym.o
	$(CC) $+ -o $@ $(LDFLAGS)

lex.yy.c: $(PROG).l stack_algo.h $(PROG).tab.h tsym.h
	$(LEX) $(LEXOPTS) $<

lex.yy.h: $(PROG).l
	$(LEX) $(LEXOPTS) --header-file=$@ $<

$(PROG).tab.c $(PROG).tab.h: $(PROG).y lex.yy.h
	$(YACC) $(YACCOPTS) $< -d -v --graph

%.o: %.c
	$(CC) $(CFLAGS) $< -c

clean:
	-rm $(PROG) *.o lex.yy.* $(PROG).tab.* *.err *.output *.out *.dot