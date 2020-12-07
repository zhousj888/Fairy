//
//  FARFunRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARFuncRunInstance : FARBaseCodeRunInstance

- (void)makeReRunable;//调用一次把isRet变成NO,又可以执行一次

@end

NS_ASSUME_NONNULL_END
