//
//  FARNumberCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberCodeObj.h"

@implementation FARNumberCodeObj

+ (FARNumberRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env integer:(NSInteger)number {
    FARNumberRunInstance *runIns = [[FARNumberRunInstance alloc] initWithEnv:env];
    runIns.number = @(number);
    return runIns;
}

@end
