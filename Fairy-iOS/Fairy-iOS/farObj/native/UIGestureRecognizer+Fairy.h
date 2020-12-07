//
//  UIGestureRecognizer+Fairy.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NVMGestureBlock)(id sender);

@interface UIGestureRecognizer (Fairy)



+(instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block;

@end

NS_ASSUME_NONNULL_END
