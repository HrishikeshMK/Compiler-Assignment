/* parser.y - Bison file for the language grammar */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int yylineno;
extern char* yytext;
int yyparse();
void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
    int num;
}

%define parse.error verbose
/* Terminals from the lexer */
%token <str> IDENTIFIER STRINGCONST CHARCONST INTCONST
%token PROG_BEGIN END PROGRAM VARDECL
%token PRINT SCAN IF ELSE WHILE FOR INT CHAR
%token INC DEC
%token ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%token GT LT GE LE EQ NE
%token TO DO
%token PLUS MINUS MUL DIV MOD
%token LPAREN RPAREN LBRACKET RBRACKET SEMICOLON COLON COMMA
%token <num> DIGITSEQ


%left PLUS MINUS
%left MUL DIV MOD


%%

Program         : PROG_BEGIN PROGRAM COLON DeclBlock StmtBlock END PROGRAM
                ;

DeclBlock       : PROG_BEGIN VARDECL COLON DeclList END VARDECL
                ;

DeclList        : Decl DeclList
                | /* empty */
                ;

Decl            : LPAREN Var COMMA Type RPAREN SEMICOLON
                ;

Var             : IDENTIFIER
                | IDENTIFIER LBRACKET DigitSeq RBRACKET
                ;

Type            : INT
                | CHAR
                ;

DigitSeq        : DIGITSEQ
                ;

StmtBlock       : Stmt StmtBlock
                | /* empty */
                ;

Stmt            : AssignStmt
                | IfStmt
                | WhileStmt
                | ForStmt
                | PrintStmt
                | ScanStmt
                | BlockStmt
                ;

AssignStmt      : IDENTIFIER AssignOp Exp SEMICOLON
                ;

AssignOp        : ASSIGN | ADD_ASSIGN | SUB_ASSIGN | MUL_ASSIGN | DIV_ASSIGN | MOD_ASSIGN
                ;

IfStmt		: IF LPAREN Condition RPAREN CompoundStmt SEMICOLON          
    		| IF LPAREN Condition RPAREN CompoundStmt ELSE CompoundStmt SEMICOLON   
    		;

                
WhileStmt	: WHILE LPAREN Condition RPAREN DO CompoundStmt SEMICOLON
         	;

CompoundStmt	: PROG_BEGIN StmtBlock END
            	;


ForStmt         : FOR IDENTIFIER ASSIGN Exp TO Exp ForIncDec Exp DO Stmt
                ;

ForIncDec       : INC | DEC
                ;

PrintStmt       : PRINT LPAREN STRINGCONST PrintArgs RPAREN SEMICOLON
                ;

PrintArgs       : COMMA ExpList
                | /* empty */
                ;

ExpList         : Exp
                | Exp COMMA ExpList
                ;

ScanStmt        : SCAN LPAREN STRINGCONST ScanArgs RPAREN SEMICOLON
                ;

ScanArgs        : COMMA IdList
                | /* empty */
                ;

IdList          : IDENTIFIER
                | IDENTIFIER COMMA IdList
                ;

BlockStmt       : PROG_BEGIN StmtBlock END
                ;

Exp : IDENTIFIER
    | CHARCONST
    | integer_constant
    | LPAREN Exp RPAREN
    | Exp PLUS Exp
    | Exp MINUS Exp
    | Exp MUL Exp
    | Exp DIV Exp
    | Exp MOD Exp
    ;


integer_constant: LPAREN DIGITSEQ COMMA DIGITSEQ RPAREN
                ;

Term            : Term MUL Factor
                | Term DIV Factor
                | Term MOD Factor
                | Factor
                ;

Factor          : LPAREN Exp RPAREN
                | INTCONST
                | IDENTIFIER
                | CHARCONST
                ;


Condition       : Exp RelOp Exp
                ;

RelOp           : GT | LT | GE | LE | EQ | NE
                ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s near token '%s'\n", yylineno, s, yytext);
}

int main(int argc, char *argv[]) {

if (argc != 2) {
fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
return 1;
}
yyin = fopen(argv[1], "r");
if (!yyin) {
perror("Error opening file");
return 1;
}
if (yyparse() == 0) {
        printf("Input successfully parsed.\n");
    }
fclose(yyin);
return 0;
}
