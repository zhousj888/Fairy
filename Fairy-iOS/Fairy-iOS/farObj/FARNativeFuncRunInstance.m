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


@implementation FARNativeFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _funcName = [funcName copy];
    }
    return self;
}



@end
