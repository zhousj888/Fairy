//
//  FARNull.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import "FARNull.h"
#import "FARVMEnvironment.h"

@implementation FARNull

+ (instancetype)null {
    return [[FARNull alloc] initWithEnv:[[FARVMEnvironment alloc] init]];
}

@end
