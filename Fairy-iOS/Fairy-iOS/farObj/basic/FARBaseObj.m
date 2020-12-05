//
//  FARBaseObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARBaseObj.h"
#import "FARVMEnvironment.h"
#import "FARNativeWrapperInstance.h"
#import "FARFuncRunInstance.h"

@interface FARBaseObj()

@end

@implementation FARBaseObj

- (instancetype)initWithEnv:(FARVMEnvironment *)env {
    if (self = [super init]) {
        _globalEnv = env;
        _env = [[FARVMEnvironment alloc] initWithOuter:_globalEnv];
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARBaseObj *obj = [self.env findVarForKey:name];
    return obj;
}

- (void)declareVar:(NSString *)key {
    @throw [NSException exceptionWithName:@"baseObj不能乱定义变量😢" reason:nil userInfo:nil];
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    if ([self.env findVarForKey:key]) {
        [self.env setVar:value key:key];
    }else {
        @throw [NSException exceptionWithName:@"找不到变量" reason:nil userInfo:nil];
    }
}

- (BOOL)isEqualFalse {
    return NO;
}


- (id)toNativeObj {
    @throw [NSException exceptionWithName:@"这个对象toNative没有实现" reason:nil userInfo:nil];
}

@end
