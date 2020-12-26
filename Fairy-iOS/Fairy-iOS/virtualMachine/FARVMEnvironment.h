//
//  FARVMEnvironment.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import <Foundation/Foundation.h>
#import "FARBaseObj.h"
#import "FARVMStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARVMEnvironment : NSObject

@property (nonatomic, strong) FARVMEnvironment *outer;

- (instancetype)init;
- (instancetype)initWithOuter:(FARVMEnvironment * _Nullable )outer;

- (nullable FARBaseObj *)findVarForKey:(NSString *)key;
- (void)setVar:(FARBaseObj *)value key:(NSString *)key;//要先declare再set
- (void)declareVar:(NSString *)key withGlobalEnv:(FARVMEnvironment *)globalEnv withStack:(FARVMStack *)stack;
- (NSDictionary *)asParams;
- (void)addParams:(NSDictionary *)params;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
