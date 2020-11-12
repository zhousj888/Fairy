%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
int yylex();
#define YYSTYPE char *
%}

%token T_Int T_Var T_Void T_Return T_Print T_ReadInt T_While T_EOS T_Let T_Func
%token T_If T_Else T_Break T_Continue T_Le T_Ge T_Eq T_Ne
%token T_And T_Or T_IntConstant T_StringConstant T_Identifier

%left '='
%left T_Or
%left T_And
%left T_Eq T_Ne
%left '<' '>' T_Le T_Ge
%left '+' '-'
%left '*' '/' '%'
%left '!'


%%

Program:
    /* empty */             { /* empty */ }
|   Stmt
|   Stmt Program  
;


Stmt:
    T_EOS
|   VarDecl                                         { printf("\n"); }
|   LetDecl                                         { printf("\n"); }
|   FuncDecl                                        { printf("\n"); }
|   AssignStmt                                      { printf("\n"); }
|   Expr                                            { printf("\n"); }
|   IfStmt                                          { printf("\n"); }
|   WhileStmt                                       { printf("\n"); }
|   BreakStmt                                       { printf("\n"); }
|   ContinueStmt                                    { printf("\n"); }
;

Closure:
    '{' Program '}'
;

Args:
    /* empty */             { /* empty */ }
|   Arg ',' Args
;

Arg:
    T_Identifier                                    { printf("oper->args\n"); }
|   Arg '=' Expr                                    { printf("oper->default args\n"); }
;

FuncDecl:
    T_Func T_Identifier '(' Args ')' Closure        { printf("oper->funcDecl\n"); }
;

BreakStmt:
    T_Break                                         { printf("oper->break\n"); }
;

ContinueStmt:
    T_Continue                                      { printf("oper->continue\n"); }
;

WhileStmt:
    T_While Expr Closure                            { printf("oper->while stmt\n"); }
;


IfStmt:
    T_If Expr Closure                               { printf("oper->if stmt\n"); }
|   IfStmt T_Else Closure                           { printf("oper->if else stmt\n"); }
|   IfStmt T_Else IfStmt                            { printf("oper->if else if stmt\n"); }
;

VarDecl:
    T_Var T_Identifier                              { printf("oper->var %s \n", $2); }
|   VarDecl '=' Expr                                { printf("oper->var&assign pop %s \n",$2); }
;

LetDecl:
    T_Let T_Identifier                              { printf("oper->let %s \n", $2); }
;

AssignStmt:
    T_Identifier '=' Expr                           { printf("oper->pop %s \n", $1); }
;

Expr:
    T_IntConstant                                   { printf("oper->push %s \n", $1); }
|   T_Identifier                                    { printf("oper->push %s \n", $1); }
;

%%

int main() {
    return yyparse();
}