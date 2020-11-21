%{
#include <stdio.h>
#include <stdlib.h>
#include "FAROperCmd.h"

void yyerror(const char*);
int yylex(void);
void addCmd1(int cmd);
void addCmd2(int cmd, char *oper1);
void addCmd3(int cmd, char *oper1, char *oper2);
void addTag(char *format,...);
char *generString(int stringLength,char *fmt,...);

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


IfWhileStmtsBlock:
    IfWhileBlockStart '{' IfWhileStmts '}'          { printf("\tBlock结束\n"); }
|   T_EOL IfWhileStmtsBlock
;

IfWhileBlockStart:
    /* empty */           { printf("\tBlock开始\n"); }
;

IfWhileStmts:
    /* empty */
|   IfWhileStmt
|   IfWhileStmts IfWhileStmt
;

IfWhileStmt:
    NewLines
|   VarDecl StmtSeparator                       
|   AssignStmt StmtSeparator                                                           
|   WholeIfStmt                                      
|   WhileStmt                                   
|   BreakStmt StmtSeparator                     
|   ContinueStmt StmtSeparator                  
|   ForStmt                                     
|   ReturnStmt                                  
|   RepeatWileStmt
|   Expr
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

ActualParams:
    /* empty */             { /* empty */ }
|   ActualParam
|   ActualParams ',' ActualParam
;

ActualParam:
    T_Identifier ':' Expr                               { addCmd2(FAROperSave,$1); } 
;

CallExpr:
    CallFuncName '(' ActualParams ')'                   { addCmd3(FAROperCallFunc, currentClassName, $1); }
|   CallFuncName '(' ActualParams ')' Closure           { printf("\t记录闭包参数 -> %s \n",$1);addCmd3(FAROperCmdJmp, currentClassName, $1); }
;

CallFuncName:
    T_Identifier                                        { addCmd2(FAROperCreateNewEnv,$1); }
;

ObjCallExpr:
    Expr '.' CallExpr
;

ReturnStmt:
    T_Return Expr                                       { printf("\tret ~\n\n");addCmd2(FAROperCmdRet,"~"); }
|   T_Return                                            { printf("\tret\n\n");addCmd1(FAROperCmdRet);}
;

ForStmt:
    T_For Expr T_In Expr IfWhileStmtsBlock
;


Args:
    /* empty */             { /* empty */ }
|   Arg
|   Args ',' Arg 
;

Arg:
    T_Identifier
|   Arg '=' Expr                                          { addCmd2(FAROperSaveIfNil,$1); }
;

FuncDecl:
    T_Func FuncName '(' Args ')' IfWhileStmtsBlock        { addTag("FUNC_END"); }
;

FuncName:
    T_Identifier                                          { if(currentClassName){addTag("FUNC:%s_%s",currentClassName,$1);} else {addTag("FUNC:%s",$1);}  }
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
    T_Break                             { addCmd2(FAROperCmdJmp,generString(15,"_endWhile_%d", _WHILE_ID)); }
;

ContinueStmt:
    T_Continue                          { addCmd2(FAROperCmdJmp,generString(18,"_continuePoint_%d", _WHILE_ID)); }
;

WhileStmt:
    T_While Expr BeginJzEndWhile WhileBeginTag IfWhileStmtsBlock EndWhile
;

WhileBeginTag:
    /* empty */      { addTag("_begWhile_%d", _WHILE_ID);  }
;

BeginJzEndWhile:
    /* empty */     { _BEG_WHILE; addCmd2(FAROperCmdJz, generString(13,"_endWhile_%d",_WHILE_ID)); }
;

EndWhile:
    /* empty */     { addTag("_continuePoint_%d", _WHILE_ID); printf("\tjnz _begWhile_%d\n", _WHILE_ID);addCmd2(FAROperCmdJnz,generString(18,"_begWhile_%d", _WHILE_ID)); addTag("\t_endWhile_%d:\n\n", _WHILE_ID); _END_WHILE; }
;

RepeatWileStmt:
    RepeatBegin IfWhileStmtsBlock T_While Expr EndRepeat
;

EndRepeat:
    /* empty */     { addTag("_continuePoint_%d", _WHILE_ID);addCmd2(FAROperCmdJnz,generString(18,"_begWhile_%d", _WHILE_ID)); addTag("_endWhile_%d", _WHILE_ID); _END_WHILE}
;

RepeatBegin:
    T_Repeat                        { _BEG_WHILE; addTag("_begWhile_%d", _WHILE_ID); }
;

WholeIfStmt:
    BeginIf IfStmt EndIf
;

IfStmt:
    T_If Expr JzIfThen IfWhileStmtsBlock JmpEndIf IfThen
|   IfStmt T_Else IfWhileStmtsBlock
|   IfStmt T_Else IfStmt
;

JmpEndIf:
    /* empty */                                     { char *text = generString(11,"_endIf_%d",_IF_ID);addCmd2(FAROperCmdJmp,text); }
;

IfThen:
    /* empty */                                     { addTag("_ifThen_%d_%d", _IF_ID, _IF_THEN_ID);  _IF_THEN_ID_PLUS;}
;

JzIfThen:
    /* empty */                                     { addCmd2(FAROperCmdJz,generString(15,"_ifThen_%d_%d",_IF_ID,_IF_THEN_ID)); }
;

BeginIf:
    /* empty */                                      { _BEG_IF; addTag("_begIf_%d",_IF_ID);}
;

EndIf:
    /* empty */                                     { addTag("_endIf_%d",_IF_ID);  _END_IF; }
;

VarDecl:
    T_Var T_Identifier                              { addCmd2(FAROperCmdVar, $2); }
|   T_Let T_Identifier                              { addCmd2(FAROperCmdLet, $2); }
|   T_Var T_Identifier '=' Expr                     { addCmd2(FAROperCmdPop, $2); }
|   T_Let T_Identifier '=' Expr                     { addCmd2(FAROperCmdPop, $2); }
;

AssignStmt:
    T_Identifier '=' Expr                           { addCmd2(FAROperCmdPop, $1); }
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
    Primary
|   Expr '+' Expr           { addCmd1(FAROperCmdAdd); }
|   Expr '-' Expr           { addCmd1(FAROperCmdSub); }
|   Expr '*' Expr           { addCmd1(FAROperCmdMul); }
|   Expr '/' Expr           { addCmd1(FAROperCmdDiv); }
|   Expr '%' Expr           { addCmd1(FAROperCmdMod); }
|   Expr '>' Expr           { addCmd1(FAROperCmdCmpgt); }
|   Expr '<' Expr           { addCmd1(FAROperCmdCmplt); }
|   Expr T_Ge Expr          { addCmd1(FAROperCmdCmpge); }
|   Expr T_Le Expr          { addCmd1(FAROperCmdCmple); }
|   Expr T_Eq Expr          { addCmd1(FAROperCmdCmpeq); }
|   Expr T_Ne Expr          { addCmd1(FAROperCmdCmpne); }
|   Expr T_Or Expr          { addCmd1(FAROperCmdOr); }
|   Expr T_And Expr         { addCmd1(FAROperCmdAnd); }
|   '-' Expr %prec '!'      { addCmd1(FAROperCmdNeg); }
|   '+' Expr %prec '!'      { /* empty */ }
|   '!' Expr                { addCmd1(FAROperCmdNot); }
|   Expr '?' Expr ':' Expr
|   CallExpr 
|   ObjCallExpr
;

Primary:
    '(' Expr ')'
|   T_IntConstant           { addCmd2(FAROperCmdPush,$1); }
|   T_DecimalConstant       { addCmd2(FAROperCmdPush,$1); }
|   T_Identifier            { addCmd2(FAROperCmdPush,$1); }
|   IntervalExpr
|   T_StringConstant        { addCmd2(FAROperCmdPush,$1); }
|   ArrayExpr               
|   DictionExpr
;

%%

