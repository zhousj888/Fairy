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


- (FARBaseObj *)runWithParams:(NSDictionary<NSString *, FARBaseObj *> *)params {
    NSString *funcSelStr = [NSString stringWithFormat:@"%@:",self.funcName];
    SEL selector = NSSelectorFromString(funcSelStr);
    IMP imp = [[FARNativeApi sharedInstance] methodForSelector:selector];
    if (imp) {
        id (*func)(id, SEL, id) = (void *)imp;
        
        NSMutableDictionary *mutaParams = [params mutableCopy];
        for (NSString *key in params) {
            mutaParams[key] = [params[key] toNativeObj];
        }
        
        NSObject *ret = func([FARNativeApi sharedInstance], selector, mutaParams);
        if (ret) {
            SEL toFarSel = @selector(toFarObjWithEnv:stack:codeObj:vmCode:);
            IMP imp = [ret methodForSelector:toFarSel];
            FARBaseObj * (*toFar)(id, SEL, FARVMEnvironment*, FARVMStack *, FARCodeObj *, FARVMCode *) = (void *)imp;
            FARBaseObj *baseObj = toFar(ret, toFarSel, self.env, self.stack, self.codeObj, self.vmCode);
            [self.stack push:baseObj];
        }
    }else {
        @throw [NSException exceptionWithName:@"方法找不到" reason:nil userInfo:nil];
    }
    
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<func: %@>", self.funcName];
}



@end
