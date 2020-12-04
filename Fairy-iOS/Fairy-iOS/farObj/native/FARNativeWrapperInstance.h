//
//  FARNativeWrapperInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARNativeWrapperInstance : FARBaseCodeRunInstance

@property (nonatomic, strong) id value;

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode nativeObj:(id)obj;

@end

NS_ASSUME_NONNULL_END
