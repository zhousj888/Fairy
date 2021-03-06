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
#import "FARBasicFuncRunInstance.h"
#import "FARArrayCodeObj.h"
#import "FARArrayRunInstance.h"
#import "FARArrayFuncRunInstance.h"
#import "FARDicCodeObj.h"
#import "FARDicRunInstance.h"
#import "FARDicFuncRunInstance.h"
#import "FARNativeWrapperInstance.h"
#import "FARBoolCodeObj.h"
#import "FARBoolRunInstance.h"
#import "FARBoolFunRunInstance.h"

@interface FARBaseCodeRunInstance()

@property (nonatomic, assign) NSInteger pc;//指向codeObj.codeIndexArr.index
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

- (void)declareVar:(NSString *)key {
    [self.env declareVar:key withGlobalEnv:self.globalEnv withStack:self.stack];
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    FARLog(@"runWithParams: code = %@, params = %@",self.codeObj.name ,params);
    FARLog(@"current env = %@", self);
    
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
        FARLog(@"cmd<%@,%@>:---> %@",cmd.fileName, @(cmd.line),cmd);
        
        if ([self executeCmd:cmd]) {
            self.pc++;
        }
        //打印堆栈
        [self.stack printStack];
        FARLog(@"\n");
    }
    
    FARLog(@"runWithParams: code = %@ finish",self.codeObj.name);
    
    return nil;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARBaseObj *baseObj = [super propertyWithId:name];
    
    if (!baseObj) {
        //自己的环境找不到从捕获的环境宿主找
        baseObj = [self.capturedEnvInstance propertyWithId:name];
    }
    
    if (!baseObj) {
        //可能是基础方法比如equal
        if ([name isEqualToString:FAR_CMPEQ_FUNC]) {
            FARBasicFuncRunInstance *basicFunc = [[FARBasicFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:nil vmCode:self.vmCode funcName:name];
            basicFunc.capturedEnvInstance = self;
            baseObj = basicFunc;
        }else if ([name isEqualToString:FAR_ASSERT]) {
            FARBasicFuncRunInstance *basicFunc = [[FARBasicFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:nil vmCode:self.vmCode funcName:name];
            basicFunc.capturedEnvInstance = self;
            baseObj = basicFunc;
        }
    }
    
    if ([baseObj isKindOfClass:[FARCodeObj class]]) {
        baseObj = [((FARCodeObj *)baseObj) newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode];
    }
    
    return baseObj;
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    if ([super propertyWithId:key]) {
        [super setPropertyWithKey:key value:value];
    }else if ([self.capturedEnvInstance propertyWithId:key]){
        [self.capturedEnvInstance setPropertyWithKey:key value:value];
    }else {
        @throw [NSException exceptionWithName:@"找不到对象" reason:nil userInfo:nil];
    }
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

- (void)oper2objWithOperation:(NSString *)operName {
    FARBaseObj *oper2 = [self.stack pop];
    FARBaseObj *oper1 = [self.stack pop];
    
    FARBaseCodeRunInstance *obj = (FARBaseCodeRunInstance *)[oper1 propertyWithId:operName];
    if (obj) {
        [obj runWithParams:@{FAR_OPER_1: oper2}];
    }else {
        @throw [NSException exceptionWithName:@"找不到方法" reason:nil userInfo:nil];
    }
        
}

//返回是否pc++
- (BOOL)executeCmd:(FARCommand *)cmd {
    self.currentExcuteLine = cmd.line;
    switch (cmd.operCmd) {
        case FAROperCmdPushTrue:{
            FARBoolRunInstance *obj = (FARBoolRunInstance *)[FARBoolCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode boolValue:YES];
            [self.stack push:obj];
            return YES;
        }
        case FAROperCmdPushFalse: {
            FARBoolRunInstance *obj = (FARBoolRunInstance *)[FARBoolCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode boolValue:NO];
            [self.stack push:obj];
            return YES;
        }
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
                obj = [FARNull nullWithEnv:self.globalEnv stack:self.stack];
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
            if (![[self.stack pop] isEqualTrue]) {
                [self jmpTag:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdJnz:{
            if ([[self.stack pop] isEqualTrue]) {
                [self jmpTag:cmd.oper1];
                return NO;
            }
            return YES;
        }
        case FAROperCmdVar:{
            [self.env declareVar:cmd.oper1 withGlobalEnv:self.globalEnv withStack:self.stack];
            return YES;
        }
        case FAROperCmdLet:{
            [self.env declareVar:cmd.oper1 withGlobalEnv:self.globalEnv withStack:self.stack];
            return YES;
        }
        case FAROperCmdAdd:{
            [self oper2objWithOperation:FAR_ADD_FUNC];
            return YES;
        }
        case FAROperCmdSub:{
            [self oper2objWithOperation:FAR_SUB_FUNC];
            return YES;
        }
        case FAROperCmdMul:{
            [self oper2objWithOperation:FAR_MUL_FUNC];
            return YES;
        }
        case FAROperCmdDiv:{
            [self oper2objWithOperation:FAR_DIV_FUNC];
            return YES;
        }

        case FAROperCmdMod:{
            [self oper2objWithOperation:FAR_MOD_FUNC];
            return YES;
        }
        case FAROperCmdCmpgt:{
            [self oper2objWithOperation:FAR_CMPGT_FUNC];
            return YES;
        }
        case FAROperCmdCmplt:{
            [self oper2objWithOperation:FAR_CMPLT_FUNC];
            return YES;
        }
        case FAROperCmdCmpge:{
            [self oper2objWithOperation:FAR_CMPGE_FUNC];
            return YES;
        }
        case FAROperCmdCmple:{
            [self oper2objWithOperation:FAR_CMPLE_FUNC];
            return YES;
        }
        case FAROperCmdCmpeq:{
            [self oper2objWithOperation:FAR_CMPEQ_FUNC];
            return YES;
        }
        case FAROperCmdCmpne:{
            [self oper2objWithOperation:FAR_CMPNE_FUNC];
            return YES;
        }
        case FAROperCmdOr:{
            [self oper2objWithOperation:FAR_CMPOR_FUNC];
            return YES;
        }
        case FAROperCmdAnd:{
            [self oper2objWithOperation:FAR_AND_FUNC];
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
            [self.env declareVar:cmd.oper1 withGlobalEnv:self.globalEnv withStack:self.stack];
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
            if (![cmd.oper1 isEqualToString:@"~"]) {
                [self.stack push:[FARNull nullWithEnv:self.globalEnv stack:self.stack]];
            }
            self.isRet = YES;
            return NO;
        }
        case FAROperExit:{
            self.isRet = YES;
            return NO;
        }
        case FAROperFuncFinish:{
            [self.stack push:[FARNull nullWithEnv:self.globalEnv stack:self.stack]];
            self.isRet = YES;
            self.isFuncFinished = YES;
            return NO;
        }
        case FAROperCmdCreateSaveTopClosure:{
            FARClosureRunInstance *closure = (FARClosureRunInstance *)[self.stack pop];
            closure.capturedEnvInstance = self;
            [self.env declareVar:FAR_TRAILING_CLOSURE withGlobalEnv:self.globalEnv withStack:self.stack];
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
        case FAROperCmdPushNewArr: {
            FARArrayRunInstance *array = (FARArrayRunInstance *)[FARArrayCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode];
            [self.stack push:array];
            return YES;
        }
        case FAROperCmdAddEleToArr: {
            FARBaseObj *value = [self.stack pop];
            FARArrayRunInstance *array = (FARArrayRunInstance *)[self.stack pop];
            FARArrayFuncRunInstance *func = (FARArrayFuncRunInstance *)[array propertyWithId:FAR_ARRAY_PUSH];
            [func runWithParams:@{FAR_ARRAY_DIC_VALUE: value}];
            [self.stack push:array];
            return YES;
        }
        case FAROperCmdGetSubscript: {
            FARBaseObj *index = [self.stack pop];
            FARBaseObj *arrayOrDic = (FARArrayRunInstance *)[self.stack pop];
            FARFuncRunInstance *func = (FARFuncRunInstance *)[arrayOrDic propertyWithId:FAR_ARRAY_DIC_GET];
            [func runWithParams:@{FAR_ARRAY_INDEX: index, FAR_DIC_KEY: index}];
            return YES;
        }
        case FAROperCmdSetSubscript: {
            FARBaseObj *value = [self.stack pop];
            FARBaseObj *index = [self.stack pop];
            FARBaseObj *arrayOrDic = [self.stack pop];
            FARFuncRunInstance *func = (FARFuncRunInstance *)[arrayOrDic propertyWithId:FAR_ARRAY_DIC_SET];
            
            [func runWithParams:@{FAR_ARRAY_INDEX: index, FAR_ARRAY_DIC_VALUE: value, FAR_DIC_KEY: index}];
            
            return YES;
        }
        case FAROperCmdAddEleToDic: {
            FARBaseObj *value = [self.stack pop];
            FARBaseObj *key = [self.stack pop];
            FARDicRunInstance *dic = (FARDicRunInstance *)[self.stack pop];
            FARDicFuncRunInstance *func = (FARDicFuncRunInstance *)[dic propertyWithId:FAR_ARRAY_DIC_SET];
            [func runWithParams:@{FAR_DIC_KEY: key, FAR_ARRAY_DIC_VALUE: value}];
            [self.stack push:dic];
            return YES;
        }
        case FAROperCmdPushNewDic: {
            FARBaseObj *dic = [FARDicCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode];
            [self.stack push:dic];
            return YES;
        }
    }
    return YES;
}

@end
