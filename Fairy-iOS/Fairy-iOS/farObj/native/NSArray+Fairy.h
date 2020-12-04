//
//  NSArray+Fairy.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import <Foundation/Foundation.h>
#import "FARBaseObj.h"
#import "FARVMStack.h"
#import "FARCodeObj.h"
#import "FARArrayRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Fairy)

- (FARArrayRunInstance *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;


@end

NS_ASSUME_NONNULL_END
