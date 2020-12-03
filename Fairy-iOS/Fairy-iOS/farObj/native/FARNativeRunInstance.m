//
//  FARNativeRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/29.
//

#import "FARNativeRunInstance.h"
#import "FARNativeFuncRunInstance.h"
#import "FARVMEnvironment.h"

@implementation FARNativeRunInstance

- (FARBaseObj *)propertyWithId:(NSString *)name {
    return [[FARNativeFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:self.codeObj vmCode:self.vmCode funcName:name];
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    return nil;
}

@end
