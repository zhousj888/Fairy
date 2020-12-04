//
//  FARDicCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARDicCodeObj.h"
#import "FARDicRunInstance.h"

@implementation FARDicCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    return  [[FARDicRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode];
}

@end
