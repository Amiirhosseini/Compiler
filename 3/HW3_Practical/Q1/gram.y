/* Amirreza Hosseini */
/* 9820363 */
/* Simple calculator */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "func.h"
#include "gram.tab.h"

extern double variable_values[100];
char variable_names[100][100];
extern int variable_set[100];

extern int yylex(void);
extern void yyterminate();
void yyerror(const char *message);
extern int yylineno;     //i declare yylineno from the lexical analyzer
extern FILE* yyin;
extern int previous_token;
int error_flag = 0;
double set_variable(int index, double value);
%}

%union {
    int index;
    double num;
}

%token<num> NUMBER
%token<num> L_BRACKET R_BRACKET
%token<num> DIV MUL ADD SUB EQUALS
%token<num> POW MOD
%token<num> LOG EXP
%token<num> COS SIN TAN COT
%token<index> VARIABLE
%token<num> NEW_LINE
%token<num> PRINT
%token<num> NEG

%type<num> program_input
%type<num> line
%type<num> calculation
%type<num> expr
%type<num> function
%type<num> log_function
%type<num> trig_function
%type<num> assignment
%type<num> print


//order like C language
%left ADD SUB
%left MUL DIV
%left LOG EXP COS SIN TAN COT
%right POW MOD
%left NEG
%left L_BRACKET R_BRACKET 

%%

program_input:
    program_input line { }
    | {}
;

line: 
    NEW_LINE {}
    | { error_flag = 0; } calculation NEW_LINE  { }
    | { error_flag = 0; } print NEW_LINE { }
;

print:
    PRINT calculation {  if (!error_flag) printf("%lf\n", $2); }
;
calculation:
    expr
    | assignment
;

expr:
    NEG expr                    { $$ = -$2; }
    | NUMBER                    { $$ = $1; }
    | VARIABLE                  { if (variable_values[$1] == -99999) {char str[140];sprintf(str, "Variable '%s' has not been assigned before", variable_names[$1]);
                                yyerror(str);
                                } else {
                                    $$ = variable_values[$1];
                                }}
    | function
    | expr DIV expr             { if ($3 == 0) { yyerror("Division by zero"); } else $$ = $1 / $3; }
    | expr MUL expr             { $$ = $1 * $3; }
    | L_BRACKET expr R_BRACKET  { $$ = $2; }
    | expr ADD expr             { $$ = $1 + $3; }
    | expr SUB expr             { $$ = $1 - $3; }
    | expr POW expr             { $$ = pow($1, $3); }
    | expr MOD expr             { $$ = fmod($1, $3); }
;

function: 
    log_function
    | trig_function
;

trig_function:
    COS expr            { $$ = cos($2); }
    | SIN expr          { $$ = sin($2); }
    | TAN expr          { $$ = tan($2); }
    | COT expr          { $$ = 1 / tan($2); }
;

log_function:
    LOG expr             { $$ = log($2); }
    | EXP expr          { $$ = exp($2); }
;

assignment: 
    VARIABLE EQUALS calculation { $$ = set_variable($1, $3); }
;

%%

int main(int argc, char **argv)
{
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
    int i;
    for (i = 0; i < 100; i++) {
        variable_values[i] = -99999;
    }
    
    yyin = input_file;
    yyparse();
    fclose(input_file);
    return 0;
}

void yyerror(const char *message)
{
    printf("ERROR at line %d: %s\n", yylineno, message);
    error_flag = 1;
}
