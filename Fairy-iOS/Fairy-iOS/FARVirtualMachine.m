//
//  FARVirtualMachine.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVirtualMachine.h"
#import "FARParser.h"

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableDictionary *mainEnv;
@property (nonatomic, strong) NSMutableDictionary *currentEnv;
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
    self.mainEnv = [NSMutableDictionary dictionary];
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
//返回是否pc++
- (BOOL)executeCmd:(FARCommand *)cmd {
    switch (cmd.operCmd) {
        case FAROperCmdPush:{
            [self.stack addObject:cmd.oper1];
            return YES;
        }
        case FAROperCmdPop:{
            NSString *var = cmd.oper1;
            self.currentEnv[var] = self.stack.lastObject;
            [self.stack removeLastObject];
            return YES;
        }
        case FAROperCmdJmp:{
            NSString *tag = cmd.oper1;
            NSInteger tagIndex = [self findTagIndex:tag];
            self.pc = tagIndex;
            return NO;
        }
        case FAROperCmdJz:{
            return NO;
        }
        case FAROperCmdJnz:{return NO;}
        case FAROperCmdVar:{return YES;}
        case FAROperCmdLet:{return YES;}
        case FAROperCmdAdd:{return YES;}
        case FAROperCmdSub:{return YES;}
        case FAROperCmdMul:{return YES;}
        case FAROperCmdDiv:{return YES;}
        case FAROperCmdMod:{return YES;}
        case FAROperCmdCmpgt:{return YES;}
        case FAROperCmdCmplt:{return YES;}
        case FAROperCmdCmpge:{return YES;}
        case FAROperCmdCmple:{return YES;}
        case FAROperCmdCmpeq:{return YES;}
        case FAROperCmdCmpne:{return YES;}
        case FAROperCmdOr:{return YES;}
        case FAROperCmdAnd:{return YES;}
        case FAROperCmdNeg:{return YES;}
        case FAROperCmdNot:{return YES;}
        case FAROperCmdRet:{return YES;}
        case FAROperSaveIfNil:{return YES;}
        case FAROperSave:{return YES;}
        case FAROperCreateNewEnv:{return YES;}
    }
    return YES;
}

- (NSInteger)findTagIndex:(NSString *)tag {
    if (tag.length) {
        for (FARCommandTag *interTag in self.vmCode.tagArr) {
            if ([interTag.name isEqualToString:tag]) {
                return interTag.codeIndex;
            }
        }
    }
    return 0;
}


@end
