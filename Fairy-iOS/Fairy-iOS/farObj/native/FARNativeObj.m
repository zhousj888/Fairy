//
//  FARNativeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARNativeObj.h"

@implementation FARNativeObj


- (instancetype)initWithEnv:(FARVMEnvironment *)env value:(id)value {
    if (self = [super initWithEnv:env]) {
        self.value = value;
    }
    return self;
}

@end
