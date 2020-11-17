%{
#include <stdio.h>
#include <stdlib.h>
#include "FAROperCmd.h"
void yyerror(const char*);
int yylex(void);
void addCmd0(int cmd);
void addCmd1(int cmd, char *oper1);
#define YYSTYPE char *

int ifStmtId = 0, ifThenId = 0, ifTop = -1, ifThenStatckTop = -1, ifStack[100][100];
int whileStmtId = 0, whileTop = -1, whileStack[100];
char *currentClassName = NULL;

#define _BEG_IF             {ifStack[++ifTop][0] = ++ifStmtId;}
#define _END_IF             {ifTop--;}
#define _IF_ID              (ifStack[ifTop][0])
#define _IF_THEN_ID         (ifStack[ifTop][1])
#define _IF_THEN_ID_PLUS    {ifStack[ifTop][1]++;}

#define _BEG_WHILE          {whileStack[++whileTop] = ++whileStmtId;}
#define _END_WHILE          {whileTop--;}
#define _WHILE_ID           (whileStack[whileTop])

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
|   WholeIfStmt                                      
|   WhileStmt                                   
|   BreakStmt StmtSeparator                     
|   ContinueStmt StmtSeparator                  
|   ForStmt                                     
|   ClassDecl                                   
|   ReturnStmt                                  
|   RepeatWileStmt
|   Expr
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

ClassDefBlock:
    '{' ClassDefStmts '}'
|   T_EOL ClassDefBlock
;

ClassDefStmts:
    /* empty */
|   ClassDefStmt
|   ClassDefStmts ClassDefStmt
;

ClassDefStmt:
    NewLines
|   VarDecl StmtSeparator
|   FuncDecl
;

Closure:
    ClosureStart '{' Program '}'                                    { printf("\t闭包结束\n"); }
|   ClosureStart '{' '(' ExprsByComma ')' T_In Program '}'
;

ClosureStart:
    /* empty */             { printf("\t闭包开始\n"); }
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
|   CallFuncName '(' ActualParams ')' Closure           { printf("\t记录闭包参数 -> %s \n",$1);  printf("\t跳转到方法 -> %s\n",$1); }
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
    T_Identifier                                          { printf("\t 在参数集中查找 %s \n",$1); }
|   Arg '=' Expr                                          { printf("\t 尝试 %s = top 到参数集 \n",$1); }
;

FuncDecl:
    T_Func FuncName '(' Args ')' ClosureOrNextLine        { printf("\tENDFUNC\n\n"); }
;

FuncName:
    T_Identifier                                          { if(currentClassName){printf("\tFUNC @%s %s:\n",currentClassName, $1);} else {printf("\tFUNC @%s:\n", $1);}  }
;

ClassDecl:
    T_Class ClassName ClassDefBlock                       { printf("\tENDCLASS\n\n");currentClassName = NULL;}
|   T_Class ClassName ':' SuperClassName ClassDefBlock    { printf("\tENDCLASS\n\n");currentClassName = NULL; }
;

ClassName:
    T_Identifier                        { printf("\tCLASS_BEGIN:%s\n",$1); currentClassName = $1; }
;

SuperClassName:
    T_Identifier                        { printf("\tSuperClass:%s\n",$1); }
;

BreakStmt:
    T_Break                             { printf("\tjmp _endWhile_%d\n", _WHILE_ID); }
;

ContinueStmt:
    T_Continue                          { printf("\tjmp _continuePoint_%d\n", _WHILE_ID); }
;

WhileStmt:
    T_While Expr BeginJzEndWhile WhileBeginTag ClosureOrNextLine EndWhile
;

WhileBeginTag:
    /* empty */      { printf("\t_begWhile_%d:\n", _WHILE_ID); }
;

BeginJzEndWhile:
    /* empty */     { _BEG_WHILE; printf("\tjz _endWhile_%d\n", _WHILE_ID); }
;

EndWhile:
    /* empty */     { printf("\t_continuePoint_%d\n", _WHILE_ID); printf("\tjnz _begWhile_%d\n", _WHILE_ID); printf("\t_endWhile_%d:\n\n", _WHILE_ID); _END_WHILE; }
;

RepeatWileStmt:
    RepeatBegin ClosureOrNextLine T_While Expr EndRepeat
;

EndRepeat:
    /* empty */     { printf("\t_continuePoint_%d\n", _WHILE_ID);printf("\tjnz _begWhile_%d\n", _WHILE_ID); printf("\t_endWhile_%d\n", _WHILE_ID); _END_WHILE}
;

RepeatBegin:
    T_Repeat                        { _BEG_WHILE; printf("\t_begWhile_%d\n", _WHILE_ID); }
;

WholeIfStmt:
    BeginIf IfStmt EndIf
;

IfStmt:
    T_If Expr JzIfThen ClosureOrNextLine JmpEndIf IfThen
|   IfStmt T_Else ClosureOrNextLine
|   IfStmt T_Else IfStmt
;

JmpEndIf:
    /* empty */                                     { printf("\tjmp _endif_%d\n", _IF_ID); }
;

IfThen:
    /* empty */                                     { printf("\t_ifThen_%d_%d\n", _IF_ID, _IF_THEN_ID); _IF_THEN_ID_PLUS;}
;

JzIfThen:
    /* empty */                                     { printf("\tjz _ifThen_%d_%d\n",_IF_ID,_IF_THEN_ID); }
;

BeginIf:
    /* empty */                                      { _BEG_IF; printf("\t_begIf_%d:\n",_IF_ID); }
;

EndIf:
    /* empty */                                     { printf("\t_endIf_%d:\n",_IF_ID); _END_IF; }
;

VarDecl:
    T_Var T_Identifier                              { printf("\tvar %s \n", $2); }
|   T_Let T_Identifier                              { printf("\tlet %s \n", $2); }
|   T_Var T_Identifier '=' Expr                     { printf("\tpop %s \n", $2); }
|   T_Let T_Identifier '=' Expr                     { printf("\tpop %s \n", $2); }
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
    Expr '+' Expr           { printf("\tadd\n");addCmd0(111); }
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
|   T_IntConstant           { printf("\tpush %s\n", $1);addCmd1(FAROperCmdPush,$1); }
|   T_DecimalConstant       { printf("\tpush %s\n", $1);addCmd1(FAROperCmdPush,$1); }
|   T_Identifier            { printf("\tpush %s\n", $1);addCmd1(FAROperCmdPush,$1); }
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

