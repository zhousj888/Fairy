//
//  FARNumberRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberRunInstance.h"
#import "FARNumberFuncRunInstance.h"
#import "FARVMEnvironment.h"

@interface FARNumberRunInstance()

@property (nonatomic, assign, readwrite) NSInteger intergerValue;
@property (nonatomic, assign, readwrite) double doubleValue;

@end


@implementation FARNumberRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode integer:(NSInteger)integer {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _intergerValue = integer;
        _type = FARNumberTypeInterger;
    }
    return self;
}

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode decimal:(double)decimal {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _doubleValue = decimal;
        _type = FARNumberTypeDouble;
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    if(
       [name isEqualToString:FAR_ADD_FUNC  ] ||
       [name isEqualToString:FAR_SUB_FUNC  ] ||
       [name isEqualToString:FAR_MUL_FUNC  ] ||
       [name isEqualToString:FAR_DIV_FUNC  ] ||
       [name isEqualToString:FAR_MOD_FUNC  ] ||
       [name isEqualToString:FAR_CMPGT_FUNC] ||
       [name isEqualToString:FAR_CMPLT_FUNC] ||
       [name isEqualToString:FAR_CMPGE_FUNC] ||
       [name isEqualToString:FAR_CMPLE_FUNC] ||
       [name isEqualToString:FAR_CMPEQ_FUNC] ||
       [name isEqualToString:FAR_CMPNE_FUNC] ||
       [name isEqualToString:FAR_CMPOR_FUNC] ||
       [name isEqualToString:FAR_AND_FUNC  ] ||
       [name isEqualToString:FAR_NEG_FUNC  ] ||
       [name isEqualToString:FAR_NOT_FUNC  ] ||
       [name isEqualToString:FAR_TO_NATIVE_FUNC]
       ) {
        FARNumberFuncRunInstance *func = [[FARNumberFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:self.codeObj vmCode:self.vmCode funcName:name];
        func.capturedEnvInstance = self;
        return func;
    }else {
        @throw [NSException exceptionWithName:@"方法找不到" reason:nil userInfo:nil];
    }
    return nil;
}


- (double)doubleValue {
    if (self.type == FARNumberTypeDouble) {
        return _doubleValue;
    }
    return (double)_intergerValue;
}

- (NSInteger)intergerValue {
    if (self.type == FARNumberTypeInterger) {
        return _intergerValue;
    }
    return (double)_doubleValue;
}


- (NSNumber *)number {
    if (self.type == FARNumberTypeInterger) {
        return @(self.intergerValue);
    }else {
        return @(self.doubleValue);
    }
}

- (BOOL)isEqualFalse {
    return !self.number.boolValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.number];
}

@end
