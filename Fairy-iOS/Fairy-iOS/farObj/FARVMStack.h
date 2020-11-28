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

- (void)push:(FARBaseObj *)obj;
- (FARBaseObj *)pop;

@end

NS_ASSUME_NONNULL_END
