//
//  FARClassRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseCodeRunInstance.h"
#import "FARClassCodeObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARClassRunInstance : FARBaseCodeRunInstance

@property (nonatomic, strong) FARClassCodeObj *classCodeObj;
@property (nonatomic, strong) FARClassRunInstance *superInstance;

@end

NS_ASSUME_NONNULL_END
