%{
#define YYSTYPE char *
#include "y.tab.h"
int cur_line = 1;
void yyerror(const char *msg);
void unrecognized_char(char c);
void unterminate_string();
#define _DUPTEXT {yylval = strdup(yytext);}
%}

/* note \042 is '"' */
WHITESPACE          ([ \t\r\a]+)
SINGLE_COMMENT1     ("//"[^\n]*)
SINGLE_COMMENT2     ("#"[^\n]*)
OPERATOR            ([+*-/%=:;,!<>(){}\?\.\[\]])
INTEGER             ([0-9]+)
IDENTIFIER          ([_a-zA-Z][_a-zA-Z0-9]*)
UNTERM_STRING       (\042[^\042\n]*)
STRING              (\042[^\042\n]*\042)

%%
\n                  { printf("token: T_EOL \n"); cur_line++; return T_EOL; }
{WHITESPACE}        { /* ignore every whitespace */ }
{SINGLE_COMMENT1}   { /* skip for single line comment */    }
{SINGLE_COMMENT2}   { /* skip for single line comment */    }

{OPERATOR}          { printf("token: %s \n",yytext); return yytext[0]; }
"func"              { printf("token: %s \n",yytext); return T_Func; }
"var"               { printf("token: %s \n",yytext); return T_Var; } 
"let"               { printf("token: %s \n",yytext); return T_Let; } 
"int"               { printf("token: %s \n",yytext); return T_Int; }
"void"              { printf("token: %s \n",yytext); return T_Void; }
"return"            { printf("token: %s \n",yytext); return T_Return; }
"readint"           { printf("token: %s \n",yytext); return T_ReadInt; }
"while"             { printf("token: %s \n",yytext); return T_While; }
"if"                { printf("token: %s \n",yytext); return T_If; }
"else"              { printf("token: %s \n",yytext); return T_Else; }
"break"             { printf("token: %s \n",yytext); return T_Break; }
"continue"          { printf("token: %s \n",yytext); return T_Continue; }
"<="                { printf("token: %s \n",yytext); return T_Le; }
">="                { printf("token: %s \n",yytext); return T_Ge; }
"=="                { printf("token: %s \n",yytext); return T_Eq; }
"!="                { printf("token: %s \n",yytext); return T_Ne; }
"&&"                { printf("token: %s \n",yytext); return T_And; }
"||"                { printf("token: %s \n",yytext); return T_Or; }
"..."               { printf("token: %s \n",yytext); return T_IntervalTo; }
"..<"               { printf("token: %s \n",yytext); return T_IntervalLess; }
"for"               { printf("token: %s \n",yytext); return T_For; }
"in"                { printf("token: %s \n",yytext); return T_In; }
"class"             { printf("token: %s \n",yytext); return T_Class; }
"repeat"            { printf("token: %s \n",yytext); return T_Repeat; }

{INTEGER}           { printf("token: %s \n",yytext); _DUPTEXT return T_IntConstant; }
{STRING}            { printf("token: %s \n",yytext); _DUPTEXT return T_StringConstant; }
{IDENTIFIER}        { printf("token: %s \n",yytext); _DUPTEXT return T_Identifier; }

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