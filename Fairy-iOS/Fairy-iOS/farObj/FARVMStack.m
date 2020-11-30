//
//  FARVMStack.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARVMStack.h"

@interface FARVMStack()

@property (nonatomic, strong) NSMutableArray<FARBaseObj *> *stackArr;

@end

@implementation FARVMStack

- (instancetype)init {
    self = [super init];
    if (self) {
        _stackArr = [NSMutableArray array];
    }
    return self;
}


- (void)push:(FARBaseObj *)obj {
    [self.stackArr addObject:obj];
}


- (FARBaseObj *)pop {
    FARBaseObj *obj = self.stackArr.lastObject;
    [self.stackArr removeLastObject];
    return obj;
}


- (void)printStack {
    NSMutableString *mutStr = [NSMutableString string];
    for(id stackEle in self.stackArr) {
        [mutStr appendFormat:@"%@,",stackEle];
    }
    NSLog(@"stack:  %@",mutStr);
}

@end
