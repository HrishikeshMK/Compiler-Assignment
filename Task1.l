%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_VARS 100

// Variable table to store variable names and their declaration status
typedef struct {
    char name[50];
    int declared;
} Variable;

Variable varTable[MAX_VARS];
int varCount = 0;
int inVarDecl = 0;

// Keywords
char *keywords[] = {
    "int", "char", "if", "else", "while", "for", "main", "begin", "end", 
    "print", "scan", "program", "VarDecl", "inc", "dec"
};

// Utility functions
int isKeyword(char *str) {
    for (int i = 0; i < sizeof(keywords) / sizeof(keywords[0]); i++) {
        if (strcmp(str, keywords[i]) == 0) return 1;
    }
    return 0;
}

int isValidIdentifier(char *str) {
    int len = strlen(str);
    int underscore_count = 0;
    if (!(str[0] >= 'a' && str[0] <= 'z')) return 0;
    for (int i = 0; i < len; i++) {
        if (str[i] == '_') underscore_count++;
        if (underscore_count > 1) return 0;
        if (!(isalnum(str[i]) || str[i] == '_')) return 0;
    }
    return 1;
}

void addVariable(char *name) {
    for (int i = 0; i < varCount; i++) {
        if (strcmp(varTable[i].name, name) == 0) {
            printf("Error: Variable '%s' is defined more than once.\n", name);
            return;
        }
    }
    strcpy(varTable[varCount].name, name);
    varTable[varCount].declared = inVarDecl;
    varCount++;
}

%}

%%
// Tokens
"begin program:"                { printf("BEGIN_PROGRAM token\n"); }
"end program"                   { printf("END_PROGRAM token\n"); }
"begin VarDecl:"                 { inVarDecl = 1; printf("BEGIN_VARDECL token\n"); }
"end VarDecl"                   { inVarDecl = 0; printf("END_VARDECL token\n"); }
"print"                         { printf("PRINT token\n"); }
"scan"                          { printf("SCAN token\n"); }
"if"                            { printf("IF token\n"); }
"else"                          { printf("ELSE token\n"); }
"while"                         { printf("WHILE token\n"); }
"for"                           { printf("FOR token\n"); }
"int"                           { printf("INT token\n"); }
"char"                          { printf("CHAR token\n"); }

// Identifiers
[a-z][a-z0-9_]*                   {
    if (isKeyword(yytext)) {
        printf("Error: Keyword '%s' used as a variable name.\n", yytext);
    } else if (!isValidIdentifier(yytext)) {
        printf("Error: Invalid identifier '%s'.\n", yytext);
    } else {
        addVariable(yytext);
        printf("IDENTIFIER token (%s)\n", yytext);
    }
}

// Constants
"'"[ -~]"'"                   { printf("CHAR_CONSTANT token (%s)\n", yytext); }
"\""[^"]*"\""            { printf("STRING_CONSTANT token (%s)\n", yytext); }
"("[0-9]+", "[2|8|10]")"    { printf("INTEGER_CONSTANT token (%s)\n", yytext); }
"("[0-9]+", "[0-9]*")"      { printf("Error: Invalid integer constant format %s\n", yytext); }

// Operators
[\+\-\*/%]                     { printf("OPERATOR token (%s)\n", yytext); }
":=" | "\+=" | "\-=" | "\*=" | "/=" | "%=" { printf("ASSIGN_OP token (%s)\n", yytext); }

// Separators
[(){};:,<>]                       { printf("SEPARATOR token (%s)\n", yytext); }

// Ignore whitespace and comments
[ \t\n]+                        { /* Ignore whitespace */ }
"//".*                          { /* Ignore single-line comments */ }
"/\*"([^*]|\*+[^*/])*"\*/" { /* Ignore multi-line comments */ }

.                                 { printf("UNKNOWN token (%s)\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
