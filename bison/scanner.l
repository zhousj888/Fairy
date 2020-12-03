%{
#define YYSTYPE char *
#include "y.tab.h"
void yyerror(const char *msg);
void unrecognized_char(char c);
void unterminate_string(void);
#define _DUPTEXT {yylval = strdup(yytext);}
int cur_line = 1;
%}

/* note \042 is '"' */
WHITESPACE          ([ \t\r\a]+)
SINGLE_COMMENT1     ("//"[^\n]*)
SINGLE_COMMENT2     ("#"[^\n]*)
OPERATOR            ([+*-/%=:;,!<>(){}\?\.\[\]])
INTEGER             ([0-9]+)
HEXINTEGER          (0[xX][0-9a-fA-F]+)
DECIMAL             ([0-9]+\.[0-9]+)
IDENTIFIER          ([_a-zA-Z][_a-zA-Z0-9]*)
UNTERM_STRING       (\042[^\042\n]*)
STRING              (\042[^\042\n]*\042)

%%
\n                  { cur_line++; return T_EOL; }
{WHITESPACE}        { /* ignore every whitespace */ }
{SINGLE_COMMENT1}   { /* skip for single line comment */    }
{SINGLE_COMMENT2}   { /* skip for single line comment */    }

{OPERATOR}          { return yytext[0]; }
"func"              { return T_Func; }
"var"               { return T_Var; } 
"let"               { return T_Let; } 
"int"               { return T_Int; }
"void"              { return T_Void; }
"return"            { return T_Return; }
"readint"           { return T_ReadInt; }
"while"             { return T_While; }
"if"                { return T_If; }
"else"              { return T_Else; }
"break"             { return T_Break; }
"continue"          { return T_Continue; }
"<="                { return T_Le; }
">="                { return T_Ge; }
"=="                { return T_Eq; }
"!="                { return T_Ne; }
"&&"                { return T_And; }
"||"                { return T_Or; }
"..."               { return T_IntervalTo; }
"..<"               { return T_IntervalLess; }
"for"               { return T_For; }
"in"                { return T_In; }
"class"             { return T_Class; }
"repeat"            { return T_Repeat; }

{INTEGER}           { _DUPTEXT return T_IntConstant; }
{HEXINTEGER}        { _DUPTEXT return T_IntConstant; }
{DECIMAL}           { _DUPTEXT return T_DecimalConstant; }

{STRING}            { _DUPTEXT return T_StringConstant; }
{IDENTIFIER}        { _DUPTEXT return T_Identifier; }

{UNTERM_STRING}     { unterminate_string(); }
.                   { unrecognized_char(yytext[0]); }

%%

int yywrap(void) { 
    return 1;
}

void unrecognized_char(char c) {
    char buf[32] = "Unrecognized character: ?";
    buf[24] = c;
    yyerror(buf);
}

void unterminate_string() {
    yyerror("Unterminate string constant");
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error at line %d:\n\t%s\n", cur_line, msg);
    exit(-1);
}
