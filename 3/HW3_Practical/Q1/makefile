all:	
	bison -d gram.y
	flex lex.l
	gcc gram.tab.c lex.yy.c -lm -o parser

clean:
	rm -r *.o *.c  *.tab.*