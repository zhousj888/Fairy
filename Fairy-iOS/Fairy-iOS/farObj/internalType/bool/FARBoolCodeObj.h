//
//  FARBoolCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/8.
//

#import "FARCodeObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARBoolCodeObj : FARCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode boolValue:(BOOL)boolValue;

@end

NS_ASSUME_NONNULL_END
