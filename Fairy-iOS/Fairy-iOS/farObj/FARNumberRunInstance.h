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

- (instancetype)initWithEnv:(FARVMEnvironment *)env integer:(NSInteger)integer;
- (instancetype)initWithEnv:(FARVMEnvironment *)env decimal:(double)decimal;


- (FARNumberRunInstance *)addOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)subOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)mulOtherNumber:(FARNumberRunInstance *)otherNumber;
- (FARNumberRunInstance *)divOtherNumber:(FARNumberRunInstance *)otherNumber;


@end

NS_ASSUME_NONNULL_END
