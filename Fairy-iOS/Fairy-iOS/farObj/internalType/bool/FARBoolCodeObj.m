//
//  FARBoolCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARBoolCodeObj.h"
#import "FARBoolRunInstance.h"

@implementation FARBoolCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode boolValue:(BOOL)boolValue {
    return [[FARBoolRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode boolValue:boolValue];
}

@end
