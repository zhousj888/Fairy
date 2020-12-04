//
//  FARDicCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARCodeObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARDicCodeObj : FARCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode;

@end

NS_ASSUME_NONNULL_END
