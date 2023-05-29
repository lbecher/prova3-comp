%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE char*
int yyerror (char const *s);
extern int yylex (void);
extern FILE* yyin;
%}

%token SEMICOLON ASSIGN LESS_THAN EQUALS PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN
%token IF THEN ELSE END REPEAT UNTIL READ WRITE ID NUMBER

%%
program: cmd_seq;
cmd_seq: cmd | cmd_seq SEMICOLON cmd;
cmd: if_cmd | repeat_cmd | assign_cmd | read_cmd | write_cmd;
if_cmd: IF exp THEN cmd_seq END | IF exp THEN cmd_seq ELSE cmd_seq END;
repeat_cmd: REPEAT cmd_seq UNTIL exp;
assign_cmd: ID ASSIGN exp;
read_cmd: READ ID;
write_cmd: WRITE exp;
exp: simple_exp | simple_exp rel_op simple_exp;
rel_op: LESS_THAN | EQUALS;
simple_exp: term | simple_exp add_op term;
add_op: PLUS | MINUS;
term: factor | term mul_op factor;
mul_op: MULTIPLY | DIVIDE;
factor: LPAREN exp RPAREN | NUMBER {$$=$1; printf("%s\n", $$);} | ID;
%%

int yyerror(char const *s) {
    printf("%s\n", s);
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Uso: ./sla <arquivo_entrada>\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Erro ao abrir o arquivo de entrada!\n");
        return 1;
    }


    int ret = yyparse();
    if (ret){
        fprintf(stderr, "%d erro!\n", ret);
    }


    fclose(yyin);
    return 0;
}