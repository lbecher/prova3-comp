lp: lp.l lp.y
	rm -rf bin
	mkdir bin
	flex lp.l
	bison -d lp.y
	gcc lex.yy.c lp.tab.c -o bin/lp