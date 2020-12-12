//
//  FARParser.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "FARVMCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARParser : NSObject

- (FARVMCode *)parse:(NSString *)code withFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
