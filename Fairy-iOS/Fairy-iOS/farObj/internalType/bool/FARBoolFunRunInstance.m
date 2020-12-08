//
//  FARBoolFunRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARBoolFunRunInstance.h"
#import "FARBoolRunInstance.h"
#import "FARBoolCodeObj.h"

@interface FARBoolFunRunInstance()

@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, readonly) BOOL boolValue;

@end

@implementation FARBoolFunRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        self.funcName = funcName;
    }
    return self;
}

- (BOOL)boolValue {
    return ((FARBoolRunInstance *)self.capturedEnvInstance).boolValue;
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    FARBaseCodeRunInstance *otherObj = params[FAR_OPER_1];
    
    if ([self.funcName isEqualToString:FAR_AND_FUNC]) {
        if (self.boolValue) {
            [self.stack push:otherObj];
        }else {
            [self.stack push:self.capturedEnvInstance];
        }
    }else if ([self.funcName isEqualToString:FAR_CMPOR_FUNC]) {
        if (self.boolValue) {
            [self.stack push:self];
        }else {
            [self.stack push:otherObj];
        }
        
    }else if ([self.funcName isEqualToString:FAR_NOT_FUNC]) {
        if (self.boolValue) {
            [self.stack push:[FARBoolCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode boolValue:NO]];
        }else {
            [self.stack push:[FARBoolCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode boolValue:YES]];
        }
    }else {
        @throw [NSException exceptionWithName:@"方法找不到" reason:nil userInfo:nil];
    }
    
    return nil;
    
}

@end
