//
//  FARVMEnvironment.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import <Foundation/Foundation.h>
#import "FARBaseObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARVMEnvironment : NSObject

@property (nonatomic, strong) FARVMEnvironment *outer;

- (instancetype)init;
- (instancetype)initWithOuter:(FARVMEnvironment * _Nullable )outer;

- (nullable FARBaseObj *)findVarForKey:(NSString *)key;
- (void)setVar:(FARBaseObj *)value key:(NSString *)key;
- (void)declareVar:(NSString *)key;
- (void)declareLet:(NSString *)key;
- (NSDictionary *)asParams;
- (void)addParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
