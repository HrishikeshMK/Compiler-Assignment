%{
#include "parser.tab.h" 
#include <string.h>
#include <stdlib.h>
%}

%%
"begin"             { return PROG_BEGIN; }
"end"               { return END; }
"program"           { return PROGRAM; }
"VarDecl"           { return VARDECL; }
"int"               { return INT; }
"char"              { return CHAR; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"do"                { return DO; }
"for"               { return FOR; }
"to"                { return TO; }
"inc"               { return INC; }
"dec"               { return DEC; }
"print"             { return PRINT; }
"scan"              { return SCAN; }


":="                { return ASSIGN; }
"+="                { return ADD_ASSIGN; }
"-="                { return SUB_ASSIGN; }
"*="                { return MUL_ASSIGN; }
"/="                { return DIV_ASSIGN; }
"%="                { return MOD_ASSIGN; }

">="                { return GE; }
"<="                { return LE; }
"<>"                { return NE; }
"="                 { return EQ; }
">"                 { return GT; }
"<"                 { return LT; }

"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MUL; }
"/"                 { return DIV; }
"%"                 { return MOD; }


"("                 { return LPAREN; }
")"                 { return RPAREN; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
";"                 { return SEMICOLON; }
":"                 { return COLON; }
","                 { return COMMA; }


[0-9]+              { yylval.num = atoi(yytext); return DIGITSEQ; }

"\("[0-9]+","2"\)"     { yylval.str = strdup(yytext); return INTCONST; }
"\("[0-9]+","8"\)"     { yylval.str = strdup(yytext); return INTCONST; }
"\("[0-9]+","10"\)"    { yylval.str = strdup(yytext); return INTCONST; }


"'"[ -~]"'"         { yylval.str = strdup(yytext); return CHARCONST; }
\"[^\"]*\"          { yylval.str = strdup(yytext); return STRINGCONST; }


[a-z][a-z0-9_]*     { yylval.str = strdup(yytext); return IDENTIFIER; }


[ \t\n]+             { /* Ignore whitespace */ }
"//".*               { /* Ignore single-line comments */ }
"/*"[^*]*"*"*([^*/][^*]*"*"*)*"*/" { /* Ignore multi-line comments */ }


.                   { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
