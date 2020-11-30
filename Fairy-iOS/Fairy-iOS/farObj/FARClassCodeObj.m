//
//  FARClassCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARClassCodeObj.h"
#import "FARClassRunInstance.h"

@implementation FARClassCodeObj

- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    FARClassRunInstance *runIns = [[FARClassRunInstance alloc] initWithEnv:env stack:stack codeObj:self vmCode:vmCode];
    runIns.classCodeObj = self;
    return runIns;
}

@end
