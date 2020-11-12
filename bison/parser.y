%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char*);
int yylex();
#define YYSTYPE char *
%}

%token T_Int T_Var T_Void T_Return T_ReadInt T_While T_Repeat T_EOL T_Let T_Func T_For T_In T_Class
%token T_If T_Else T_Break T_Continue T_Le T_Ge T_Eq T_Ne 
%token T_And T_Or T_IntConstant T_StringConstant T_Identifier T_IntervalTo T_IntervalLess T_DecimalConstant

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
|   ForStmt                                     { printf("stmt--->ForStmt\n\n"); }
|   ClassDecl                                   { printf("stmt--->ClassDecl\n\n"); }
|   ReturnStmt                                  { printf("stmt--->ReturnStmt\n\n"); }
|   RepeatWileStmt                              { printf("stmt--->RepeatWileStmt\n\n"); }
;

StmtSeparator:
    ';'
|   NewLines
;

NewLines:
    T_EOL
|   NewLines T_EOL
;

ExprsByComma:
    /* empty */             { /* empty */ }
|   Expr
|   ExprsByComma ',' Expr
;

Closure:
    '{' Program '}'
|   '{' '(' ExprsByComma ')' T_In Program '}'
;

ClosureOrNextLine:
    Closure
|   T_EOL Closure
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

CallExpr:
    T_Identifier '(' ActualParams  ')'
|   CallExpr Closure
;

ObjCallExpr:
    Expr '.' CallExpr
;

ReturnStmt:
    T_Return Expr
|   T_Return
;

ForStmt:
    T_For Expr T_In Expr ClosureOrNextLine
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
    T_Func T_Identifier '(' Args ')' ClosureOrNextLine
;

ClassDecl:
    T_Class T_Identifier ClosureOrNextLine
|   T_Class T_Identifier ':' T_Identifier ClosureOrNextLine
;

BreakStmt:
    T_Break                                         
;

ContinueStmt:
    T_Continue                                      
;

WhileStmt:
    T_While Expr ClosureOrNextLine
;

RepeatWileStmt:
    T_Repeat ClosureOrNextLine T_While Expr
;


IfStmt:
    T_If Expr ClosureOrNextLine                     { printf("oper->if stmt\n"); }
|   IfStmt T_Else ClosureOrNextLine                 { printf("oper->if else stmt\n"); }
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


ArrayExpr:
    '[' ExprsByComma ']'
;

DictionElement:
    /* empty */             { /* empty */ }
|   T_Identifier ':' Expr
|   T_StringConstant ':' Expr
|   DictionElement ',' DictionElement
;

DictionExpr:
    '{' DictionElement '}'
;

Expr:
    Expr '+' Expr           { printf("\tadd\n"); }
|   Expr '-' Expr           { printf("\tsub\n"); }
|   Expr '*' Expr           { printf("\tmul\n"); }
|   Expr '/' Expr           { printf("\tdiv\n"); }
|   Expr '%' Expr           { printf("\tmod\n"); }
|   Expr '>' Expr           { printf("\tcmpgt\n"); }
|   Expr '<' Expr           { printf("\tcmplt\n"); }
|   Expr T_Ge Expr          { printf("\tcmpge\n"); }
|   Expr T_Le Expr          { printf("\tcmple\n"); }
|   Expr T_Eq Expr          { printf("\tcmpeq\n"); }
|   Expr T_Ne Expr          { printf("\tcmpne\n"); }
|   Expr T_Or Expr          { printf("\tor\n"); }
|   Expr T_And Expr         { printf("\tand\n"); }
|   '-' Expr %prec '!'      { printf("\tneg\n"); }
|   '+' Expr %prec '!'      { /* empty */ }
|   '!' Expr                { printf("\tnot\n"); }
|   T_IntConstant           { printf("\tpush %s\n", $1); }
|   T_DecimalConstant       { printf("\tpush %s\n", $1); }
|   T_Identifier            { printf("\tpush %s\n", $1); }
|   CallExpr                { printf("oper->CallExpr\n"); }
|   '(' Expr ')'            { /* empty */ }
|   IntervalExpr            { /* empty */ }
|   T_StringConstant        { /* empty */ }
|   ArrayExpr               { printf("oper->arratExpr\n"); }
|   DictionExpr             { printf("oper->DictionExpr\n"); }
|   ObjCallExpr             { printf("oper->ObjCallExpr\n"); }
|   Expr '?' Expr ':' Expr  { printf("oper->conditional operation\n"); }
;

%%

int main() {
    return yyparse();
}