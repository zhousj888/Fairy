//
//  FARBaseObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FARVMEnvironment;

@interface FARBaseObj : NSObject

@property (nonatomic, readwrite) FARVMEnvironment *env;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEnv:(FARVMEnvironment *)env;
- (FARBaseObj *)propertyWithId:(NSString *)name;
- (BOOL)isEqualFalse;
- (id)toNativeObj;

@end

NS_ASSUME_NONNULL_END
