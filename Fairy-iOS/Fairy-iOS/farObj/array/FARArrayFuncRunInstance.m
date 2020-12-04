//
//  FARArrayFuncRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/4.
//

#import "FARArrayFuncRunInstance.h"
#import "FARNumberCodeObj.h"

@interface FARArrayFuncRunInstance()

@property (nonatomic, copy) NSString *funcName;
@property (nonatomic, readwrite) NSMutableArray<FARBaseObj *> *array;

@end

@implementation FARArrayFuncRunInstance

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode funcName:(NSString *)funcName array:(NSMutableArray *)array{
    if (self = [super initWithEnv:env stack:stack codeObj:codeObj vmCode:vmCode]) {
        self.funcName = funcName;
        self.array = array;
    }
    return self;
}

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    FARBaseObj *selfObj = [self propertyWithId:FAR_SELF_INS];
    FARNumberRunInstance *indexObj = params[FAR_ARRAY_INDEX];
    NSUInteger index = indexObj.intergerValue;
    FARBaseObj *value = params[FAR_ARRAY_VALUE];
    if ([self.funcName isEqualToString:FAR_ARRAY_PUSH]) {
        [self.array addObject:value];
        [self.stack pushNull];
    }else if ([self.funcName isEqualToString:FAR_ARRAY_REMOVE]) {
        [self.array removeObjectAtIndex:index];
        [self.stack pushNull];
    }else if ([self.funcName isEqualToString:FAR_ARRAY_SET]) {
        self.array[index] = value;
        [self.stack pushNull];
    }else if ([self.funcName isEqualToString:FAR_ARRAY_GET]) {
        FARBaseObj *value = self.array[index];
        [self.stack push:value];
    }else if([self.funcName isEqualToString:FAR_ARRAY_PUSH_AT_INDEX]){
        [self.array insertObject:value atIndex:index];
        [self.stack pushNull];
    }else {
        @throw [NSException exceptionWithName:@"找不到方法" reason:nil userInfo:nil];
    }
    return nil;
}


@end
