//
//  FARBoolRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARBoolRunInstance : FARBaseCodeRunInstance


@property (nonatomic, assign, readonly) BOOL boolValue;

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode boolValue:(BOOL)boolValue;


@end

NS_ASSUME_NONNULL_END
