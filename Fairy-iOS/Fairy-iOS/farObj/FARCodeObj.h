//
//  FARCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARBaseObj.h"
#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARCodeObj : FARBaseObj

- (void)addCodeIndex:(NSInteger)codeIndex;
- (void)addSubCodeObj:(FARCodeObj *)subCodeObj;
- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env;

@end

NS_ASSUME_NONNULL_END
