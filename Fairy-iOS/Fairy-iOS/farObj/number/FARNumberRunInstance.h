//
//  FARNumberRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FARNumberType) {
    FARNumberTypeInterger = 1,
    FARNumberTypeDouble,
};

@interface FARNumberRunInstance : FARBaseCodeRunInstance

@property (nonatomic, assign, readonly) NSInteger intergerValue;
@property (nonatomic, assign, readonly) double doubleValue;
@property (nonatomic, assign, readonly) FARNumberType type;

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode integer:(NSInteger)integer;
- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode decimal:(double)decimal;


- (FARNumberRunInstance *)addOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)subOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)mulOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)divOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)modOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpgtOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpltOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpgeOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpleOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpeqOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)cmpneOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)orOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)andOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)neg;
- (FARNumberRunInstance *)doNot;


@end

NS_ASSUME_NONNULL_END
