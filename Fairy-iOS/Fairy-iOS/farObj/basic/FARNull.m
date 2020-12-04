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
    
    static FARNull *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[FARNull alloc] initWithEnv:[[FARVMEnvironment alloc] init]];
    });
    return instance;
    
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    @throw [NSException exceptionWithName:@"不能对null取变量" reason:nil userInfo:nil];
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    @throw [NSException exceptionWithName:@"不能对null调用方法" reason:nil userInfo:nil];
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    @throw [NSException exceptionWithName:@"不能对null设置变量" reason:nil userInfo:nil];
}

- (BOOL)isEqualFalse {
    return YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"nil"];
}

@end
