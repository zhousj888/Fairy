//
//  FARCommandTag.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARCommandTag.h"

@implementation FARCommandTag

+ (instancetype)tagWithName:(NSString *)name {
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    return tag;
}

@end
