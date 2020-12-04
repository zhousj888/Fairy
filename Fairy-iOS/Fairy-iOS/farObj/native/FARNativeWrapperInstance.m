//
//  FARNativeWrapperInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARNativeWrapperInstance.h"

@implementation FARNativeWrapperInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode nativeObj:(id)obj {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        self.value = obj;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    @throw [NSException exceptionWithName:@"找不到方法" reason:nil userInfo:nil];
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    @throw [NSException exceptionWithName:@"找不到属性" reason:nil userInfo:nil];
}

- (void)declareVar:(NSString *)key {
    @throw [NSException exceptionWithName:@"找不到属性" reason:nil userInfo:nil];
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    @throw [NSException exceptionWithName:@"找不到属性" reason:nil userInfo:nil];
}

- (id)toNativeObj {
    return self.value;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(NativeWrapper:%@)", self.value];
}

@end
