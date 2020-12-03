//
//  FARFunRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARFuncRunInstance.h"
#import "FARCodeObj.h"
#import "FARVMEnvironment.h"

@implementation FARFuncRunInstance


- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode {
    FARFuncRunInstance *runIns = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode];
    return runIns;
}

- (void)setPropertyWithKey:(NSString *)key value:(FARBaseObj *)value {
    if ([self.env findVarForKey:key]) {
        [self.env setVar:value key:key];
    }else {
        [self.capturedEnvInstance setPropertyWithKey:key value:value];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<func: %@>", self.codeObj.name];
}

@end
