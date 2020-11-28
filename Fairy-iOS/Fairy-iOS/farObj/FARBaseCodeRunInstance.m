//
//  FARCodeRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseCodeRunInstance.h"
#import "FARVMEnvironment.h"
#import "FARClassCodeObj.h"
#import "FARFuncCodeObj.h"
#import "FARClosureCodeObj.h"
#import "FARStringCodeObj.h"
#import "FARNumberCodeObj.h"
#import "FARFunRunInstance.h"
#import "FARClosureRunInstance.h"

@interface FARBaseCodeRunInstance()

@property (nonatomic, readwrite) NSInteger currentSp;
@property (nonatomic, readwrite) FARVMStack *stack;

@end


@implementation FARBaseCodeRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack {
    if (self = [super initWithEnv:env]) {
        _stack = stack;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    @throw [NSException exceptionWithName:@"需要子类实现" reason:nil userInfo:nil];
}


- (void)resume {
    @throw [NSException exceptionWithName:@"需要子类实现" reason:nil userInfo:nil];
}

- (void)jmpTag:(NSString *)tag {
    @throw [NSException exceptionWithName:@"需要子类实现" reason:nil userInfo:nil];
}

//返回是否pc++
- (BOOL)_executeCmd:(FARCommand *)cmd {
    switch (cmd.operCmd) {
        case FAROperCmdPushInt: {
            FARNumberRunInstance *obj = [FARNumberCodeObj newRunInstanceWithEnv:self.env integer:cmd.oper1.integerValue];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushDouble: {
            FARNumberRunInstance *obj = [FARNumberCodeObj newRunInstanceWithEnv:self.env decimal:cmd.oper1.doubleValue];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushString: {
            //去掉两边的双引号
            NSString *rawStr = [cmd.oper1 substringWithRange:NSMakeRange(1, cmd.oper1.length - 2)];
            
            FARStringRunInstance *obj = [FARStringCodeObj newRunInstanceWithEnv:self.env string:rawStr];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushIdentifier: {
            FARBaseObj *obj = [self propertyWithId:cmd.oper1];
            if (!obj) {
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"找不到对象%@",cmd.oper1] reason:nil userInfo:nil];
            }
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPop:{
            NSString *var = cmd.oper1;
            [self.env setVar:self.stack.pop key:var];
            return YES;
        }
        case FAROperCmdJmp:{
            NSString *tag = cmd.oper1;
            [self jmpTag:tag];
            return NO;
        }
        case FAROperCmdJz:{
            if ([[self.stack pop] isEqualFalse]) {
                [self jmpTag:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdJnz:{
            if (![[self.stack pop] isEqualFalse]) {
                [self jmpTag:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdVar:{
            [self.env declareVar:cmd.oper1];
            return YES;
        }
        case FAROperCmdLet:{
            [self.env declareLet:cmd.oper1];
            return YES;
        }
        case FAROperCmdAdd:{
            FARBaseObj *oper2 = [self.stack pop];
            FARBaseObj *oper1 = [self.stack pop];
            FARFunRunInstance *runInstance = (FARFunRunInstance *)[oper1 propertyWithId:FAR_ADD_FUNC];
            if (!runInstance) {
                @throw [NSException exceptionWithName:@"找不到方法" reason:@"" userInfo:nil];
            }
            [runInstance runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdSub:{
            return YES;
        }
        case FAROperCmdMul:{
            return YES;
        }
        case FAROperCmdDiv:{
            return YES;
        }

        case FAROperCmdMod:{
            return YES;
        }
        case FAROperCmdCmpgt:{
            return YES;
        }
        case FAROperCmdCmplt:{
            return YES;
        }
        case FAROperCmdCmpge:{
            return YES;
        }
        case FAROperCmdCmple:{
            return YES;
        }
        case FAROperCmdCmpeq:{
            return YES;
        }
        case FAROperCmdCmpne:{
            return YES;
        }
        case FAROperCmdOr:{
            return YES;
        }
        case FAROperCmdAnd:{
            return YES;
        }
        case FAROperCmdNeg:{
            return YES;
        }
        case FAROperCmdNot:{
            return YES;
        }
        case FAROperSave:{
            [self.env setVar:[self.stack pop] key:cmd.oper1];
            return YES;
        }
        case FAROperSaveIfNil:{
            NSString *varName = cmd.oper1;
            FARBaseObj *obj = [self.stack pop];
            if (![self.env findVarForKey:varName]) {
                [self.env setVar:obj key:varName];
            }
            return YES;
        }
        case FAROperCreateNewEnv:{
            self.env = [[FARVMEnvironment alloc] initWithOuter:self.env];
            return YES;
        }
        case FAROperCallFunc:{
            FARFunRunInstance *runInstance = (FARFunRunInstance *)[self.stack pop];
            [runInstance runWithParams:self.env.asParams];
            self.env = self.env.outer;
            return NO;
        }
        case FAROperCmdRet:{
            [self.callerInstance resume];
            return NO;
        }
        case FAROperExit:{
            return NO;
        }
        case FAROperFuncFinish:{
            [self.callerInstance resume];
            return NO;
        }
        case FAROperCmdCreateSaveTopClosure:{
            FARClosureRunInstance *closure = (FARClosureRunInstance *)[self.stack pop];
            [self.env setVar:closure key:FAR_TRAILING_CLOSURE];
            return NO;
        }
        case FAROperGetObjProperty:{
            
            return NO;
        }
    }
    return YES;
}






@end
