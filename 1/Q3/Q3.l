/* Amirreza Hosseini */
/* 9820363 */
/* CPP lexical tokens */
/* find int,char and double tokens in the source code of main function of C++ program */
/* assingment needs space between the name of variable and the equal sign and the value of variable */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
%}

%%
#include" "*<[a-zA-Z0-9.]*> {}
; {}
"(" {}
")" {}
"{" {}
"}" {}
int" "main {}
(\t)*(\n)* {}
int" "(([a-z]+([0-9]*|[a-z]*)*)|","*)*(" "*=" "*[0-9]+)* {//extract the names of varables from yytext
    ///remove the sbustrings that are not names of varables
    char *token = strtok(yytext," ");

      token = strtok(NULL, " ");

      //remove the variables with comma
        while( token != NULL ) {
            
            token = strtok(token, ",");
             
            printf("%s int\n",token);

            token=strtok(NULL," ");

   }
}
double" "(([a-z]+([0-9]*|[a-z]*)*)|","*)*(" "*=" "*[0-9]+.[0-9]+)* {//extract the names of varables from yytext
    ///remove the sbustrings that are not names of varables
    char *token = strtok(yytext," ");

      token = strtok(NULL, " ");

      //remove the variables with comma
        while( token != NULL ) {
            
            token = strtok(token, ",");
             
            printf("%s double\n",token);

            token=strtok(NULL," ");

   }
}
char" "(([a-z]+([0-9]*|[a-z]*)*)|","*)*(" "*=" "*\'([a-zA-Z0-9])\')* {//extract the names of varables from yytext
    ///remove the sbustrings that are not names of varables
    char *token = strtok(yytext," ");

      token = strtok(NULL, " ");

      //remove the variables with comma
        while( token != NULL ) {
            
            token = strtok(token, ",");
             
            printf("%s char\n",token);

            token=strtok(NULL," ");

   }
}

%%

int yywrap(){}

int main()
{
    FILE *f = fopen("./input.cpp","r");
    yyin = f;
    yylex();
    return 0;
}