%{
#include <stdio.h>
#include <stdlib.h>

// stuff from flex that bison needs to know about
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
%}

%union {
	int ival;
	float fval;
	char *sval;
}

// define the constant-string tokens
%token tVAR tCOLON
%token tFLOAT_TYPE tINT_TYPE tSTRING_TYPE
%token tWHILE tDO tDONE
%token tIF tTHEN tELSE tENDIF
%token tSEMICOLON
%token tPRINT
%token tREAD
%token tTIMES tDIVIDE tPLUS tMINUS
%token tASSIGN
%token tLPAREN tRPAREN
%token tIDENTIFIER

// define the "terminal symbols" and associate each with a field of the union:
%token <ival> tINT
%token <fval> tFLOAT
%token <sval> tSTRING

%%
// this is the actual grammar (productions) that bison will parse
// the first rule defined is the highest-level rule
// (note: $1 is the first thing matched, $2 is the second, etc.)

prog:
    dcls stmts { printf("done with a MiniLang file!\n"); }
    ;

dcls:
    dcls dcl | /*epsilon*/ { printf("found the declarations\n"); }
    ;

stmts:
    stmts stmt | /*epsilon*/ { printf("found the statements\n"); }
    ;

dcl:
    tFLOAT  { printf("found a declaration\n"); }
    ;

stmt:
    tINT    { printf("found a statement\n"); }
    ;

%%

int main(int argc, char* argv[]) {

    // If file name passed, read from that file. Else, do nothing
    char* fname;
    if (argc == 2) {
        fname = argv[1];
    } else {
        fname = "test.min";
    }

    // open a file handle to the file to scan
    FILE *myfile = fopen(fname, "r");
    // make sure it's valid:
    if (!myfile) {
        printf("Error: can't open the file '%s'\n", fname);
        return 1;
    }
    // set lex to read from it instead of defaulting to STDIN:
    yyin = myfile;

    // parse through the input until there is no more:
    do {
        yyparse();
    } while (!feof(yyin));
}

void yyerror(const char *s) {
	printf("YIKES, parse error on line %d. Message: %s\n", yylineno, s);
	// exit on parse error
	exit(1);
}
