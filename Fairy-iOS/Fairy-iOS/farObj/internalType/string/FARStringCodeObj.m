//
//  FARStringCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARStringCodeObj.h"

@implementation FARStringCodeObj

+ (FARStringRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode string:(NSString *)str {
    return [[FARStringRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode str:str];
}

@end
