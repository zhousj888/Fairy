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
int closureId = 0, closureTop = -1, closureStack[100];
char *currentClassName = NULL;
char *currentFuncName = NULL;
int maxClassFuncLength = 50;

#define _BEG_IF             {ifStack[++ifTop][0] = ++ifStmtId;}
#define _END_IF             {ifTop--;}
#define _IF_ID              (ifStack[ifTop][0])
#define _IF_THEN_ID         (ifStack[ifTop][1])
#define _IF_THEN_ID_PLUS    {ifStack[ifTop][1]++;}

#define _BEG_WHILE          {whileStack[++whileTop] = ++whileStmtId;}
#define _END_WHILE          {whileTop--;}
#define _WHILE_ID           (whileStack[whileTop])

#define _BEG_CLOSURE          {closureStack[++closureTop] = ++closureId;}
#define _END_CLOSURE          {closureTop--;}
#define _CLOSURE_ID           (closureStack[closureTop])




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
|   CallFuncWithClosure
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
|   CallFuncWithClosure
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
    ClosureStart '{' ClosureStmts '}'                                   { addTag("%s%d",TAG_CLOSURE_END,_CLOSURE_ID);_END_CLOSURE; }
|   ClosureStart '{' '(' Args ')' T_In ClosureStmts '}'         { addTag("%s%d",TAG_CLOSURE_END,_CLOSURE_ID);_END_CLOSURE; }
;

ClosureStmts:
    /* empty */
|   ClosureStmt
|   ClosureStmts ClosureStmt
;

ClosureStmt:
    NewLines
|   VarDecl StmtSeparator                       
|   AssignStmt StmtSeparator                                                           
|   WholeIfStmt                                      
|   WhileStmt                                   
|   ForStmt
|   ReturnStmt
|   RepeatWileStmt
|   Expr
|   CallFuncWithClosure
;

ClosureStart:
    /* empty */             { _BEG_CLOSURE; addCmd2(FAROperCmdPushIdentifier, generString("20","%s%d",TAG_CLOSURE_BEGIN,_CLOSURE_ID)); addTag("%s%d",TAG_CLOSURE_BEGIN,_CLOSURE_ID); }
;

ActualParams:
    /* empty */             { /* empty */ }
|   ActualParam
|   ActualParams ',' ActualParam
;

ActualParam:
    T_Identifier ':' Expr                               { addCmd2(FAROperSave,$1); } 
;

CallFuncSuffix:
    CallFuncStart '(' ActualParams ')'
;

CallFuncStart:
    /* empty */                                        { addCmd1(FAROperCreateNewEnv); }
;

ReturnStmt:
    T_Return Expr                                       { addCmd2(FAROperCmdRet,"~"); }
|   T_Return                                            { addCmd1(FAROperCmdRet);}
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
    T_Func FuncName '(' Args ')' IfWhileStmtsBlock        { addCmd1(FAROperFuncFinish); addTag("%s%s",TAG_FUNC_END,currentFuncName);currentFuncName = NULL; }
;

FuncName:
    T_Identifier                                          { if(currentClassName){currentFuncName = generString(maxClassFuncLength,"%s_%s",currentClassName,$1);} else {currentFuncName = $1;} addTag("%s%s",TAG_FUNC_START, currentFuncName); }
;

ClassDecl:
    T_Class ClassID ClassDefBlock                       { addTag("%s%s",TAG_CLASS_END,currentClassName);currentClassName = NULL;}
|   T_Class ClassID ClassDefBlock    { addTag("%s%s",TAG_CLASS_END,currentClassName);currentClassName = NULL; }
;

ClassID:
    T_Identifier                        { addTag("%s%s",TAG_CLASS_BEGIN,$1); currentClassName = $1; }
|   T_Identifier ':' T_Identifier       { currentClassName = generString(maxClassFuncLength,"%s:%s",$1,$3);addTag("%s%s",TAG_CLASS_BEGIN,currentClassName);}
;

BreakStmt:
    T_Break                             { addCmd2(FAROperCmdJmp,generString(15,"%s%d",TAG_WHILE_END, _WHILE_ID)); }
;

ContinueStmt:
    T_Continue                          { addCmd2(FAROperCmdJmp,generString(18,"%s%d",TAG_CONTINUE, _WHILE_ID)); }
;

WhileStmt:
    T_While WhileBeginTag ContinueTag Expr BeginJzEndWhile IfWhileStmtsBlock EndWhile
;

WhileBeginTag:
    /* empty */      { _BEG_WHILE;addTag("%s%d",TAG_WHILE_BEGIN, _WHILE_ID);}
;

BeginJzEndWhile:
    /* empty */     { addCmd2(FAROperCmdJz, generString(13,"%s%d",TAG_WHILE_END,_WHILE_ID)); }
;

EndWhile:
    /* empty */     {  addCmd2(FAROperCmdJmp,generString(20,"%s%d",TAG_WHILE_BEGIN, _WHILE_ID)); addTag("%s%d",TAG_WHILE_END, _WHILE_ID); _END_WHILE; }
;

RepeatWileStmt:
    RepeatBegin IfWhileStmtsBlock T_While ContinueTag Expr EndRepeat
;

ContinueTag:
    /* empty */      { addTag("%s%d",TAG_CONTINUE, _WHILE_ID);  }
;

EndRepeat:
    /* empty */     { addCmd2(FAROperCmdJnz,generString(18,"%s%d",TAG_WHILE_BEGIN, _WHILE_ID)); addTag("%s%d",TAG_WHILE_END, _WHILE_ID); _END_WHILE}
;

RepeatBegin:
    T_Repeat                        { _BEG_WHILE; addTag("%s%d",TAG_WHILE_BEGIN, _WHILE_ID); }
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
    /* empty */                                     { char *text = generString(11,"%s%d",TAG_IF_END,_IF_ID);addCmd2(FAROperCmdJmp,text); }
;

IfThen:
    /* empty */                                     { addTag("%s%d_%d",TAG_IF_THEN, _IF_ID, _IF_THEN_ID);  _IF_THEN_ID_PLUS;}
;

JzIfThen:
    /* empty */                                     { addCmd2(FAROperCmdJz,generString(15,"%s%d_%d",TAG_IF_THEN,_IF_ID,_IF_THEN_ID)); }
;

BeginIf:
    /* empty */                                      { _BEG_IF; addTag("%s%d",TAG_IF_BEGIN,_IF_ID);}
;

EndIf:
    /* empty */                                     { addTag("%s%d",TAG_IF_END,_IF_ID);  _END_IF; }
;

VarDecl:
    T_Var T_Identifier                              { addCmd2(FAROperCmdVar, $2); }
|   T_Let T_Identifier                              { addCmd2(FAROperCmdLet, $2); }
|   T_Var T_Identifier '=' Expr                     { addCmd2(FAROperCmdPop, $2); }
|   T_Let T_Identifier '=' Expr                     { addCmd2(FAROperCmdPop, $2); }
;

AssignStmt:
    T_AssignStmtBegin '=' Expr                      { addCmd2(FAROperCmdSetProperty, $1); }
|   Primary '.' T_Identifier '=' Expr               { addCmd2(FAROperCmdSetProperty, $3); }
;

T_AssignStmtBegin:
    T_Identifier                                    { addCmd2(FAROperCmdPushIdentifier,"self"); }
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
;

Primary:
    '(' Expr ')'
|   T_IntConstant           { addCmd2(FAROperCmdPushInt,$1); }
|   T_DecimalConstant       { addCmd2(FAROperCmdPushDouble,$1); }
|   T_Identifier            { addCmd2(FAROperCmdPushIdentifier,$1); }
|   IntervalExpr
|   T_StringConstant        { addCmd2(FAROperCmdPushString,$1); }
|   ArrayExpr               
|   DictionExpr
|   Primary CallFuncSuffix  { addCmd1(FAROperCallFunc); }
|   Primary ObjSuffix       {  }
;

ObjSuffix:
    '.' T_Identifier        { addCmd2(FAROperGetObjProperty,$2); }
;


CallFuncWithClosure:
    Primary CallFuncSuffix Closure  { addCmd1(FAROperCmdCreateSaveTopClosure); addCmd1(FAROperCallFunc); }
;

%%

