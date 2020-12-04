//
//  FARArrayRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARArrayRunInstance.h"
#import "FARArrayFuncRunInstance.h"
#import "FARNumberCodeObj.h"

@interface FARArrayRunInstance()

@property (nonatomic, readwrite) NSMutableArray<FARBaseObj *> *array;

@end


@implementation FARArrayRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        [self declareVar:FAR_SELF_INS];
        [self setPropertyWithKey:FAR_SELF_INS value:self];
        _array = [NSMutableArray array];
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    if ([name isEqualToString:FAR_ARRAY_PUSH] ||
        [name isEqualToString:FAR_ARRAY_REMOVE] ||
        [name isEqualToString:FAR_ARRAY_GET] ||
        [name isEqualToString:FAR_ARRAY_SET] ||
        [name isEqualToString:FAR_ARRAY_PUSH_AT_INDEX]
        ) {
        FARArrayFuncRunInstance *funcIns = [[FARArrayFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:self.codeObj vmCode:self.vmCode funcName:name array:self.array];
        funcIns.capturedEnvInstance = self;
        return funcIns;
    }else if([name isEqualToString:FAR_ARRAY_COUNT]) {
        FARBaseObj *obj = [FARNumberCodeObj newRunInstanceWithEnv:self.globalEnv stack:self.stack vmCode:self.vmCode integer:self.array.count];
        return obj;
    }
    return [super propertyWithId:name];
}

@end
