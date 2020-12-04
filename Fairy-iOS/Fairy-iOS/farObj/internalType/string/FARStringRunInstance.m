//
//  FARStringRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARStringRunInstance.h"

@implementation FARStringRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode str:(NSString *)str {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _value = [str copy];
    }
    return self;
}

- (id)toNativeObj {
    return self.value;
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    @throw [NSException exceptionWithName:@"方法找不到" reason:nil userInfo:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.value];
}

@end
