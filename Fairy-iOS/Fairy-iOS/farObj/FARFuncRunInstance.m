//
//  FARFunRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARFuncRunInstance.h"

@implementation FARFuncRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    FARFuncRunInstance *runIns = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode];
    return runIns;
}

@end
