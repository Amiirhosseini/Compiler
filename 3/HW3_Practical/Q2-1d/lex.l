/* Amirreza Hosseini */
/* 9820363 */
/* syntax parser */
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "gram.tab.h"
extern int mode;
%}

%option noyywrap
%option yylineno

%%

"int"       { return INT; }
"bool"      { return BOOL; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"true"      { return TRUE; }
"false"     { return FALSE; }
"||"        { return OR; }
"&&"        { return AND; }
"="         { return ASSIGN; }
"=="        { return EQ; }
"!="        { return NEQ; }
"<="        { return LTE; }
">="        { return GTE; }
"<"         { return LT; }
">"         { return GT; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"!"         { return NOT; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
","         {return COMMA;}
[0-9]+      {
    yylval.value = atoi(yytext);
    printf("INTEGER_LITERAL ");
    if (mode == 1) printf("%d ", yylval.value);
    else printf("%s ", yytext);
    return INTEGER_LITERAL;
}
[a-zA-Z][a-zA-Z0-9]* {
    yylval.name = strdup(yytext);
    printf("IDENTIFIER ");
    if (mode == 1) printf("%s ", yylval.name);
    else printf("%s ", yytext);
    return IDENTIFIER;
}
[ \t\n]     /* ignore whitespace */
.           /* ignore other characters */

%%
