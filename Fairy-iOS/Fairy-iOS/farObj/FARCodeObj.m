//
//  FARCodeObj.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARCodeObj.h"

@implementation FARCodeObj

- (void)addCodeIndex:(NSInteger)codeIndex {
    [self.codeIndexArr addObject:@(codeIndex)];
}

- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    FARBaseCodeRunInstance *runInstance = [[FARBaseCodeRunInstance alloc] initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode];
    return runInstance;
}

- (void)addSubCodeObj:(FARCodeObj *)subCodeObj {
    [self.codeObjArr addObject:subCodeObj];
}

- (NSMutableArray<FARCodeObj *> *)codeObjArr {
    if(!_codeObjArr) {
        _codeObjArr = [NSMutableArray array];
    }
    return _codeObjArr;

}

- (NSMutableArray<NSNumber *> *)codeIndexArr {
    if (!_codeIndexArr) {
        _codeIndexArr = [NSMutableArray array];
    }
    return _codeIndexArr;
}

@end
