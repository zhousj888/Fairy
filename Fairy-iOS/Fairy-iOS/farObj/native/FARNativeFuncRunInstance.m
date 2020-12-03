//
//  FARNativeFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARNativeFuncRunInstance.h"
#import "FARStringRunInstance.h"
#import "FARNativeApi.h"
#import "NSDictionary+Fairy.h"


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


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    NSString *funcSelStr = [NSString stringWithFormat:@"%@:",self.funcName];
    SEL selector = NSSelectorFromString(funcSelStr);
    IMP imp = [[FARNativeApi sharedInstance] methodForSelector:selector];
    if (imp) {
        id (*func)(id, SEL, id) = (void *)imp;
        id ret = func([FARNativeApi sharedInstance], selector, params);
        if (ret && [ret respondsToSelector:@selector(toFARObj)]) {
            [self.stack push:[ret performSelector:@selector(toFARObj)]];
        }
    }
    
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<func: %@>", self.funcName];
}



@end
