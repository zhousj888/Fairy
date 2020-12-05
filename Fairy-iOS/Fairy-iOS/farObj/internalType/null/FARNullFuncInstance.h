//
//  FARNullFuncInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARBaseObj.h"
#import "FARBasicFuncRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARNullFuncInstance : FARBaseCodeRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack funcName:(NSString *)funcName;

@end

NS_ASSUME_NONNULL_END
