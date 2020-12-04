//
//  UIView+Fairy.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import <UIKit/UIKit.h>
#import "FARBaseObj.h"
#import "FARVMStack.h"
#import "FARCodeObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Fairy)

- (FARBaseObj *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;

@end

NS_ASSUME_NONNULL_END
