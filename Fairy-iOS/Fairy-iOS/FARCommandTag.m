//
//  FARCommandTag.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARCommandTag.h"
#import "FAROperCmd.h"

@interface FARCommandTag()

@property (nonatomic, readwrite) FARCommandTagType type;

@end

@implementation FARCommandTag

+ (instancetype)tagWithName:(NSString *)name codeIndex:(NSInteger)codeIndex{
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    tag.codeIndex = codeIndex;
    return tag;
}

- (FARCommandTagType)type {
    if (_type == 0) {
        [self parseType];
    }
    return _type;
}

- (void)parseType {
    if ([self.name hasPrefix:@TAG_CLASS_BEGIN]) {
        self.type = FARCommandTagTypeClassBegin;
    }else if ([self.name hasPrefix:@TAG_CLASS_END]) {
        self.type = FARCommandTagTypeClassEnd;
    }else if ([self.name hasPrefix:@TAG_FUNC_START]) {
        self.type = FARCommandTagTypeFuncBegin;
    }else if ([self.name hasPrefix:@TAG_FUNC_END]) {
        self.type = FARCommandTagTypeFuncEnd;
    }else if ([self.name hasPrefix:@TAG_CLOSURE_BEGIN]) {
        self.type = FARCommandTagTypeClosureStart;
    }else if ([self.name hasPrefix:@TAG_CLOSURE_END]) {
        self.type = FARCommandTagTypeClosureEnd;
    }else if ([self.name hasPrefix:@TAG_WHILE_BEGIN]) {
        self.type = FARCommandTagTypeWhileBegin;
    }else if ([self.name hasPrefix:@TAG_WHILE_END]) {
        self.type = FARCommandTagTypeWhileEnd;
    }else if ([self.name hasPrefix:@TAG_CONTINUE]) {
        self.type = FARCommandTagTypeContinuePoint;
    }else if ([self.name hasPrefix:@TAG_IF_BEGIN]) {
        self.type = FARCommandTagTypeIfBegin;
    }else if ([self.name hasPrefix:@TAG_IF_END]) {
        self.type = FARCommandTagTypeIfEnd;
    }else if ([self.name hasPrefix:@TAG_IF_THEN]) {
        self.type = FARCommandTagTypeIfThen;
    }
}

@end
