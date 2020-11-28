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


+ (FARNumberRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env integer:(NSInteger)number;


+ (FARNumberRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env decimal:(double)decimal;

@end

NS_ASSUME_NONNULL_END
