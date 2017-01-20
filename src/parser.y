%{
#include <stdio.h>
#include <stdlib.h>

// stuff from flex that bison needs to know about
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;
extern char* yytext;

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
%token <sval> tIDENTIFIER
%token tENDL

// define the "terminal symbols" and associate each with a field of the union:
%token <ival> tINT
%token <fval> tFLOAT
%token <sval> tSTRING

%start prog

%left tMINUS tPLUS
%left tTIMES tDIVIDE
%left UMINUS

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
    tVAR tIDENTIFIER tCOLON tFLOAT_TYPE tSEMICOLON { printf("found a float declaration: %s\n", $2); } |
    tVAR tIDENTIFIER tCOLON tINT_TYPE tSEMICOLON { printf("found an int declaration: %s\n", $2); } |
    tVAR tIDENTIFIER tCOLON tSTRING_TYPE tSEMICOLON { printf("found a string declaration: %s\n", $2); }
    ;

stmt:
    assignment | funccall | whileloop | condblock
    ;

assignment:
    tIDENTIFIER tASSIGN expr tSEMICOLON { printf("found an assignment\n"); }
    ;

funccall:
    tREAD tIDENTIFIER tSEMICOLON { printf("found a call to read\n"); } |
    tPRINT expr tSEMICOLON { printf("found a call to print\n"); }

expr:
    tIDENTIFIER |
    tFLOAT |
    tINT |
    tSTRING |
    tLPAREN expr tRPAREN |
    expr tPLUS expr { printf("found an addition\n"); } |
    expr tMINUS expr { printf("found a subtraction\n"); } |
    expr tTIMES expr { printf("found a multiplication\n"); } |
    expr tDIVIDE expr { printf("found a division\n"); } |
    tMINUS expr %prec UMINUS { printf("found a unary minus\n"); }
    ;

whileloop:
    tWHILE expr tDO stmts tDONE
    ;

condblock:
    ifblock elseblock tENDIF
    ;

ifblock:
    tIF expr tTHEN stmts
    ;

elseblock:
    tELSE stmts | /*epsilon*/
    ;

%%

int main(int argc, char* argv[]) {

#ifdef FLEX_DEBUG
    // parse through the input until there is no more:
    do {
        yylex();
    } while (!feof(yyin));
#endif

#ifndef FLEX_DEBUG
    // If file name passed, read from that file. Else, do nothing
    char* fname;
    if (argc == 2) {
        fname = argv[1];
    } else {
        fname = "./src/test.min";
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

    printf("VALID\n");
#endif

}

void yyerror(const char *s) {
	printf("YIKES, parse error on line %d, before %s. Message: %s\n", yylineno, yytext, s);
    printf("INVALID\n");
	// exit on parse error
	exit(1);
}
