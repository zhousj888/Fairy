//
//  FARNull.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import "FARNull.h"
#import "FARVMEnvironment.h"
#import "FARNullFuncInstance.h"

@implementation FARNull

+ (instancetype)nullWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack {
    return [[FARNull alloc] initWithEnv:env stack:stack];
}


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack {
    if (self = [super initWithEnv:env]) {
        self.stack = stack;
    }
    return self;
}


- (FARBaseObj *)propertyWithId:(NSString *)name {
    
    if ([name isEqualToString:FAR_CMPOR_FUNC] ||
        [name isEqualToString:FAR_AND_FUNC] ||
        [name isEqualToString:FAR_NOT_FUNC]
        ) {
        return [[FARNullFuncInstance alloc] initWithEnv:self.globalEnv stack:self.stack funcName:name];
    }
    @throw [NSException exceptionWithName:@"不能对null取变量" reason:nil userInfo:nil];
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    @throw [NSException exceptionWithName:@"不能对null调用方法" reason:nil userInfo:nil];
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    @throw [NSException exceptionWithName:@"不能对null设置变量" reason:nil userInfo:nil];
}


- (BOOL)isEqualTrue {
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"nil"];
}

@end
