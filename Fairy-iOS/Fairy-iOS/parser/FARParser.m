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

extern int cur_line;
int yyparse (void);
void* yy_scan_string (const char * yystr);

static NSMutableArray<FARCommand *> *commandArr;
static NSMutableDictionary<NSString *, FARCommandTag *> *tagDic;
static NSMutableDictionary<NSNumber *, NSMutableArray<FARCommandTag *>*> *tagIndexDic;
static NSString *currentFileName;


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
        case FAROperCmdPushInt:{return @"pushInt";}
        case FAROperCmdPushDouble:{return @"pushDouble";}
        case FAROperCmdPushIdentifier:{return @"pushID";}
        case FAROperCmdPushString:{return @"pushString";}
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
            
        case FAROperSave:{return @"save";}
        case FAROperSaveIfNil:{return @"saveIfNil";}
        case FAROperCreateNewEnv:{return @"createNewEnv";}
            
        case FAROperCallFunc:{return @"callFunc";}
        case FAROperCmdRet:{return @"ret";}
        case FAROperExit:{return @"exit";}
            
        case FAROperFuncFinish:{return @"funcFinish";}
        case FAROperCmdCreateSaveTopClosure:{return @"createSaveTopClosure";}
        case FAROperGetObjProperty:{return @"getObjProperty";}
        case FAROperCmdSetProperty:{return @"setProperty";}
        case FAROperCmdAssign:{return @"assign";}
        case FAROperCmdPushNewArr:{return @"pushNewArr";}
        case FAROperCmdAddEleToArr:{return @"addEleToArr";}
        case FAROperCmdGetSubscript:{return @"getSubscript";}
        case FAROperCmdSetSubscript:{return @"setSubscript";}
        case FAROperCmdAddEleToDic:{return @"addEleToDic";}
        case FAROperCmdPushNewDic:{return @"pushNewDic";}
        case FAROperCmdPushTrue:{return @"pushTrue";}
        case FAROperCmdPushFalse:{return @"pushFalse";}
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
    FARLog(@"%@",transCmdToDescription(cmd));
    [commandArr addObject:[FARCommand commandWithCmd:cmd line:cur_line fileName:currentFileName]];
}

void addCmd2(int cmd, char *oper1) {
    FARLog(@"%@,%s",transCmdToDescription(cmd),oper1);
    [commandArr addObject:[FARCommand commandWithCmd:cmd oper:transCharsToNSString(oper1) line:cur_line fileName:currentFileName]];
}

void addCmd3(int cmd, char *oper1, char *oper2) {
    FARLog(@"%@,%s,%s",transCmdToDescription(cmd),oper1,oper2);
    [commandArr addObject:[FARCommand commandWithCmd:cmd oper1:transCharsToNSString(oper1) oper2:transCharsToNSString(oper2) line:cur_line fileName:currentFileName]];
}


void addTag(char *format,...) {
    va_list argList;
    va_start(argList, format);
    NSString *tag = [[NSString alloc] initWithFormat:transCharsToNSString(format) arguments:argList];
    FARLog(@"TAG: %@",tag);
    FARCommandTag *tagObj = [FARCommandTag tagWithName:tag codeIndex:commandArr.count];
    tagDic[tag] = tagObj;
    
    if (!tagIndexDic[@(commandArr.count)]) {
        tagIndexDic[@(commandArr.count)] = [NSMutableArray array];
    }
    
    [tagIndexDic[@(commandArr.count)] addObject:tagObj];
    
    
    va_end(argList);
}

@implementation FARParser

- (FARVMCode *)parse:(NSString *)code withFileName:(NSString *)fileName{
    FARLog(@"-------------------👇解析文件->%@-------------------------------",fileName);
    commandArr = [NSMutableArray array];
    tagDic = [NSMutableDictionary dictionary];
    tagIndexDic = [NSMutableDictionary dictionary];
    currentFileName = [fileName copy];
    
    yy_scan_string(code.UTF8String);
    yyparse();
    FARLog(@"-------------------👆%@ 解析完成-------------------------------",fileName);
    
    FARVMCode *vmCode = [[FARVMCode alloc] init];
    vmCode.commandArr = commandArr;
    vmCode.tagDic = tagDic;
    vmCode.tagIndexDic = tagIndexDic;
    commandArr = nil;
    tagDic = nil;
    tagIndexDic = nil;
    currentFileName = nil;
    cur_line = 1;
    return vmCode;
}



@end
