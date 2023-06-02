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

cmd_seq: cmd;
cmd_seq: cmd SEMICOLON cmd_seq;

cmd: if_cmd;
cmd: repeat_cmd;
cmd: assign_cmd;
cmd: read_cmd;
cmd: write_cmd;

if_cmd: IF exp THEN cmd_seq END;
if_cmd: IF exp THEN cmd_seq ELSE cmd_seq END;

repeat_cmd: REPEAT cmd_seq UNTIL exp;
assign_cmd: ID ASSIGN exp;
read_cmd: READ ID;
write_cmd: WRITE exp;

exp: simple_exp;
exp: simple_exp rel_op simple_exp;

rel_op: LESS_THAN;
rel_op: EQUALS;

simple_exp: term;
simple_exp: term add_op simple_exp;

add_op: PLUS;
add_op: MINUS;

term: factor;
term: factor mul_op term;

mul_op: MULTIPLY;
mul_op: DIVIDE;

factor: LPAREN exp RPAREN;
factor: NUMBER {$$=$1; printf("Número: %s\n", $$);};
factor: ID {$$=$1; printf("Id: %s\n", $$);};
%%

int yyerror(char const *s) {
    //printf("%s\n", s);
}

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Uso: ./lp <arquivo_entrada>\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("Erro ao abrir o arquivo!\n");
        return 1;
    }


    int ret = yyparse();
    
    if (ret) {
        fprintf(stderr, "%d erro!\n", ret);
    }


    fclose(yyin);

    return 0;
}