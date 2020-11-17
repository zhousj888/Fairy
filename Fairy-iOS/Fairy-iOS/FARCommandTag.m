//
//  FARCommandTag.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARCommandTag.h"

@implementation FARCommandTag

+ (instancetype)funcTagWithName:(NSString *)name isStart:(BOOL)isStart {
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    tag.type = isStart ? FARCommandTagTypeFuncStart : FARCommandTagTypeFuncEnd;
    return tag;
}


+ (instancetype)classTagWithName:(NSString *)name superClassName:(NSString *)superClassName isStart:(BOOL)isStart {
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    tag.superClassName = superClassName;
    tag.type = isStart ? FARCommandTagTypeFuncClassStart : FARCommandTagTypeFuncClassEnd;
    return tag;
}

+ (instancetype)closureTagWithName:(NSString *)name isStart:(BOOL)isStart {
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    tag.type = isStart ? FARCommandTagTypeFuncClosureStart : FARCommandTagTypeFuncClosureEnd;
    return tag;
}

@end
