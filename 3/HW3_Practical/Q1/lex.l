/* Amirreza Hosseini */
/* 9820363 */
/* Simple calculator */
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol.h"
#include "gram.tab.h"
int previous_token = 0;
void yyerror(const char *message);

%}

%option noyywrap
%option yylineno
%%
("print")|("PRINT")                             { previous_token=PRINT; return PRINT; }
[ \t]
[0-9]+(\.[0-9]+)?          					    { yylval.num = atof(yytext); previous_token=NUMBER; return NUMBER; }
"+"                         					{ previous_token= ADD; return ADD; }
"-"                         					{ if (previous_token == NUMBER || previous_token == R_BRACKET || previous_token == VARIABLE) {
                                                    return SUB;
                                                } else {
                                                    return NEG;
                                                }}
"*"                         					{ previous_token=MUL; return MUL; }
"/"                         					{ previous_token= DIV; return DIV; }
"%"												{ previous_token= MOD; return MOD; }
"^"                         					{ previous_token=POW; return POW; }
"="												{ previous_token=EQUALS; return EQUALS; }
"("												{ previous_token= L_BRACKET; return L_BRACKET; }
")"												{ previous_token= R_BRACKET; return R_BRACKET; }
("cos")|("COS")									{ previous_token= COS; return COS; }
("sin")|("SIN")									{ previous_token= SIN; return SIN; }
("tan")|("TAN")									{ previous_token = TAN; return TAN; }
("cot")|("COT")									{ previous_token = COT; return COT; }
("log")|("LOG")									{ previous_token = LOG; return LOG; }
("exp")|("EXP")									{ previous_token= EXP; return EXP; }
[a-zA-Z][a-zA-Z0-9]*_*[a-zA-Z0-9]*				{ previous_token= VARIABLE; yylval.index = add_variable(yytext); return VARIABLE; }
[\n]                        					{ previous_token= NEW_LINE;return NEW_LINE; }
[0-9a-zA-Z]+_*[a-zA-Z0-9]*                      { yyerror(" invalid variable name"); }
.												{ char* error = (char*)malloc(100*sizeof(char)); sprintf(error, "invalid character: %s", yytext); yyerror(error); free(error); }
%%
