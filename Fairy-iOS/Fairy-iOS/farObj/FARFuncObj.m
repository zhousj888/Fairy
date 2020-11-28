//
//  FARFuncObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARFuncObj.h"
#import "FARFunRunInstance.h"

@implementation FARFuncObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env {
    return [[FARFunRunInstance alloc] initWithEnv:env];
}

@end
