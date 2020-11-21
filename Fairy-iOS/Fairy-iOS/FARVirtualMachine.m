//
//  FARVirtualMachine.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVirtualMachine.h"
#import "FARParser.h"
#import "FARVMEnvironment.h"
#import "FARVMCodeEnv.h"


static NSString *const kRetPc = @"__retPc";
static NSString *const kRetSp = @"__retSp";

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) FARVMEnvironment *codeEnv;
@property (nonatomic, strong) FARVMEnvironment *mainEnv;
@property (nonatomic, strong) FARVMEnvironment *currentEnv;
@property (nonatomic, assign) NSInteger pc;
@property (nonatomic, assign) NSInteger sp;
@property (nonatomic, assign) BOOL isExit;

@end

@implementation FARVirtualMachine

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *vmCode = [parser parse:code];
    [vmCode.commandArr addObject:[FARCommand commandWithCmd:FAROperExit]];
    vmCode.tagDic[@"__log"] = [FARCommandTag tagWithName:@"__log" codeIndex:-110];
    
    
    self.vmCode = vmCode;
    [self prepare];
    [self run];
}

- (void)prepare {
    self.codeEnv = [[FARVMCodeEnv alloc] initWithVMCode:self.vmCode];
    self.mainEnv = [[FARVMEnvironment alloc] initWithOuter:self.codeEnv];
    self.stack = [NSMutableArray array];
    self.currentEnv = self.mainEnv;
    self.pc = 0;
    self.sp = 0;
    self.isExit = NO;
}

- (void)run {
    while (!self.isExit) {
        FARCommand *cmd = self.vmCode.commandArr[self.pc];
        NSLog(@"pc = %@",@(self.pc));
        NSLog(@"excute cmd: %@",cmd);
        if ([self executeCmd:cmd]) {
            self.pc++;
        }
        [self printStack];
    }
}

- (id)pop {
    id lastObj = self.stack.lastObject;
    [self.stack removeLastObject];
    return lastObj;
}

- (void)push:(id)value {
    if (value) {
        [self.stack addObject:value];
    }
}

- (BOOL)isNumber:(NSString *)str {
    if ([str integerValue] || [str doubleValue] || [str isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isStringConst:(NSString *)str {
    if ([str hasPrefix:@"\""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isZero:(id)value {
    if ([value isEqual:@"0"] || [value isEqual:@(0)]) {
        return YES;
    }
    return NO;
}

- (void)jmp:(NSString *)tag {
    NSInteger index = [[self.currentEnv findVarForKey:tag] integerValue];
    [self jmpToIndex:index];
}

- (void)jmpToIndex:(NSInteger)index {
    if (index >= 0) {
        self.pc = index;
    }else if(index == -110){
        NSLog(@"__log: ------------------------>%@",[self.currentEnv findVarForKey:@"text"]);
        self.pc++;
    }else {
        self.isExit = YES;
        NSLog(@"jmp to %@ failed",@(index));
    }
}

- (void)printStack {
    NSMutableString *mutStr = [NSMutableString string];
    for(id stackEle in self.stack) {
        [mutStr appendFormat:@"%@,",stackEle];
    }
    NSLog(@"%@",mutStr);
}




//返回是否pc++
- (BOOL)executeCmd:(FARCommand *)cmd {
    switch (cmd.operCmd) {
        case FAROperCmdPush:{
            if ([self isNumber:cmd.oper1] || [self isStringConst:cmd.oper1]) {
                [self push:cmd.oper1];
            }else {
                [self push:[self.currentEnv findVarForKey:cmd.oper1]];
            }
            return YES;
        }
        case FAROperCmdPop:{
            NSString *var = cmd.oper1;
            [self.currentEnv setVar:[self pop] key:var];
            return YES;
        }
        case FAROperCmdJmp:{
            NSString *tag = cmd.oper1;
            NSInteger tagIndex = self.vmCode.tagDic[tag].codeIndex;
            self.pc = tagIndex;
            return NO;
        }
        case FAROperCmdJz:{
            if ([self isZero:[self pop]]) {
                [self jmp:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdJnz:{
            if (![self isZero:[self pop]]) {
                [self jmp:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdVar:{
            [self.currentEnv declareVar:cmd.oper1];
            return YES;
        }
        case FAROperCmdLet:{
            [self.currentEnv declareLet:cmd.oper1];
            return YES;
        }
        case FAROperCmdAdd:{
            id oper2 = [self pop];
            id oper1 = [self pop];
            [self push:@([oper1 integerValue] + [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdSub:{
            id oper2 = [self pop];
            id oper1 = [self pop];
            [self push:@([oper1 integerValue] - [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdMul:{
            id oper2 = [self pop];
            id oper1 = [self pop];
            [self push:@([oper1 integerValue] * [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdDiv:{
            id oper2 = [self pop];
            id oper1 = [self pop];
            [self push:@([oper1 integerValue] / [oper2 integerValue])];
            return YES;
        }
            
        case FAROperCmdMod:{
            id oper2 = [self pop];
            id oper1 = [self pop];
            [self push:@([oper1 integerValue] % [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdCmpgt:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 > oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmplt:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 < oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpge:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 >= oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmple:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 <= oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpeq:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 == oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpne:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 != oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdOr:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 || oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdAnd:{
            NSInteger oper2 = [[self pop] integerValue];
            NSInteger oper1 = [[self pop] integerValue];
            if (oper1 && oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdNeg:{
            NSInteger oper1 = [[self pop] integerValue];
            [self push:@(-oper1)];
            return YES;
        }
        case FAROperCmdNot:{
            NSInteger oper1 = [[self pop] integerValue];
            [self push:@(!oper1)];
            return YES;
        }
        case FAROperSave:{
            [self.currentEnv setVar:[self pop] key:cmd.oper1];
            return YES;
        }
        case FAROperSaveIfNil:{
            NSString *varName = cmd.oper1;
            id obj = [self pop];
            if (![self.currentEnv findVarForKey:varName]) {
                [self.currentEnv setVar:obj key:varName];
            }
            return YES;
        }
        case FAROperCreateNewEnv:{
            self.currentEnv = [[FARVMEnvironment alloc] initWithOuter:self.currentEnv];
            return YES;
        }
        case FAROperCallFunc:{
            [self.currentEnv setVar:@(self.pc + 1) key:kRetPc];
            [self.currentEnv setVar:@(self.sp) key:kRetSp];
            NSInteger funcCodeIndex = [[self pop] integerValue];
            [self jmpToIndex:funcCodeIndex];
            return NO;
        }
        case FAROperCmdRet:{
            id lastObj = [self pop];
            self.pc = [[self.currentEnv findVarForKey:kRetPc] integerValue];
            self.sp = [[self.currentEnv findVarForKey:kRetSp] integerValue];
            [self push:lastObj];
            self.currentEnv = self.currentEnv.outer;
            return NO;
        }
        case FAROperExit:{
            NSLog(@"exit");
            self.isExit = YES;
            return NO;
        }
        case FAROperFuncFinish:{
            
            return NO;
        }
        case FAROperCmdCreateSaveTopClosure:{
            
            return NO;
        }
        case FAROperGetObjProperty:{
            
            return NO;
        }
    }
    return YES;
}

- (NSInteger)sp {
    return self.stack.count;
}

- (void)setSp:(NSInteger)sp {
    while (sp < self.stack.count) {
        [self.stack removeLastObject];
    }
}


@end
