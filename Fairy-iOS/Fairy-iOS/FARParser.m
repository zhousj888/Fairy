//
//  FARParser.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import "FARParser.h"
#include "y.tab.h"
#include "FAROperCmd.h"
#import "FARCommand.h"
#import "FARCommandTag.h"

int yyparse (void);
void* yy_scan_string (const char * yystr);

static NSMutableArray<FARCommand *> *commandArr;
static NSMutableArray<FARCommandTag *> *tagArr;


char *generString(int stringLength,char *fmt,...) {
    char *result = (char*)malloc(stringLength * sizeof(char));
    va_list argList;
    va_start(argList, fmt);
    vsprintf(result, fmt, argList);
    va_end(argList);
    return result;
}

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
        case FAROperSaveIfNil:{return @"saveIfNil";}
        case FAROperCreateNewEnv:{return @"createNewEnv";}
        case FAROperSave:{return @"save";}
    }
    return @"unknow";
}

NSString *transCharsToNSString(char *chars) {
    if (chars) {
        return [NSString stringWithUTF8String:chars];
    }
    return @"";
}


void addCmd1(int cmd) {
    NSLog(@"%@",transCmdToDescription(cmd));
    [commandArr addObject:[FARCommand commandWithCmd:cmd]];
}

void addCmd2(int cmd, char *oper1) {
    NSLog(@"%@,%s",transCmdToDescription(cmd),oper1);
    [commandArr addObject:[FARCommand commandWithCmd:cmd oper:transCharsToNSString(oper1)]];
}

void addCmd3(int cmd, char *oper1, char *oper2) {
    NSLog(@"%@,%s,%s",transCmdToDescription(cmd),oper1,oper2);
    [commandArr addObject:[FARCommand commandWithCmd:cmd oper1:transCharsToNSString(oper1) oper2:transCharsToNSString(oper2)]];
}


void addTag(char *format,...) {
    va_list argList;
    va_start(argList, format);
    NSString *tag = [[NSString alloc] initWithFormat:transCharsToNSString(format) arguments:argList];
    NSLog(@"TAG: %@",tag);
    [tagArr addObject:[FARCommandTag tagWithName:tag]];
    va_end(argList);
}

@implementation FARParser

- (FARVMCode *)parse:(NSString *)code {
    commandArr = [NSMutableArray array];
    tagArr = [NSMutableArray array];
    yy_scan_string(code.UTF8String);
    yyparse();
    NSLog(@"cmd sum = %@",@(commandArr.count));
    
    FARVMCode *vmCode = [[FARVMCode alloc] init];
    vmCode.commandArr = commandArr;
    vmCode.tagArr = tagArr;
    commandArr = nil;
    tagArr = nil;
    return vmCode;
}


@end
