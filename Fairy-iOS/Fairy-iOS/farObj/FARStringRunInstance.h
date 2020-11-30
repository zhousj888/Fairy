//
//  FARStringRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARStringRunInstance : FARBaseCodeRunInstance


@property (nonatomic, copy) NSString *value;


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode str:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
