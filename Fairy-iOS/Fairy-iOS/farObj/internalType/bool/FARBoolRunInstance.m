//
//  FARBoolRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARBoolRunInstance.h"
#import "FARBoolFunRunInstance.h"

@interface FARBoolRunInstance()

@property (nonatomic, assign, readwrite) BOOL boolValue;

@end

@implementation FARBoolRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode boolValue:(BOOL)boolValue {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        self.boolValue = boolValue;
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    if(
       [name isEqualToString:FAR_AND_FUNC  ] ||
       [name isEqualToString:FAR_CMPOR_FUNC] ||
       [name isEqualToString:FAR_NOT_FUNC  ] ||
       [name isEqualToString:FAR_TO_NATIVE_FUNC]
       ) {
        
        FARFuncRunInstance *func = [[FARBoolFunRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:self.codeObj vmCode:self.vmCode funcName:name];
        func.capturedEnvInstance = self;
        
        return func;
    }else {
        @throw [NSException exceptionWithName:@"方法找不到" reason:nil userInfo:nil];
    }
    return nil;
}


- (BOOL)isEqualTrue {
    return self.boolValue;
}

- (id)toNativeObj {
    return @(self.boolValue);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @(self.boolValue)];
}


@end
