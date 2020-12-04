//
//  FARStringCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARCodeObj.h"
#import "FARStringRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARStringCodeObj : FARCodeObj

+ (FARStringRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack vmCode:(FARVMCode *)vmCode string:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
