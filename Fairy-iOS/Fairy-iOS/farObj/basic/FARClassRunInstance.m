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


//从self指向的对象开始找属性，沿着继承链往上找
- (FARBaseObj *)propertyWithId:(NSString *)name {
    FARClassRunInstance *selfObj = (FARClassRunInstance *)[super propertyWithId:FAR_SELF_INS];
    if (self != selfObj) {
        return [selfObj findPropertyWithName:name];
    }else {
        return [self findPropertyWithName:name];
    }
}

//从当前类开始找属性，没有就从父类找
- (FARBaseObj *)findPropertyWithName:(NSString *)name {
    FARBaseObj *baseObj = [self findPropertyInCurrentClass:name];
    if (baseObj) {
        return baseObj;
    }
    return [self.superInstance findPropertyWithName:name];
}

- (FARBaseObj *)findPropertyInCurrentClass:(NSString *)name {
    
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
    
    return baseObj;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    FARLog(@"init start %@", self);
    
    [self initContentWithSelfObj:self params:params];
    
    [self.stack push:self];
    FARLog(@"init end %@", self);
    return nil;
}

- (void)initContentWithSelfObj:(FARBaseObj *)selfObj params:(NSDictionary *)params {
    //先将父类初始化好
    
    [self declareVar:FAR_SELF_INS];
    [self setPropertyWithKey:FAR_SELF_INS value:selfObj];
    
    if (self.classCodeObj.superName) {
        self.superInstance = (FARClassRunInstance *)[self findPropertyInCurrentClass:self.classCodeObj.superName];
        if (!self.superInstance) {
            @throw [NSException exceptionWithName:@"父类找不到" reason:nil userInfo:nil];
        }
        [self declareVar:FAR_SUPER_INS];
        [self setPropertyWithKey:FAR_SUPER_INS value:self.superInstance];
        [self.superInstance initContentWithSelfObj:selfObj params:params];
    }
    
    
    [super runWithParams:params];
    
    NSInteger origSp = self.currentSp;
    //调用init方法
    FARFuncRunInstance *initFunc = (FARFuncRunInstance *)[self findPropertyInCurrentClass:FAR_INIT_FUNC];
    initFunc.capturedEnvInstance = self;
    if (initFunc) {
        [initFunc runWithParams:params];
        [self.stack popTo:origSp];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<obj:%@,%p>", self.codeObj.name, self];
}


@end
