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
|   Program Stmt 
;


Stmt:
    StmtSeparator
|   VarDecl StmtSeparator                       
|   FuncDecl                                    
|   AssignStmt StmtSeparator                    
|   Expr                                        
|   IfStmt                                      
|   WhileStmt                                   
|   BreakStmt StmtSeparator                     
|   ContinueStmt StmtSeparator                  
|   ForStmt                                     
|   ClassDecl                                   
|   ReturnStmt                                  
|   RepeatWileStmt                              
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
    '{' Program '}'                                    { printf("\t闭包结束\n"); }
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
    T_Identifier ':' Expr                               { printf("\t记录栈顶参数 -> %s 到参数集 \n",$1);} 
;

CallExpr:
    CallFuncName '(' ActualParams ')'                   { printf("\t跳转到方法 -> %s\n",$1); }
|   CallExpr Closure                                    { printf("\t记录栈闭包 -> %s \n",$1); }
;

CallFuncName:
    T_Identifier                                        { printf("\t调用方法 -> %s,创建参数集 \n",$1); }
;

ObjCallExpr:
    Expr '.' CallExpr
;

ReturnStmt:
    T_Return Expr                                       { printf("\tret ~\n\n"); }
|   T_Return                                            { printf("\tret\n\n"); }
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
    T_Identifier                                          
|   Arg '=' Expr                                          
;

FuncDecl:
    T_Func FuncName '(' Args ')' ClosureOrNextLine        { printf("\tENDFUNC\n\n"); }
;

FuncName:
    T_Identifier                                          { printf("\tFUNC @%s:\n", $1); }
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
    T_If Expr ClosureOrNextLine                     
|   IfStmt T_Else ClosureOrNextLine                 
|   IfStmt T_Else IfStmt                            
;

VarDecl:
    T_Var T_Identifier                              { printf("\tvar %s \n", $2); }
|   T_Let T_Identifier                              { printf("\tlet %s \n", $2); }
|   VarDecl '=' Expr                                { printf("\tpop %s \n", $1); }
;

AssignStmt:
    T_Identifier '=' Expr                           { printf("oper->pop %s \n", $1); }
;

IntervalExpr:
    Expr T_IntervalTo Expr                          
|   Expr T_IntervalLess Expr                        
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
|   CallExpr                
|   '(' Expr ')'
|   IntervalExpr            
|   T_StringConstant        
|   ArrayExpr               
|   DictionExpr             
|   ObjCallExpr             
|   Expr '?' Expr ':' Expr  
;

%%

int main() {
    return yyparse();
}