/* Amirreza Hosseini */
/* 9820363 */
/* lexical analyser */
/* find tokens in the source code */
/* token string any string between ""  */

%{
#include <stdio.h>
%}

%%
(b|g|m|p|v)+e+t {printf("Token_xet ");}
[0-9]+ {printf("Token_Integer ");}
" " {printf("Token_Space ");}
\n {printf("Token_NewLine ");}
[0-9]+.[0-9]+ {printf("Token_Float ");}
[//[a-zA-Z0-9]+\n] {printf("Token_Comment ");}
\"([a-zA-Z0-9]+)\" {printf("Token_String ");}
[a-z]+([0-9]|[a-z])* {printf("Id_Token ");}
%%

int yywrap(){}

int main()
{
    FILE *f = fopen("./input.txt","r");
    yyin = f;
    yylex();
    return 0;
}