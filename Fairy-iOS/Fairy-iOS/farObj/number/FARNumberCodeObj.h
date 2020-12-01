//
//  FARNumberCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARCodeObj.h"
#import "FARNumberRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARNumberCodeObj : FARCodeObj

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode integer:(NSInteger)number;
+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode decimal:(double)decimal;

@end

NS_ASSUME_NONNULL_END
