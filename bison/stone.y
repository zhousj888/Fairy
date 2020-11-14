
%token T_Int T_Var T_Void T_Return T_ReadInt T_While T_Repeat T_EOL T_Let T_Func T_For T_In T_Class
%token T_If T_Else T_Break T_Continue T_Le T_Ge T_Eq T_Ne 
%token T_And T_Or T_IntConstant T_StringConstant T_Identifier T_IntervalTo T_IntervalLess T_DecimalConstant

%%

program:
    [ defclass | def | statement] (";" | EOL)
;

block:
    '{' [statement] { (";" | EOL) [ statement ] } '}'
;

statement: 
    'if' expr block [ "else" block ]
|   'while' expr block
|   simple
;


expr:
    factor {OP factor}
;

factor:
    '-' primary | primary
;

primary:
    ('(' expr ')' | NUMBER | IDENTIFIER | STRING){ postfix }
;

simple: expr [ args ];



member:
    def | simple
;

class_body:
    "{" [member] { ";" | EOL  [member] } "}"
;

defclass:
    'class' IDENTIFIER [ "extends" IDENTIFIER ] class_body
;

param:
    IDENTIFIER
;

params:
    param {"," param}
;

param_list:
    "(" [params] ")"
;

def:
    "def" IDENTIFIER param_list block
;

args:
    expr {"," expr}
;

postfix:
    "." IDENTIFIER | "(" [ args ] ")"
;
%%