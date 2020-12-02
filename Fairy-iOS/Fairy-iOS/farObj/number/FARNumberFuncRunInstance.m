//
//  FARNumberFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARNumberFuncRunInstance.h"
#import "FARNumberRunInstance.h"

@interface FARNumberFuncRunInstance()

@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, readonly) FARNumberType type;
@property (nonatomic, assign, readonly) NSInteger intergerValue;
@property (nonatomic, assign, readonly) double doubleValue;
@property (nonatomic, strong, readonly) NSNumber *number;

@end

@implementation FARNumberFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _funcName = [funcName copy];
    }
    return self;
}

- (FARNumberType)type {
    return ((FARNumberRunInstance *)self.capturedEnvInstance).type;
}

- (NSInteger)intergerValue {
    return ((FARNumberRunInstance *)self.capturedEnvInstance).intergerValue;
}

- (double)doubleValue {
    return ((FARNumberRunInstance *)self.capturedEnvInstance).doubleValue;
}

- (NSNumber *)number {
    return ((FARNumberRunInstance *)self.capturedEnvInstance).number;
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARNumberRunInstance *otherNumber = params[FAR_OPER_1];
    FARNumberRunInstance *result = nil;
    if ([self.funcName isEqualToString:FAR_ADD_FUNC  ]) {
        result = [self addOtherNumber:otherNumber];
    }else if ([self.funcName isEqualToString:FAR_SUB_FUNC  ]) {
        result = [self subOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_MUL_FUNC  ]) {
        result = [self mulOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_DIV_FUNC  ]) {
        result = [self divOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_MOD_FUNC  ]) {
        result = [self modOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPGT_FUNC]) {
        result = [self cmpgtOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPLT_FUNC]) {
        result = [self cmpltOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPGE_FUNC]) {
        result = [self cmpgeOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPLE_FUNC]) {
        result = [self cmpleOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPEQ_FUNC]) {
        result = [self cmpeqOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPNE_FUNC]) {
        result = [self cmpneOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_CMPOR_FUNC]) {
        result = [self orOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_AND_FUNC  ]) {
        result = [self andOtherNumber:otherNumber];
        
    }else if ([self.funcName isEqualToString:FAR_NEG_FUNC  ]) {
        result = [self neg];
        
    }else if ([self.funcName isEqualToString:FAR_NOT_FUNC  ]) {
        result = [self doNot];
    }
    
    [self.stack push:result];
    
    return nil;
    
}

- (FARNumberRunInstance *)_createNewNumberWithInteger:(NSInteger)number {
    return [[FARNumberRunInstance alloc] initWithEnv:self.env stack:self.stack codeObj:self.codeObj vmCode:self.vmCode integer:number];
}
- (FARNumberRunInstance *)_createNewNumberWithDouble:(double)number {
    return [[FARNumberRunInstance alloc] initWithEnv:self.env stack:self.stack codeObj:self.codeObj vmCode:self.vmCode decimal:number];
}



- (FARNumberRunInstance *)addOtherNumber:(FARNumberRunInstance *)otherNumber {
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue + otherNumber.doubleValue;
        
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue + otherNumber.intergerValue;
    
    return [self _createNewNumberWithInteger:result];
}

- (FARNumberRunInstance *)subOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue - otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue - otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)mulOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue * otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue * otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)divOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue / otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue / otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}

- (FARNumberRunInstance *)modOtherNumber:(FARNumberRunInstance *)otherNumber {
    NSInteger result = self.intergerValue % otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)cmpgtOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue > otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue > otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)cmpltOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue < otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue < otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)cmpgeOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue >= otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue >= otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}


- (FARNumberRunInstance *)cmpleOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue <= otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue <= otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}

- (FARNumberRunInstance *)cmpeqOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue == otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue == otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)cmpneOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue != otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue != otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)orOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue || otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue || otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}
- (FARNumberRunInstance *)andOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue && otherNumber.doubleValue;
        return [self _createNewNumberWithDouble:result];
    }
    NSInteger result = self.intergerValue && otherNumber.intergerValue;
    return [self _createNewNumberWithInteger:result];
}

- (FARNumberRunInstance *)neg {
    if (self.type == FARNumberTypeInterger) {
        return [self _createNewNumberWithInteger:-self.intergerValue];
    }
    return [self _createNewNumberWithDouble:-self.doubleValue];
}
- (FARNumberRunInstance *)doNot {
    if (self.type == FARNumberTypeInterger) {
        return [self _createNewNumberWithInteger:!self.intergerValue];
    }
    return [self _createNewNumberWithDouble:!self.doubleValue];
    
}

@end
