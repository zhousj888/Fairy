//
//  FARFuncCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARFuncCodeObj.h"
#import "FARFuncRunInstance.h"

@implementation FARFuncCodeObj

- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    return [[FARFuncRunInstance alloc] initWithEnv:env stack:stack codeObj:self vmCode:vmCode];
}

@end
