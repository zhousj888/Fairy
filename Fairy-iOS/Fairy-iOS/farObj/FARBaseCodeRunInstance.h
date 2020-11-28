//
//  FARCodeRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARBaseCodeRunInstance : FARBaseObj

@property (nonatomic, weak) FARBaseCodeRunInstance *callerInstance;
@property (nonatomic, readonly) NSInteger currentSp;

- (FARBaseObj *)runWithParams:(NSDictionary *)params;
- (void)resume;

@end

NS_ASSUME_NONNULL_END
