//
//  FARVMStack.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARVMStack.h"
#import "FARNull.h"

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

- (NSInteger)currentSp {
    return self.stackArr.count;
}

- (void)popTo:(NSInteger)sp {
    if (self.currentSp <= sp) {
        return;
    }
    while (self.currentSp > sp) {
        [self pop];
    }
}

- (void)push:(FARBaseObj *)obj {
    [self.stackArr addObject:obj];
}

- (void)pushNullWithEnv:(FARVMEnvironment *)globalEnv {
    [self.stackArr addObject:[FARNull nullWithEnv:globalEnv stack:self]];
}


- (FARBaseObj *)pop {
    FARBaseObj *obj = self.stackArr.lastObject;
    [self.stackArr removeLastObject];
    return obj;
}

- (FARBaseObj *)peek {
    return self.stackArr.lastObject;
}


- (void)printStack {
    NSMutableString *mutStr = [NSMutableString string];
    for(id stackEle in self.stackArr) {
        [mutStr appendFormat:@"%@,",stackEle];
    }
    FARLog(@"stack:  %@",mutStr);
}

@end
