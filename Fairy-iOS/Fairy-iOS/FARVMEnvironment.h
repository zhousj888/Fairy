//
//  FARVMEnvironment.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FARVMEnvironment : NSObject

@property (nonatomic, strong) FARVMEnvironment *outer;

- (instancetype)init;
- (instancetype)initWithOuter:(FARVMEnvironment * _Nullable )outer;

- (id)findVarForKey:(NSString *)key;
- (void)setVar:(id)value key:(NSString *)key;
- (void)declareVar:(NSString *)key;
- (void)declareLet:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
