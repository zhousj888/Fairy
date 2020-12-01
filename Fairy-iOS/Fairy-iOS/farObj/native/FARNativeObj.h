//
//  FARNativeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/1.
//

#import "FARBaseObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARNativeObj : FARBaseObj

@property (nonatomic, strong) id value;

- (instancetype)initWithEnv:(FARVMEnvironment *)env value:(id)value;

@end

NS_ASSUME_NONNULL_END
