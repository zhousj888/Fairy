//
//  FARFuncCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARFuncCodeObj.h"
#import "FARFunRunInstance.h"

@implementation FARFuncCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env {
    return [[FARFunRunInstance alloc] initWithEnv:env];
}

@end
