//
//  FARVirtualMachine.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVirtualMachine.h"
#import "FARParser.h"
#import "FARVMEnvironment.h"


static NSString *const kRetPc = @"__retPc";
static NSString *const kRetSp = @"__retSp";

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) FARVMEnvironment *mainEnv;
@property (nonatomic, strong) FARVMEnvironment *currentEnv;
@property (nonatomic, assign) NSInteger pc;
@property (nonatomic, assign) NSInteger sp;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation FARVirtualMachine

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *vmCode = [parser parse:code];
    [vmCode.commandArr addObject:[FARCommand commandWithCmd:FAROperExit]];
    self.vmCode = vmCode;
    [self prepare];
    [self run];
}

- (void)prepare {
    self.mainEnv = [[FARVMEnvironment alloc] init];
    self.stack = [NSMutableArray array];
    self.currentEnv = self.mainEnv;
    self.pc = 0;
    self.sp = 0;
    self.isFinish = NO;
}

- (void)run {
    while (self.isFinish) {
        FARCommand *cmd = self.vmCode.commandArr[self.pc];
        if ([self executeCmd:cmd]) {
            self.pc++;
        }
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
    if ([str integerValue] || [str doubleValue]) {
        return NO;
    }
    return YES;
}

- (BOOL)isZero:(id)value {
    if ([value isEqual:@"0"] || [value isEqual:@(0)]) {
        return YES;
    }
    return NO;
}

- (void)jmp:(NSString *)tag {
    self.pc = self.vmCode.tagDic[tag].codeIndex;
}


//返回是否pc++
- (BOOL)executeCmd:(FARCommand *)cmd {
    switch (cmd.operCmd) {
        case FAROperCmdPush:{
            if ([self isNumber:cmd.oper1]) {
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
            }
            return NO;
        }
        case FAROperCmdJnz:{
            if (![self isZero:[self pop]]) {
                [self jmp:cmd.oper1];
            }
            return NO;
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
            id oper1 = [self pop];
            id oper2 = [self pop];
            [self push:@([oper1 integerValue] + [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdSub:{
            id oper1 = [self pop];
            id oper2 = [self pop];
            [self push:@([oper1 integerValue] - [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdMul:{
            id oper1 = [self pop];
            id oper2 = [self pop];
            [self push:@([oper1 integerValue] * [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdDiv:{
            id oper1 = [self pop];
            id oper2 = [self pop];
            [self push:@([oper1 integerValue] / [oper2 integerValue])];
            return YES;
        }
            
        case FAROperCmdMod:{
            id oper1 = [self pop];
            id oper2 = [self pop];
            [self push:@([oper1 integerValue] % [oper2 integerValue])];
            return YES;
        }
        case FAROperCmdCmpgt:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 > oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmplt:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 < oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpge:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 >= oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmple:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 <= oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpeq:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 == oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdCmpne:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 != oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdOr:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
            if (oper1 || oper2) {
                [self push:@(1)];
            }else {
                [self push:@(0)];
            }
            return YES;
        }
        case FAROperCmdAnd:{
            NSInteger oper1 = [[self pop] integerValue];
            NSInteger oper2 = [[self pop] integerValue];
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
        case FAROperCallFunc:{
            [self.currentEnv setVar:@(self.pc + 1) key:kRetPc];
            [self.currentEnv setVar:@(self.sp) key:kRetSp];
            NSString *funcName = cmd.oper1.length ? [NSString stringWithFormat:@"%@_%@",cmd.oper1,cmd.oper2] : cmd.oper2;
            [self jmp:cmd.oper2];
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
        case FAROperSaveIfNil:{
            NSString *varName = cmd.oper1;
            id obj = [self pop];
            if (![self.currentEnv findVarForKey:varName]) {
                [self.currentEnv setVar:obj key:varName];
            }
            return YES;
        }
        case FAROperSave:{
            [self.currentEnv setVar:[self pop] key:cmd.oper1];
            return YES;
        }
        case FAROperCreateNewEnv:{
            self.currentEnv = [[FARVMEnvironment alloc] initWithOuter:self.currentEnv];
            return YES;
        }
        case FAROperExit:{
            self.isFinish = YES;
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
