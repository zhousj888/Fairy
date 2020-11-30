//
//  FARNumberRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARNumberRunInstance.h"

@interface FARNumberRunInstance()

@property (nonatomic, copy) NSString *operKey;
@property (nonatomic, assign, readwrite) NSInteger intergerValue;
@property (nonatomic, assign, readwrite) double doubleValue;
@property (nonatomic, strong, readonly) NSNumber *number;

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
    FARBaseObj *obj = [super propertyWithId:name];
    if (obj) {
        return obj;
    }
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
       [name isEqualToString:FAR_NOT_FUNC  ]
       ) {
        self.operKey = name;
        return self;
    }
    return nil;
}



- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARNumberRunInstance *otherNumber = params[FAR_OPER_1];
    FARNumberRunInstance *result = nil;
    if ([self.operKey isEqualToString:FAR_ADD_FUNC  ]) {
        result = [self addOtherNumber:otherNumber];
    }else if ([self.operKey isEqualToString:FAR_SUB_FUNC  ]) {
        result = [self subOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_MUL_FUNC  ]) {
        result = [self mulOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_DIV_FUNC  ]) {
        result = [self divOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_MOD_FUNC  ]) {
        result = [self modOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPGT_FUNC]) {
        result = [self cmpgtOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPLT_FUNC]) {
        result = [self cmpltOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPGE_FUNC]) {
        result = [self cmpgeOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPLE_FUNC]) {
        result = [self cmpleOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPEQ_FUNC]) {
        result = [self cmpeqOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPNE_FUNC]) {
        result = [self cmpneOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_CMPOR_FUNC]) {
        result = [self orOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_AND_FUNC  ]) {
        result = [self andOtherNumber:otherNumber];
        
    }else if ([self.operKey isEqualToString:FAR_NEG_FUNC  ]) {
        result = [self neg];
        
    }else if ([self.operKey isEqualToString:FAR_NOT_FUNC  ]) {
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
