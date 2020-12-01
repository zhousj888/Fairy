//
//  FARClassRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARClassRunInstance.h"
#import "FARFunRunInstance.h"

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
    if ([baseObj isKindOfClass:[FARFunRunInstance class]]) {
        //如果是从对象获取到方法对象，将自己作为环境宿主注入
        ((FARFunRunInstance *)baseObj).capturedEnvInstance = self;
    }
    
    if (baseObj) {
        return baseObj;
    }
    
    //以上是在子类里面找，子类里面找不到从父类里面找
    return [self.superInstance propertyWithId:name];
    
}


- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    
    if (self.classCodeObj.superName) {
        self.superInstance = [self propertyWithId:self.classCodeObj.superName];
        [self.superInstance runWithParams:params];
        [self.stack pop];
    }
    
    
    [super runWithParams:params];
    [self.stack push:self];
    return nil;
}


@end
