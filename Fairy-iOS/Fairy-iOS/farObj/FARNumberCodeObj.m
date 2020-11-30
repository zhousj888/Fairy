//
//  FARNumberCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberCodeObj.h"

@implementation FARNumberCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode decimal:(double)decimal {
    return [[FARNumberRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode decimal:decimal];
}

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode integer:(NSInteger)number {
    return [[FARNumberRunInstance alloc] initWithEnv:env stack:stack codeObj:[self new] vmCode:vmCode integer:number];
    
}

@end
