%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
int yylex();
#define YYSTYPE char *
%}

%token T_Int T_Var T_Void T_Return T_Print T_ReadInt T_While T_EOL T_Let T_Func
%token T_If T_Else T_Break T_Continue T_Le T_Ge T_Eq T_Ne  
%token T_And T_Or T_IntConstant T_StringConstant T_Identifier T_IntervalTo T_IntervalLess

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
    StmtSeparator
|   VarDecl StmtSeparator                       { printf("stmt--->VarDecl\n\n"); }
|   FuncDecl                                    { printf("stmt--->FuncDecl\n\n"); }
|   AssignStmt StmtSeparator                    { printf("stmt--->AssignStmt\n\n"); }
|   Expr                                        { printf("stmt--->Expr\n\n"); }
|   IfStmt                                      { printf("stmt--->IfStmt\n\n"); }
|   WhileStmt                                   { printf("stmt--->WhileStmt\n\n"); }
|   BreakStmt StmtSeparator                     { printf("stmt--->BreakStmt\n\n"); }
|   ContinueStmt StmtSeparator                  { printf("stmt--->ContinueStmt\n\n"); }
|   CallStmt                                    { printf("stmt--->CallStmt\n\n"); }
;

StmtSeparator:
    ';'
|   NewLines
;

NewLines:
    T_EOL
|   NewLines T_EOL
;

EmptyOrNewLines:
    /* empty */             { /* empty */ }
|   NewLines
;

Closure:
    '{' Program '}'
;

EmptyOrClosure:
|   Closure
;

ActualParams:
    /* empty */             { /* empty */ }
|   ActualParam
|   ActualParams ',' ActualParam
;

ActualParam:
    Expr
|   T_Identifier ':' Expr
;

CallStmt:
    T_Identifier '(' ActualParams  ')' EmptyOrClosure
;


Args:
    /* empty */             { /* empty */ }
|   Arg
|   Args ',' Arg 
;

Arg:
    T_Identifier                                    { printf("oper->args\n"); }
|   Arg '=' Expr                                    { printf("oper->default args\n"); }
;

FuncDecl:
    T_Func T_Identifier '(' Args ')' EmptyOrNewLines Closure
;

BreakStmt:
    T_Break                                         
;

ContinueStmt:
    T_Continue                                      
;

WhileStmt:
    T_While Expr Closure                            
;


IfStmt:
    T_If Expr Closure                               { printf("oper->if stmt\n"); }
|   IfStmt T_Else Closure                           { printf("oper->if else stmt\n"); }
|   IfStmt T_Else IfStmt                            { printf("oper->if else if stmt\n"); }
;

VarDecl:
    T_Var T_Identifier                              { printf("oper->var %s \n", $2); }
|   T_Let T_Identifier                              { printf("oper->let %s \n", $2); }
|   VarDecl '=' Expr                                { printf("oper->var&assign pop %s \n",$2); }
;

AssignStmt:
    T_Identifier '=' Expr                           { printf("oper->pop %s \n", $1); }
;

IntervalExpr:
    Expr T_IntervalTo Expr                          { printf("oper->IntervalTo \n"); }
|   Expr T_IntervalLess Expr                        { printf("oper->IntervalLess \n"); }
;

Expr:
    T_IntConstant                                   { printf("oper->push %s \n", $1); }
|   T_Identifier                                    { printf("oper->push %s \n", $1); }
|   CallStmt
|   '(' Expr ')'
|   '-' Expr %prec '!'                              { printf("\tneg\n"); }
|   '!' Expr                                        { printf("\tnot\n"); }
|   IntervalExpr                                    
;

%%

int main() {
    return yyparse();
}