//
//  UIGestureRecognizer+Fairy.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/7.
//

#import "UIGestureRecognizer+Fairy.h"
#import <objc/runtime.h>

static const int target_key;

@implementation UIGestureRecognizer (Fairy)


+(instancetype)nvm_gestureRecognizerWithActionBlock:(NVMGestureBlock)block {
  return [[self alloc]initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(NVMGestureBlock)block {
  self = [self init];
  [self addActionBlock:block];
  [self addTarget:self action:@selector(invoke:)];
  return self;
}

- (void)addActionBlock:(NVMGestureBlock)block {
  if (block) {
    objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
  }
}

- (void)invoke:(id)sender {
  NVMGestureBlock block = objc_getAssociatedObject(self, &target_key);
  if (block) {
    block(sender);
  }
}


@end
