//
//  FARBoolFunRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARFuncRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARBoolFunRunInstance : FARFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName;

@end

NS_ASSUME_NONNULL_END
