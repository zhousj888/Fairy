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

- (instancetype)initWithEnv:(FARVMEnvironment *)env integer:(NSInteger)integer {
    if (self = [super initWithEnv:env]) {
        _intergerValue = integer;
        _type = FARNumberTypeInterger;
    }
    return self;
}

- (instancetype)initWithEnv:(FARVMEnvironment *)env decimal:(double)decimal {
    if (self = [super initWithEnv:env]) {
        _doubleValue = decimal;
        _type = FARNumberTypeDouble;
    }
    return self;
}

- (FARNumberRunInstance *)addOtherNumber:(FARNumberRunInstance *)otherNumber {
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue + otherNumber.doubleValue;
        return [[FARNumberRunInstance alloc] initWithEnv:self.env decimal:result];
    }
    NSInteger result = self.intergerValue + otherNumber.intergerValue;
    return [[FARNumberRunInstance alloc] initWithEnv:self.env integer:result];
}

- (FARNumberRunInstance *)subOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue - otherNumber.doubleValue;
        return [[FARNumberRunInstance alloc] initWithEnv:self.env decimal:result];
    }
    NSInteger result = self.intergerValue - otherNumber.intergerValue;
    return [[FARNumberRunInstance alloc] initWithEnv:self.env integer:result];
}
- (FARNumberRunInstance *)mulOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue * otherNumber.doubleValue;
        return [[FARNumberRunInstance alloc] initWithEnv:self.env decimal:result];
    }
    NSInteger result = self.intergerValue * otherNumber.intergerValue;
    return [[FARNumberRunInstance alloc] initWithEnv:self.env integer:result];
}
- (FARNumberRunInstance *)divOtherNumber:(FARNumberRunInstance *)otherNumber {
    
    if (self.type == FARNumberTypeDouble || otherNumber.type == FARNumberTypeDouble) {
        double result = self.doubleValue / otherNumber.doubleValue;
        return [[FARNumberRunInstance alloc] initWithEnv:self.env decimal:result];
    }
    NSInteger result = self.intergerValue / otherNumber.intergerValue;
    return [[FARNumberRunInstance alloc] initWithEnv:self.env integer:result];
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
    return self.number.boolValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.number];
}

@end
