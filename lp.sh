#!/bin/bash
flex lp.l # lexico
bison -d lp.y # sintático
gcc lex.yy.c lp.tab.c -o lp