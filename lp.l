%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
#include "lp.tab.h"
extern int yylineno;
extern FILE* yyin;
%}

ignore [ \t]
number [+-]?[0-9]+
id [a-zA-Z][a-zA-Z0-9]*

%%

{ignore} {}

"\n" {
    yylineno++;
}

";" return SEMICOLON;
":=" return ASSIGN;
"(" return LPAREN;
")" return RPAREN;
"<" return LESS_THAN;
"=" return EQUALS;

"+" {
    yylval = "+";
    return PLUS;
};
"-" {
    yylval = "-";
    return MINUS;
};
"*" {
    yylval = "*";
    return MULTIPLY;
};
"/" {
    yylval = "/";
    return DIVIDE;
};

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