//
//  FARVMEnvironment.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import "FARVMEnvironment.h"
#import "FARNull.h"

@interface FARVMEnvironment()

@property (nonatomic, strong) NSMutableDictionary *envDic;

@end

@implementation FARVMEnvironment

- (instancetype)init {
    return [self initWithOuter:nil];
}

- (instancetype)initWithOuter:(FARVMEnvironment *)outer {
    self = [super init];
    if (self) {
        _envDic = [NSMutableDictionary dictionary];
        _outer = outer;
    }
    return self;
}


- (id)findVarForKey:(NSString *)key {
    if (self.envDic[key]) {
        return self.envDic[key];
    }
    return [self.outer findVarForKey:key];
}

- (void)setVar:(id)value key:(NSString *)key {
    self.envDic[key] = value;
}

- (void)declareVar:(NSString *)key {
    [self setVar:[FARNull null] key:key];
}

- (void)declareLet:(NSString *)key {
    [self setVar:[FARNull null] key:key];
}


@end
