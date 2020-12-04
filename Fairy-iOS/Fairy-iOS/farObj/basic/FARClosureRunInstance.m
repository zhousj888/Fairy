//
//  FARClosureRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARClosureRunInstance.h"
#import "NSArray+Fairy.h"

@implementation FARClosureRunInstance


- (FARBaseObj *)propertyWithId:(NSString *)name {
    return [super propertyWithId:name];
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    NSInteger origSp = self.currentSp;
    [super runWithParams:params];
    if (origSp == self.currentSp) {
        [self.stack pushNull];
    }else if (self.isFuncFinished){
        NSMutableArray<FARBaseObj *> *stackObjs = [NSMutableArray array];
        while (self.currentSp > origSp) {
            [stackObjs insertObject:self.stack.pop atIndex:0];
        }
        FARArrayRunInstance *farArray = [stackObjs toFarObjWithEnv:self.env stack:self.stack codeObj:self.codeObj vmCode:self.vmCode];
        [self.stack push:farArray];
    }else {
        FARBaseObj *ret = [self.stack pop];
        [self.stack popTo:origSp];
        [self.stack push:ret];
    }
    
    return nil;
}

@end
