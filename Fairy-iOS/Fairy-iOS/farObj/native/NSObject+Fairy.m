//
//  UIView+Fairy.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "NSObject+Fairy.h"
#import "FARNativeWrapperInstance.h"

@implementation NSObject (Fairy)

- (FARBaseObj *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    return [[FARNativeWrapperInstance alloc] initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode nativeObj:self];
}

@end
