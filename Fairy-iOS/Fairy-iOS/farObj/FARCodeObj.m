//
//  FARCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARCodeObj.h"

@interface FARCodeObj()

@property (nonatomic, strong) NSMutableArray<NSNumber*> *codeIndexArr;

@end

@implementation FARCodeObj

- (void)addCodeIndex:(NSInteger)codeIndex {
    [self.codeIndexArr addObject:@(codeIndex)];
}

+ (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env {
    @throw [NSException exceptionWithName:@"需要子类实现" reason:nil userInfo:nil];
}

- (NSMutableArray<NSNumber *> *)codeIndexArr {
    if (!_codeIndexArr) {
        _codeIndexArr = [NSMutableArray array];
    }
    return _codeIndexArr;
}

@end
