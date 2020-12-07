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
@property (nonatomic, readwrite) FARVMEnvironment *globalEnv;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEnv:(FARVMEnvironment *)env;
- (FARBaseObj *)propertyWithId:(NSString *)name;
- (void)declareVar:(NSString *)key;
- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value;
- (BOOL)isEqualFalse;
- (id)toNativeObj;


//以下方法只能子类调用，外部不要调用

//不抛出异常的设置变量，返回值表示是否设置成功
- (BOOL)_safeSetPropertyWithKey:(NSString *)key value:(FARBaseObj *)value;


@end

NS_ASSUME_NONNULL_END
