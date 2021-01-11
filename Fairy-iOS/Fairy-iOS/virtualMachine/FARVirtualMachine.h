//
//  FARVirtualMachine.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 Fairy虚拟机
 可以实例化多个虚拟机，每个虚拟机有自己的堆栈，互不影响
 */
@interface FARVirtualMachine : NSObject

/**
 运行传入的fairy代码，结束之后虚拟机会保持在代码运行完之后的堆栈状态
 */
- (void)runWithCode:(NSString *)code;

/**
 获取代码运行结果返回值，会转换成OC对象
 */
- (id)vmRetValue;

/**
 根据传入的key在堆中找到对象并返回
 */
- (id)vmValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
