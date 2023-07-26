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
    printf("<program> ");
};

statements: /* empty */
| statements statement
{
    printf("<statement_list> ");
};

statement: declaration
{
    printf("<statement> ");
}
| assignment
{
    printf("<statement> ");
}
| conditional
{
    printf("<statement> ");
}
| loop
{
    printf("<statement> ");
};

type: INT
{
    printf("<type> ");
    if (mode == 1) printf("INT ");
    else printf("int ");
}
| BOOL
{
    printf("<type> ");
    if (mode == 1) printf("BOOL ");
    else printf("bool ");
};

declaration: type identifiers SEMICOLON
{
    printf("<declaration> ");
};

identifiers: IDENTIFIER
{
    printf("<identifier_list> <identifier> ");
}
| identifiers COMMA IDENTIFIER
{
    printf("<identifier_list> <identifier> ");
};

assignment: IDENTIFIER ASSIGN expression SEMICOLON
{
    printf("<assignment> <identifier> <expression> ");
}
| type IDENTIFIER ASSIGN expression SEMICOLON
{
    printf("<assignment> <identifier> <expression> ");
};

conditional: IF LPAREN expression RPAREN LBRACE statements RBRACE
{
    printf("<conditional> IF LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ");
}
| IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE
{
    printf("<conditional> IF LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ELSE LBRACE <statement_list> RBRACE ");
};

loop: WHILE LPAREN expression RPAREN LBRACE statements RBRACE
{
    printf("<loop> WHILE LPAREN <expression> RPAREN LBRACE <statement_list> RBRACE ");
};

expression: and_expression
{
    printf("<expression>");
}
;

and_expression: equality_expression
{
    printf("<and_expression>");
}
| and_expression AND equality_expression
{
    printf("<and_expression> AND");
}
;

equality_expression: relational_expression
{
    printf("<equality_expression>");
}
| equality_expression EQ relational_expression
{
    printf("<equality_expression> EQ");
}
| equality_expression NEQ relational_expression
{
    printf("<equality_expression> NEQ");
}
;

relational_expression: additive_expression
{
    printf("<relational_expression>");
}
| relational_expression LT additive_expression
{
    printf("<relational_expression> LT");
}
| relational_expression GT additive_expression
{
    printf("<relational_expression> GT");
}
| relational_expression LTE additive_expression
{
    printf("<relational_expression> LTE");
}
| relational_expression GTE additive_expression
{
    printf("<relational_expression> GTE");
}
;

additive_expression: multiplicative_expression
{
    printf("<additive_expression>");
}
| additive_expression PLUS multiplicative_expression
{
    printf("<additive_expression> PLUS");
}
| additive_expression MINUS multiplicative_expression
{
    printf("<additive_expression> MINUS");
}
;

multiplicative_expression: unary_expression
{
    printf("<multiplicative_expression>");
}
| multiplicative_expression TIMES unary_expression
{
    printf("<multiplicative_expression> TIMES");
}
| multiplicative_expression DIVIDE unary_expression
{
    printf("<multiplicative_expression> DIVIDE");
}
;

unary_expression: primary_expression
{
    printf("<unary_expression>");
}
| NOT unary_expression
{
    printf("<unary_expression> NOT");
}
| MINUS unary_expression
{
    printf("<unary_expression> MINUS");
}
;

primary_expression: literal
{
    printf("<primary_expression><literal>");
}
| IDENTIFIER
{
    printf("<primary_expression><identifier>");
}
| LPAREN expression RPAREN
{
    printf("<primary_expression>(<expression>)");
}
;

literal: boolean_literal
{
   //printf("<literal>");
}
| INTEGER_LITERAL
{
   //printf("<literal>");
};

boolean_literal: TRUE
{
   if (mode == 1) {
      printf("TRUE");
   } else {
      printf("true");
   }
}
| FALSE
{
   if (mode == 1) {
      printf("FALSE");
   } else {
      printf("false");
   }
};

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
