//
//  FARClosureCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARClosureCodeObj.h"
#import "FARClosureRunInstance.h"

@implementation FARClosureCodeObj

- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    return [[FARClosureRunInstance alloc] initWithEnv:env stack:stack codeObj:self vmCode:vmCode];
}

@end
