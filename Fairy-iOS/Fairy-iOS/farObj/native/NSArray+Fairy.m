//
//  NSArray+Fairy.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "NSArray+Fairy.h"

@implementation NSArray (Fairy)

- (FARArrayRunInstance *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    return [[FARArrayRunInstance alloc] initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode array:self];
}

@end
