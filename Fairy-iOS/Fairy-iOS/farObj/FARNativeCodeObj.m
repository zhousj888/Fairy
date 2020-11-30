//
//  FARNativeCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/29.
//

#import "FARNativeCodeObj.h"
#import "FARNativeRunInstance.h"

@implementation FARNativeCodeObj

- (FARNativeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    FARNativeRunInstance *runInstance = [[FARNativeRunInstance alloc] initWithEnv:env stack:stack codeObj:self vmCode:vmCode];
    return runInstance;
}

@end
