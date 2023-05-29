%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
#include "lp.tab.h"
extern FILE* yyin;
%}

number [+-]?[0-9]+
id [a-zA-Z][a-zA-Z0-9]*

%%

[ \t\n]; // ignorar caracteres desnecessários

";" return SEMICOLON;
":=" return ASSIGN;
"<" return LESS_THAN;
"=" return EQUALS;
"+" return PLUS;
"-" return MINUS;
"*" return MULTIPLY;
"/" return DIVIDE;
"(" return LPAREN;
")" return RPAREN;

"if" return IF;
"then" return THEN;
"else" return ELSE;
"end" return END;
"repeat" return REPEAT;
"until" return UNTIL;
"read" return READ;
"write" return WRITE;

{number} {
    yylval = strdup(yytext);
    return NUMBER;
}
{id} {
    yylval = strdup(yytext);
    return ID;
}

. {
    printf("Token inválido: %s\n", yytext);
}
%%

int yywrap() {
    return 1;
}