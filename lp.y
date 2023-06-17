%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char*
int yyerror (char const *s);
extern int yylex (void);
extern FILE* yyin;
extern FILE* yyout;
extern int yylineno;

int var_count = 0;
int label_count = 0;

void gera_codigo(const char* result, const char* arg1, const char* op, const char* arg2) {
    printf("    %s = %s %s %s\n", result, arg1, op, arg2);
}

char* nova_variavel() {
    var_count++;
    char* var = (char*)malloc(sizeof(char) * 10);
    sprintf(var, "_t%d", var_count);
    return var;
}

char* nova_label() {
    label_count++;
    char* label = (char*)malloc(sizeof(char) * 10);
    sprintf(label, ".L%d", label_count);
    return label;
}
%}

%token SEMICOLON ASSIGN LESS_THAN EQUALS PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN
%token IF THEN ELSE END REPEAT UNTIL READ WRITE ID NUMBER

%%

program: cmd_seq;
cmd_seq: cmd | cmd_seq SEMICOLON cmd;
cmd: if_cmd | repeat_cmd | assign_cmd | read_cmd | write_cmd;

if_cmd:
    IF _exp_then cmd_seq END { 
        printf("%s:\n", $2);
    }
    | IF _exp_then cmd_seq _else cmd_seq END {
        printf("%s:\n", $4);
    }
    ;

_exp_then:
    exp THEN {
        char* label = nova_label();
        printf("    if %s goto %s\n", $1, label);
        $$ = label;
    }
    ;

_else:
    ELSE {
        char* label_anterior = (char*)malloc(sizeof(char) * 10);
        sprintf(label_anterior, ".L%d", label_count);
        char* label = nova_label();
        printf("    goto %s\n", label);
        printf("%s:\n", label_anterior);
        $$ = label;
    }
    ;

repeat_cmd:
    _repeat cmd_seq UNTIL exp {
        char* label = nova_label();
        printf("    if %s goto %s\n", $4, label);
        printf("    goto %s\n", $1);
        printf("%s:\n", label);
    }
    ;

_repeat:
    REPEAT {
        char* label = nova_label();
        printf("%s:\n", label);
        $$ = label;
    }
    ;

assign_cmd:
    ID ASSIGN exp {
        printf("    %s = %s\n", $1, $3);
    }
    ;

read_cmd:
    READ ID {
        printf("    read %s\n", $2);
    }
    ;

write_cmd:
    WRITE exp {
        printf("    write %s\n", $2);
    }
    ;

exp:
    simple_exp
    | simple_exp rel_op exp {
        char* var = nova_variavel();
        gera_codigo(var, $1, $2, $3);
        $$ = var;
    }
    ;

simple_exp:
    term
    | term add_op simple_exp {
        char* var = nova_variavel();
        gera_codigo(var, $1, $2, $3);
        $$ = var;
    }
    ;

term:
    factor
    | factor mul_op term {
        char* var = nova_variavel();
        gera_codigo(var, $1, $2, $3);
        $$ = var;
    }
    ;

rel_op:
    LESS_THAN {
        char* str = (char*)malloc(sizeof(char) * 10);
        sprintf(str, ">="); // invertido por causa dos saltos
        $$ = str;
    }
    | EQUALS {
        char* str = (char*)malloc(sizeof(char) * 10);
        sprintf(str, "!="); // invertido por causa dos saltos
        $$ = str;
    }
    ;

factor:
    LPAREN exp RPAREN {
        $$ = $2;
    }
    | NUMBER
    | ID
    ;

add_op: PLUS | MINUS;
mul_op: MULTIPLY | DIVIDE;

%%

int yyerror(char const *s) {
    fprintf(stderr, "%s\n", s);
    return 1;
}

int main(int argc, char** argv) {
    if (argc != 3) {
        printf("Uso: ./lp <arquivo_de_entrada> <arquivo_de_saida>\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2], "w");

    if (!yyin) {
        printf("Erro ao abrir o arquivo de entrada!\n");
        return 1;
    }
    if (!yyout) {
        printf("Erro ao criar o arquivo de saída!\n");
        return 1;
    }


    yyparse();


    fclose(yyin);
    fclose(yyout);

    return 0;
}