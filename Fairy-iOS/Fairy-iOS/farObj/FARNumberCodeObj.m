//
//  FARNumberCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberCodeObj.h"

@implementation FARNumberCodeObj

+ (FARNumberRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env integer:(NSInteger)number {
    FARNumberRunInstance *runIns = [[FARNumberRunInstance alloc] initWithEnv:env integer:number];
    return runIns;
}

+ (FARNumberRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env decimal:(double)decimal {
    FARNumberRunInstance *runIns = [[FARNumberRunInstance alloc] initWithEnv:env decimal:decimal];
    return runIns;
}

@end
