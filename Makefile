lp: lp.l lp.y
	flex lp.l
	bison -d lp.y
	gcc lex.yy.c lp.tab.c -o lp