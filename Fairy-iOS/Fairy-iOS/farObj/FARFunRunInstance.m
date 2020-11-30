//
//  FARFunRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARFunRunInstance.h"

@implementation FARFunRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    FARFunRunInstance *runIns = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode];
    return runIns;
}

@end
