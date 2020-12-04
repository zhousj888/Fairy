//
//  FARNullFuncInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARNullFuncInstance.h"

@interface FARNullFuncInstance()

@property (nonatomic, strong) NSString *funcName;

@end

@implementation FARNullFuncInstance

- (instancetype)initWithFuncName:(NSString *)funcName {
    if (self = [super initWithEnv:nil]) {
        _funcName = funcName;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARBaseObj *otherObj = params[FAR_OPER_1];
    if ([self.funcName isEqualToString:FAR_CMPOR_FUNC]) {
        [self.stack push:otherObj];
    }else if ([self.funcName isEqualToString:FAR_AND_FUNC]){
        [self.stack pushNull];
    }else if ([self.funcName isEqualToString:FAR_NOT_FUNC]){
    }
    return nil;
}

@end
