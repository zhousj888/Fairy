//
//  FARVirtualMachine.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FARVirtualMachine : NSObject

- (void)runWithCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
