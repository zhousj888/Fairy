//
//  FARDicRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARDicRunInstance.h"
#import "FARDicFuncRunInstance.h"

@interface FARDicRunInstance()

@property (nonatomic, readwrite) NSMutableDictionary *dic;

@end

@implementation FARDicRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        [self declareVar:FAR_SELF_INS];
        [self setPropertyWithKey:FAR_SELF_INS value:self];
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (FARBaseObj *)propertyWithId:(NSString *)name {
    if ([name isEqualToString:FAR_ARRAY_DIC_GET] ||
        [name isEqualToString:FAR_ARRAY_DIC_SET]
        ) {
        FARDicFuncRunInstance *funcIns = [[FARDicFuncRunInstance alloc] initWithEnv:self.globalEnv stack:self.stack codeObj:self.codeObj vmCode:self.vmCode funcName:name dic:self.dic];
        funcIns.capturedEnvInstance = self;
        return funcIns;
    }
    return [super propertyWithId:name];
}



@end
