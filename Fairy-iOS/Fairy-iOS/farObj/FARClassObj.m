//
//  FARClassObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARClassObj.h"
#import "FARClassRunInstance.h"

@implementation FARClassObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env {
    return [[FARClassRunInstance alloc] initWithEnv:env];
}

@end
