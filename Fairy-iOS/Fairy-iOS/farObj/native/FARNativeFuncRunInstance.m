//
//  FARNativeFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARNativeFuncRunInstance.h"

@interface FARNativeFuncRunInstance()

@property (nonatomic, copy) NSString *funcName;

@end

static NSString *const FAR_NATIVE_FUNC_LOG = @"log";


@implementation FARNativeFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _funcName = [funcName copy];
    }
    return self;
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_LOG]) {
        NSLog(@"NativeLog:-------------->   %@",params[@"text"]);
    }
    return nil;
}



@end
