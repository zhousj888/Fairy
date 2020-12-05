//
//  FARClassRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARClassRunInstance.h"
#import "FARFuncRunInstance.h"
#import "FARVMEnvironment.h"

@implementation FARClassRunInstance



- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARBaseObj *baseObj = [super propertyWithId:name];
    
    if (baseObj) {
        return baseObj;
    }
    
    //这里可能是找类里面的方法找不到
    //func.name = className:superClassName_funcName = tag.rawName
    NSMutableString *funcName = [NSMutableString string];
    [funcName appendString:self.classCodeObj.name];
    if (self.classCodeObj.superName) {
        [funcName appendFormat:@":%@",self.classCodeObj.superName];
    }
    [funcName appendFormat:@"_%@",name];
    
    baseObj = [super propertyWithId:funcName];
    if ([baseObj isKindOfClass:[FARFuncRunInstance class]]) {
        //如果是从对象获取到方法对象，将自己作为环境宿主注入
        ((FARFuncRunInstance *)baseObj).capturedEnvInstance = self;
    }
    
    if (baseObj) {
        return baseObj;
    }
    
    //以上是在子类里面找，子类里面找不到从父类里面找
    return [self.superInstance propertyWithId:name];
    
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    NSLog(@"init start %@", self);
    
    [self initContentWithSelfObj:self params:params];
    
    [self.stack push:self];
    NSLog(@"init end %@", self);
    return nil;
}

- (FARBaseObj *)initContentWithSelfObj:(FARBaseObj *)selfObj params:(NSDictionary *)params {
    //先将父类初始化好
    if (self.classCodeObj.superName) {
        self.superInstance = (FARClassRunInstance *)[self propertyWithId:self.classCodeObj.superName];
        if (!self.superInstance) {
            @throw [NSException exceptionWithName:@"父类找不到" reason:nil userInfo:nil];
        }
        [self declareVar:FAR_SUPER_INS];
        [self setPropertyWithKey:FAR_SUPER_INS value:self.superInstance];
        [self.superInstance initContentWithSelfObj:selfObj params:params];
    }
    
    [self declareVar:FAR_SELF_INS];
    [self setPropertyWithKey:FAR_SELF_INS value:selfObj];
    
    [super runWithParams:params];
    
    NSInteger origSp = self.currentSp;
    //调用init方法
    FARFuncRunInstance *initFunc = (FARFuncRunInstance *)[self propertyWithId:FAR_INIT_FUNC];
    initFunc.capturedEnvInstance = self;
    if (initFunc) {
        [initFunc runWithParams:params];
        [self.stack popTo:origSp];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<obj:%@,%p>", self.codeObj.name, self];
}


@end
