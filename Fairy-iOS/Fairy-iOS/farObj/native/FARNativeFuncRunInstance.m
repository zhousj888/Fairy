//
//  FARNativeFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARNativeFuncRunInstance.h"
#import "FARNativeObj.h"
#import "FARStringRunInstance.h"

static NSString *const FAR_NATIVE_FUNC_LOG = @"log";
static NSString *const FAR_NATIVE_FUNC_LOG_PARAM = @"text";

static NSString *const FAR_NATIVE_FUNC_INIT = @"init";
static NSString *const FAR_NATIVE_FUNC_INIT_PARAM = @"className";

static NSString *const FAR_NATIVE_FUNC_CALL_FUNC = @"callFunc";
static NSString *const FAR_NATIVE_FUNC_CALL_FUNC_PARAM_NATIVE_OBJ = @"nativeObj";
static NSString *const FAR_NATIVE_FUNC_CALL_FUNC_PARAM_FUNC_NAME = @"funcName";

static NSString *const FAR_NATIVE_FUNC_CALL_FUNC_PARAM1 = @"callFuncParam1";
static NSString *const FAR_NATIVE_FUNC_CALL_FUNC_PARAM = @"param";

static NSString *const FAR_NATIVE_FUNC_CALL_FUNC_PARAM1_RET_FARObj = @"callFuncParam1RetFarObj";

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
    if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_LOG]) {
        NSLog(@"NativeLog:-------------->   %@",params[FAR_NATIVE_FUNC_LOG_PARAM]);
    }else if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_INIT]) {
        FARStringRunInstance *className = params[FAR_NATIVE_FUNC_INIT_PARAM];
        Class cls = NSClassFromString(className.toNative);
        NSObject *obj = [[cls alloc] init];
        FARNativeObj *nativeObj = [[FARNativeObj alloc] initWithEnv:self.env value:obj];
        [self.stack push:nativeObj];
    }else if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_CALL_FUNC]) {
        FARNativeObj *nativeObj = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_NATIVE_OBJ];
        FARStringRunInstance *funcName = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_FUNC_NAME];
        
        SEL selector = NSSelectorFromString(funcName.toNative);
        IMP imp = [nativeObj.value methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(nativeObj.value, selector);
        
    }else if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_CALL_FUNC_PARAM1]) {
        FARNativeObj *nativeObj = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_NATIVE_OBJ];
        FARStringRunInstance *funcName = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_FUNC_NAME];
        //这里的参数不一定要是NativeObj，如果需要NativeObj，外部自己toNative转换
        FARBaseObj *param = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM];
        
        NSString *funcSelStr = [NSString stringWithFormat:@"%@:",funcName];
        
        SEL selector = NSSelectorFromString(funcSelStr);
        IMP imp = [nativeObj.value methodForSelector:selector];
        void (*func)(id, SEL, id) = (void *)imp;
        func(nativeObj.value, selector, param);
    }else if ([self.funcName isEqualToString:FAR_NATIVE_FUNC_CALL_FUNC_PARAM1_RET_FARObj]) {
        FARNativeObj *nativeObj = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_NATIVE_OBJ];
        FARStringRunInstance *funcName = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM_FUNC_NAME];
        FARBaseObj *param = params[FAR_NATIVE_FUNC_CALL_FUNC_PARAM];
        
        
        
        NSString *funcSelStr = [NSString stringWithFormat:@"%@:",funcName];
        
        SEL selector = NSSelectorFromString(funcSelStr);
        IMP imp = [nativeObj.value methodForSelector:selector];
        FARBaseObj* (*func)(id, SEL, id) = (void *)imp;
        FARBaseObj* ret = nil;
        if ([param isKindOfClass:[FARNativeObj class]]) {
            ret = func(nativeObj.value, selector, ((FARNativeObj *)param).value);
        }else {
            ret = func(nativeObj.value, selector, param);
        }
        
        [self.stack push:ret];
    }
    return nil;
}



@end
