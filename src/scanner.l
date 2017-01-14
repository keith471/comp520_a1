%{
#include <stdio.h> // for printf
#include "y.tab.h"  // to get the token types that we return to Bison
%}
%option yylineno
%%

[ \t]               { ; }
var                 { /*printf("found a 'var'\n");*/ return tVAR; }
while               { /*printf("found a 'while'\n");*/ return tWHILE; }
do                  { /*printf("found a 'do'\n");*/ return tDO; }
done                { /*printf("found a 'done'\n");*/ return tDONE; }
if                  { /*printf("found an 'if'\n");*/ return tIF; }
then                { /*printf("found a 'then'\n");*/ return tTHEN; }
else                { /*printf("found an 'else'\n");*/ return tELSE; }
endif               { /*printf("found an 'endif'\n");*/ return tENDIF; }
float               { /*printf("found a 'float'\n");*/ return tFLOAT_TYPE; }
int                 { /*printf("found an 'int'\n");*/ return tINT_TYPE; }
string              { /*printf("found a 'string'\n");*/ return tSTRING_TYPE; }
print               { /*printf("found a 'print'\n");*/ return tPRINT; }
read                { /*printf("found a 'read'\n");*/ return tREAD; }
";"                 { /*printf("found a semicolon\n");*/ return tSEMICOLON; }
":"                 { /*printf("found a colon\n");*/ return tCOLON; }
"*"                 { /*printf("found a times\n");*/ return tTIMES; }
"/"                 { /*printf("found a division\n");*/ return tDIVIDE; }
"+"                 { /*printf("found a plus\n");*/ return tPLUS; }
"-"                 { /*printf("found a minus\n");*/ return tMINUS; }
"("                 { /*printf("found a left parenthesis\n");*/ return tLPAREN; }
")"                 { /*printf("found a right parenthesis\n");*/ return tRPAREN; }
"="                 { /*printf("found an assignment operator\n");*/ return tASSIGN; }
[0-9]+\.[0-9]+      { /*printf("found a float: %s\n", yytext);*/ yylval.fval = atof(yytext); return tFLOAT; }
0|[1-9][0-9]*       { /*printf("found an int: %s\n", yytext);*/ yylval.ival = atoi(yytext); return tINT; }
[a-zA-z_][a-zA-z_0-9]*  { /*printf("found an identifier: %s\n", yytext);*/ return tIDENTIFIER; }
\"(?:\\.|[^"\\])*\"     {
                      /*printf("found a string: %s\n", yytext);*/
                      // we have to copy because we can't rely on yytext not changing underneath us:
                      yylval.sval = strdup(yytext);
                      return tSTRING;
}
\/\/.*              { ; /*printf("found a single-line comment: %s\n", yytext);*/ }
\n                  { ; /*return tENDL*/ }

%%
