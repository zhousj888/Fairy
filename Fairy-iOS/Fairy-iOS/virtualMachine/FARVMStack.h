//
//  FARVMStack.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import <Foundation/Foundation.h>
#import "FARBaseObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARVMStack : NSObject

@property (nonatomic, readonly) NSInteger currentSp;//指向下一个存放的位置

- (void)push:(FARBaseObj *)obj;
- (void)pushNullWithEnv:(FARVMEnvironment *)globalEnv;
- (FARBaseObj *)pop;
- (FARBaseObj *)peek;
- (void)popTo:(NSInteger)sp;
- (void)printStack;

@end

NS_ASSUME_NONNULL_END
