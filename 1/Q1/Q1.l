/* Amirreza Hosseini */
/* 9820363 */
/* Morse Code Translator */
/* Get char as input from input.txt and save equivalent morse code output to output.txt */

%{
#include <stdio.h>
#include <string.h>

//define string output
char output[1000];
int i = 0;
%}

%%
[aA] {printf("._ ");output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[bB] {printf("_... ");output[i]='_';i++;output[i]='.';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[cC] {printf("_._. ");output[i]='_';i++;output[i]='.';i++;output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[dD] {printf("_.. ");   output[i]='_';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[eE] {printf(". "); output[i]='.';i++;output[i]=' ';i++;}
[fF] {printf(".._. ");  output[i]='.';i++;output[i]='.';i++;output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[gG] {printf("__. ");   output[i]='_';i++;output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[hH] {printf(".... ");  output[i]='.';i++;output[i]='.';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[iI] {printf(".. ");    output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[jJ] {printf(".___ ");  output[i]='.';i++;output[i]='_';i++;output[i]='_';i++;output[i]='_';i++;output[i]=' ';i++;}
[kK] {printf("_._ ");   output[i]='_';i++;output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[lL] {printf("._.. ");  output[i]='.';i++;output[i]='_';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[mM] {printf("__ ");    output[i]='_';i++;output[i]='_';i++;output[i]=' ';i++;}
[nN] {printf("_. ");    output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[oO] {printf("___ ");   output[i]='_';i++;output[i]='_';i++;output[i]='_';i++;output[i]=' ';i++;}
[pP] {printf(".__. ");  output[i]='.';i++;output[i]='_';i++;output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[qQ] {printf("__._ ");  output[i]='_';i++;output[i]='_';i++;output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[rR] {printf("._. ");   output[i]='.';i++;output[i]='_';i++;output[i]='.';i++;output[i]=' ';i++;}
[sS] {printf("... ");   output[i]='.';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
[tT] {printf("_ ");     output[i]='_';i++;output[i]=' ';i++;}
[uU] {printf(".._ ");   output[i]='.';i++;output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[vV] {printf("..._ ");  output[i]='.';i++;output[i]='.';i++;output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[wW] {printf(".__ ");   output[i]='.';i++;output[i]='_';i++;output[i]='_';i++;output[i]=' ';i++;}
[xX] {printf("_.._ ");  output[i]='_';i++;output[i]='.';i++;output[i]='.';i++;output[i]='_';i++;output[i]=' ';i++;}
[yY] {printf("_.__ ");  output[i]='_';i++;output[i]='.';i++;output[i]='_';i++;output[i]='_';i++;output[i]=' ';i++;}
[zZ] {printf("__.. ");  output[i]='_';i++;output[i]='_';i++;output[i]='.';i++;output[i]='.';i++;output[i]=' ';i++;}
" " {printf("/");   output[i]='/';i++;}
%%

int yywrap(){}

int main()
{
    FILE *f = fopen("./input.txt","r");
    yyin = f;
    yylex();
    
    //trim the output from begining to index i
    char *trimmed = malloc(i);
    strncpy(trimmed, output, i);
    //save trimmed to file
    FILE *f2 = fopen("./output.txt","w");
    fprintf(f2, "%s", trimmed);
    fclose(f2);
    return 0;
}