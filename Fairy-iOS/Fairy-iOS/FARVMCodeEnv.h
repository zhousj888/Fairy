//
//  FARVMCodeEnv.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARVMEnvironment.h"
#import "FARVMCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARVMCodeEnv : FARVMEnvironment

- (instancetype)initWithVMCode:(FARVMCode *)vmCode;

@end

NS_ASSUME_NONNULL_END
