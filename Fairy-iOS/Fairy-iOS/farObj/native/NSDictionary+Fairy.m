//
//  NSDictionary+Fairy.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import "NSDictionary+Fairy.h"

@implementation NSDictionary (Fairy)

- (FARDicRunInstance *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(id)stack codeObj:(id)codeObj vmCode:(id)vmCode {
    return [[FARDicRunInstance alloc] initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode dic:self];
}

@end
