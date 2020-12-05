//
//  FARNullFuncInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARNullFuncInstance.h"
#import "FARNumberRunInstance.h"
#import "FARNumberCodeObj.h"

@interface FARNullFuncInstance()

@property (nonatomic, strong) NSString *funcName;

@end

@implementation FARNullFuncInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env]) {
        self.stack = stack;
        self.funcName = funcName;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARBaseObj *otherObj = params[FAR_OPER_1];
    if ([self.funcName isEqualToString:FAR_CMPOR_FUNC]) {
        [self.stack push:otherObj];
    }else if ([self.funcName isEqualToString:FAR_AND_FUNC]){
        [self.stack pushNullWithEnv:self.globalEnv];
    }else if ([self.funcName isEqualToString:FAR_NOT_FUNC]){
        FARNumberRunInstance *one = [FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode integer:1];
        [self.stack push:one];
    }
    return nil;
}

@end
