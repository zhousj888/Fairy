//
//  FARVMEnvironment.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/18.
//

#import "FARVMEnvironment.h"
#import "FARNull.h"

@interface FARVMEnvironment()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FARBaseObj *> *envDic;

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


- (FARBaseObj *)findVarForKey:(NSString *)key {
    if (self.envDic[key]) {
        return self.envDic[key];
    }
    return [self.outer findVarForKey:key];
}

- (void)setVar:(FARBaseObj *)value key:(NSString *)key {
    
    if (self.envDic[key]) {
        self.envDic[key] = value;
    }else if(self.outer){
        [self.outer setVar:value key:key];
    }else {
        @throw [NSException exceptionWithName:@"找不到对象" reason:nil userInfo:nil];
    }
    
}

- (void)declareVar:(NSString *)key withGlobalEnv:(nonnull FARVMEnvironment *)globalEnv withStack:(nonnull FARVMStack *)stack{
    self.envDic[key] = [FARNull nullWithEnv:globalEnv stack:stack];
}



- (NSDictionary *)asParams {
    return self.envDic;
}

- (void)addParams:(NSDictionary *)params {
    [self.envDic addEntriesFromDictionary:params];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<环境:%@>", self.envDic];
}


@end
