//
//  FARParser.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import "FARParser.h"
#include "y.tab.h"
#include "FAROperCmd.h"

int yyparse (void);
void* yy_scan_string (const char * yystr);

NSString *transCmdToDescription(int cmd) {
    switch (cmd) {
        case FAROperCmdPush:{return @"push";}
        case FAROperCmdPop:{return @"pop";}
        case FAROperCmdJmp:{return @"jmp";}
        case FAROperCmdJz:{return @"jz";}
        case FAROperCmdJnz:{return @"jnz";}
        case FAROperCmdVar:{return @"var";}
        case FAROperCmdLet:{return @"let";}
        case FAROperCmdAdd:{return @"add";}
        case FAROperCmdSub:{return @"sub";}
        case FAROperCmdMul:{return @"mul";}
        case FAROperCmdDiv:{return @"div";}
        case FAROperCmdMod:{return @"mod";}
        case FAROperCmdCmpgt:{return @"cmpgt";}
        case FAROperCmdCmplt:{return @"cmplt";}
        case FAROperCmdCmpge:{return @"cmpge";}
        case FAROperCmdCmple:{return @"cmple";}
        case FAROperCmdCmpeq:{return @"cmpeq";}
        case FAROperCmdCmpne:{return @"cmpne";}
        case FAROperCmdOr:{return @"or";}
        case FAROperCmdAnd:{return @"and";}
        case FAROperCmdNeg:{return @"neg";}
        case FAROperCmdNot:{return @"not";}
        case FAROperCmdRet:{return @"ret";}
    }
    return @"unknow";
}


void addCmd0(int cmd) {
    NSLog(@"%@",transCmdToDescription(cmd));
}

void addCmd1(int cmd, char *oper1) {
    NSLog(@"%@,%s",transCmdToDescription(cmd),oper1);
}

void addCmd2(int cmd, char *oper1, char *oper2) {
    NSLog(@"%@,%s,%s",transCmdToDescription(cmd),oper1,oper2);
}


@implementation FARParser


- (void)parse:(NSString *)code {
    yy_scan_string(code.UTF8String);
    yyparse();
}


@end
