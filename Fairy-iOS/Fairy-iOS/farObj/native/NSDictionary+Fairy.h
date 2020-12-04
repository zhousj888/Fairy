//
//  NSDictionary+Fairy.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import "FARBaseObj.h"
#import "FARDicRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Fairy)

- (FARDicRunInstance *)toFarObjWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;

@end

NS_ASSUME_NONNULL_END
