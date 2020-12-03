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
#import "FARFuncRunInstance.h"
#import "FARClosureRunInstance.h"
#import "FARCodeObj.h"
#import "FARNull.h"

@interface FARBaseCodeRunInstance()

@property (nonatomic, assign) NSInteger pc;//指向codeObj.codeIndexArr.index
@property (nonatomic, assign) BOOL isRet;
@property (nonatomic, assign) NSInteger currentExcuteLine;

@end


@implementation FARBaseCodeRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode{
    if (self = [super initWithEnv:env]) {
        _stack = stack;
        _codeObj = codeObj;
        _vmCode = vmCode;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    NSLog(@"runWithParams: code = %@, params = %@",self.codeObj.name ,params);
    NSLog(@"current env = %@", self);
    
    if (params) {
        [self.env addParams:params];
    }
    
    self.pc = 0;
    
    
    NSNumber *codeIndex = nil;
    FARCommand *cmd = nil;
    while (self.pc < self.codeObj.codeIndexArr.count && !self.isRet) {
        codeIndex = self.codeObj.codeIndexArr[self.pc];
        cmd = self.vmCode.commandArr[codeIndex.integerValue];
        
        //打印执行的命令
        NSLog(@"cmd %@:---> %@", @(cmd.line),cmd);
//        NSLog(@"currentObj: %@",self);
        
        if ([self _executeCmd:cmd]) {
            self.pc++;
        }
        //打印堆栈
        [self.stack printStack];
        NSLog(@"\n");
    }
    
    NSLog(@"runWithParams: code = %@ finish",self.codeObj.name);
    
    return nil;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARBaseObj *baseObj = [super propertyWithId:name];
    if ([baseObj isKindOfClass:[FARCodeObj class]]) {
        baseObj = [((FARCodeObj *)baseObj) newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode];
    }
    
    if (baseObj) {
        return baseObj;
    }
    //自己的环境找不到从捕获的环境宿主找
    return [self.capturedEnvInstance propertyWithId:name];
}



- (void)jmpTag:(NSString *)tag {
    
    FARCommandTag *tagObj = self.vmCode.tagDic[tag];
    
    for (int i = 0; i < self.codeObj.codeIndexArr.count; i++) {
        NSNumber *codeIndex = self.codeObj.codeIndexArr[i];
        if (codeIndex.integerValue == tagObj.codeIndex) {
            self.pc = i;
            return;
        }
    }
    
    @throw [NSException exceptionWithName:@"跳转tag失败" reason:nil userInfo:nil];
    
}

- (NSInteger)currentSp {
    return self.stack.currentSp;
}

- (void)setCurrentExcuteLine:(NSInteger)currentExcuteLine {
    if (_currentExcuteLine != currentExcuteLine) {
        _currentExcuteLine = currentExcuteLine;
    }
}

//返回是否pc++
- (BOOL)_executeCmd:(FARCommand *)cmd {
    self.currentExcuteLine = cmd.line;
    switch (cmd.operCmd) {
        case FAROperCmdPushInt: {
            FARNumberRunInstance *obj = (FARNumberRunInstance *)[FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode integer:cmd.oper1.integerValue];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushDouble: {
            FARNumberRunInstance *obj = (FARNumberRunInstance *)[FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode decimal:cmd.oper1.doubleValue];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushString: {
            //去掉两边的双引号
            NSString *rawStr = [cmd.oper1 substringWithRange:NSMakeRange(1, cmd.oper1.length - 2)];
            
            FARStringRunInstance *obj = [FARStringCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode string:rawStr];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushIdentifier: {
            FARBaseObj *obj = [self propertyWithId:cmd.oper1];
            if (!obj) {
                if ([cmd.oper1 isEqualToString:FAR_NIL]) {
                    obj = [FARNull null];
                }else {
                    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"找不到对象%@",cmd.oper1] reason:nil userInfo:nil];
                }
            }
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPop:{
            NSString *var = cmd.oper1;
            [self declareVar:var];
            [self setPropertyWithKey:var value:self.stack.pop];
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
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_ADD_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdSub:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_SUB_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdMul:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_MUL_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdDiv:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_DIV_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }

        case FAROperCmdMod:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_MOD_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmpgt:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPGT_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmplt:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPLT_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmpge:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPGE_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmple:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPLE_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmpeq:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPEQ_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdCmpne:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPNE_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdOr:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_CMPOR_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdAnd:{
            FARNumberRunInstance *oper2 = (FARNumberRunInstance *)[self.stack pop];
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_AND_FUNC];
            [obj runWithParams:@{FAR_OPER_1: oper2}];
            return YES;
        }
        case FAROperCmdNeg:{
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_NEG_FUNC];
            [obj runWithParams:nil];
            return YES;
        }
        case FAROperCmdNot:{
            FARNumberRunInstance *oper1 = (FARNumberRunInstance *)[self.stack pop];
            
            FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:FAR_NOT_FUNC];
            [obj runWithParams:nil];
            return YES;
        }
        case FAROperSave:{
            [self.env setVar:[self.stack pop] key:cmd.oper1];
            return YES;
        }
        case FAROperSaveIfNil:{
            NSString *varName = cmd.oper1;
            FARBaseObj *obj = [self.stack pop];
            if (![self propertyWithId:varName]) {
                [self setPropertyWithKey:varName value:obj];
            }
            return YES;
        }
        case FAROperCreateNewEnv:{
            self.env = [[FARVMEnvironment alloc] initWithOuter:self.env];
            return YES;
        }
        case FAROperCallFunc:{
            FARFuncRunInstance *runInstance = (FARFuncRunInstance *)[self.stack pop];
            [runInstance runWithParams:self.env.asParams];
            self.env = self.env.outer;
            return YES;
        }
        case FAROperCmdRet:{
            self.isRet = YES;
            return NO;
        }
        case FAROperExit:{
            self.isRet = YES;
            return NO;
        }
        case FAROperFuncFinish:{
            self.isRet = YES;
            return NO;
        }
        case FAROperCmdCreateSaveTopClosure:{
            FARClosureRunInstance *closure = (FARClosureRunInstance *)[self.stack pop];
            [self.env setVar:closure key:FAR_TRAILING_CLOSURE];
            return YES;
        }
        case FAROperGetObjProperty:{
            FARBaseObj *obj = [self.stack pop];
            FARBaseObj *property = [obj propertyWithId:cmd.oper1];
            if (property) {
                [self.stack push:property];
            }else {
                @throw [NSException exceptionWithName:@"getProperty失败，找不到对象" reason:nil userInfo:nil];
            }
            return YES;
        }
        case FAROperCmdSetProperty: {
            FARBaseObj *value = [self.stack pop];
            FARBaseObj *operObj = [self.stack pop];
            [operObj setPropertyWithKey:cmd.oper1 value:value];
            return YES;
        }
        case FAROperCmdAssign: {
            FARBaseObj *value = [self.stack pop];
            NSString *varName = cmd.oper1;
            [self setPropertyWithKey:varName value:value];
            return YES;
        }
    }
    return YES;
}




@end
