//
//  FARDicFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARDicFuncRunInstance.h"
#import "FARStringRunInstance.h"


@interface FARDicFuncRunInstance()

@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, readwrite) NSMutableDictionary *dic;

@end

@implementation FARDicFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName dic:(nonnull NSMutableDictionary *)dic{
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        self.funcName = funcName;
        _dic = dic;
    }
    return self;
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARStringRunInstance *keyObj = params[FAR_DIC_KEY];
    NSString *key = keyObj.value;
    FARBaseObj *value = params[FAR_ARRAY_DIC_VALUE];
    if ([self.funcName isEqualToString:FAR_ARRAY_DIC_SET]) {
        self.dic[key] = value;
        [self.stack pushNullWithEnv:self.globalEnv];
    }else if ([self.funcName isEqualToString:FAR_ARRAY_DIC_GET]) {
        FARBaseObj *value = self.dic[key];
        [self.stack push:value];
    }else {
        @throw [NSException exceptionWithName:@"找不到方法" reason:nil userInfo:nil];
    }
    return nil;
}



@end
