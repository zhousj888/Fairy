//
//  FARFunRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARFuncRunInstance.h"
#import "FARCodeObj.h"
#import "FARVMEnvironment.h"
#import "FARObjectWrapper.h"

@implementation FARFuncRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    FARFuncRunInstance *runIns = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode];
    return runIns;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    NSInteger origSp = self.currentSp;
    [super runWithParams:params];
    if (origSp == self.currentSp) {
        [self.stack pushNullWithEnv:self.globalEnv];
    }else {
        FARBaseObj *ret = [self.stack pop];
        [self.stack popTo:origSp];
        [self.stack push:ret];
    }
    
    return nil;
}

- (void)makeReRunable {
    self.isRet = NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<func: %@>", self.codeObj.name];
}

- (id)toNativeObj {
    FARObjectWrapper *wrapper = [[FARObjectWrapper alloc] initWithFarObj:self];
    return wrapper;
}

@end
