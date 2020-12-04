//
//  FARBasicFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARBasicFuncRunInstance.h"
#import "FARNumberCodeObj.h"

@interface FARBasicFuncRunInstance()

@property (nonatomic, copy) NSString *funcName;

@end

@implementation FARBasicFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        _funcName = [funcName copy];
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    if ([self.funcName isEqualToString:FAR_CMPEQ_FUNC]) {
        FARBaseObj *otherObj = params[FAR_OPER_1];
        FARBaseObj *selfObj = [self propertyWithId:FAR_SELF_INS];
        if (selfObj == otherObj) {
            [self.stack push:[FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode integer:1]];
        }else {
            [self.stack push:[FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode integer:0]];
        }
    }else {
        @throw [NSException exceptionWithName:@"找不到方法" reason:nil userInfo:nil];
    }
    return nil;
}

@end
