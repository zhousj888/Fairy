//
//  FARArrayCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARArrayCodeObj.h"
#import "FARArrayRunInstance.h"

@implementation FARArrayCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode {
    return  [[FARArrayRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode];
}

@end
