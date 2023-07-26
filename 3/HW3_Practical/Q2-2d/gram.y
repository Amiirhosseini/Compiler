/* Amirreza Hosseini */
/* 9820363 */
/* syntax parser */
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno;
extern char* yytext;
int yylex(void);
void yyerror(const char* s);
extern int yylineno;
extern FILE* yyin;
typedef struct {
    int value;
    char *name;
} token;

int mode = 1;

%}

%token INT BOOL IF ELSE WHILE TRUE FALSE OR AND ASSIGN EQ NEQ LTE GTE LT GT PLUS MINUS TIMES DIVIDE NOT LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA INTEGER_LITERAL IDENTIFIER

%union {
    int value;
    char *name;
}

%type <value> INTEGER_LITERAL
%type <name> IDENTIFIER

%left OR AND
%left EQ NEQ LTE GTE LT GT
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start program

%%

program: statements
{
    printf("<program>\n");
    printf("  <statement_list>\n");
}
;

statements: /* empty */
| statements statement
{
    printf("  <statement_list>\n");
}
;

statement: declaration
{
    printf("    <statement>\n");
}
| assignment
{
    printf("    <statement>\n");
}
| conditional
{
    printf("    <statement>\n");
}
| loop
{
    printf("    <statement>\n");
}
;

type: INT
{
    printf("      <type>\n");
    if (mode == 1) printf("        INT\n");
    else printf("        int\n");
}
| BOOL
{
    printf("      <type>\n");
    if (mode == 1) printf("        BOOL\n");
    else printf("        bool\n");
}
;

declaration: type identifiers SEMICOLON
{
    printf("      <declaration>\n");
}
;

identifiers: IDENTIFIER
{
    printf("        <identifier_list>\n");
    printf("          <identifier>\n");
}
| identifiers COMMA IDENTIFIER
{
    printf("        <identifier_list>\n");
    printf("          <identifier>\n");
}
;

assignment: IDENTIFIER ASSIGN expression SEMICOLON
{
    printf("      <assignment>\n");
    printf("        <identifier>\n");
    printf("          IDENTIFIER\n");
    printf("        ASSIGN\n");
    printf("        <expression>\n");
}
| type IDENTIFIER ASSIGN expression SEMICOLON
{
    printf("      <assignment>\n");
    printf("        <type>\n");
    printf("        <identifier>\n");
    printf("          IDENTIFIER\n");
    printf("        ASSIGN\n");
    printf("        <expression>\n");
}
;

conditional: IF LPAREN expression RPAREN LBRACE statements RBRACE
{
printf("<conditional> IF LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ");
}

| IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE
{
printf("<conditional> IF LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ELSE LBRACE <statement_list> RBRACE ");
}

;

loop: WHILE LPAREN expression RPAREN LBRACE statements RBRACE
{
printf("<loop> WHILE LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ");
}

;

expression: IDENTIFIER
{
printf("<expression> <identifier> ");
}

| literal
{
printf("<expression> ");
}

| expression binary_operator expression
{
printf("<expression> ");
}

| NOT expression
{
printf("<expression> NOT ");
}

| LPAREN expression RPAREN
{
printf("<expression> LPAREN <expression> RPAREN ");
}

| MINUS expression
{
printf("<expression> MINUS ");
}

;

literal: boolean_literal
| INTEGER_LITERAL
{
printf("<literal> ");
}

;

boolean_literal: TRUE
{
printf("<boolean_literal> ");
if (mode == 1) printf("TRUE ");
else printf("true ");
}

| FALSE
{
printf("<boolean_literal> ");
if (mode == 1) printf("FALSE ");
else printf("false ");
}

;

binary_operator: arithmetic_operator
| relational_operator
| logical_operator
{
printf("<binary_operator> ");
}

;

arithmetic_operator: PLUS 
{

if (mode == 1) printf("PLUS ");

else printf("+ ");

}

| MINUS 
{

if (mode == 1) printf("MINUS ");

else printf("- ");

}

| TIMES 
{

if (mode == 1) printf("TIMES ");

else printf("* ");

}

| DIVIDE 
{

if (mode == 1) printf("DIVIDE ");

else printf("/ ");

}

;

relational_operator: LT 
{

if (mode == 1) printf("LT ");

else printf("< ");

}

| GT 
{

if (mode == 1) printf("GT ");

else printf("> ");

}

| LTE 
{

if (mode == 1) printf("LTE ");

else printf("<= ");

}

| GTE 
{

if (mode == 1) printf("GTE ");

else printf(">= ");

}

| EQ 
{

if (mode == 1) printf("EQ ");

else printf("== ");

}

| NEQ 
{

if (mode == 1) printf("NEQ ");

else printf("!= ");

}

;

logical_operator: OR 
{

if (mode == 1) printf("OR ");

else printf("|| ");

}

| AND 
{

if (mode == 1) printf("AND ");

else printf("&& ");

}

;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

int main(int argc, char **argv)
{
    if (argc > 2) {
        mode = atoi(argv[2]);
    }

    FILE* input_file = stdin;

    if(argc>1)
    {
        input_file = fopen(argv[1], "r");
        if(!input_file)
        {
            printf("Cannot open file %s\n", argv[1]);
            exit(1);
        }
    }

    yyin = input_file;

    yyparse();

    return 0;
}
