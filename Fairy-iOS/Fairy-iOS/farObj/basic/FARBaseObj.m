//
//  FARBaseObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARBaseObj.h"
#import "FARVMEnvironment.h"

@interface FARBaseObj()

@end

@implementation FARBaseObj

- (instancetype)initWithEnv:(FARVMEnvironment *)env {
    if (self = [super init]) {
        _env = env;
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARBaseObj *obj = [self.env findVarForKey:name];
    return obj;
}

- (BOOL)isEqualFalse {
    return NO;
}


- (id)toNativeObj {
    @throw [NSException exceptionWithName:@"这个对象toNative没有实现" reason:nil userInfo:nil];
}

@end
