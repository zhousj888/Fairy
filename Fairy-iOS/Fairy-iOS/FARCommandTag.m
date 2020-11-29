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
@property (nonatomic, copy, readwrite) NSString *pairsEndName;
@property (nonatomic, copy, readwrite) NSString *rawName;

@end

@implementation FARCommandTag

+ (instancetype)tagWithName:(NSString *)name codeIndex:(NSInteger)codeIndex{
    FARCommandTag *tag = [[FARCommandTag alloc] init];
    tag.name = name;
    tag.codeIndex = codeIndex;
    [tag parse];
    return tag;
}

- (void)parse {
    if ([self.name hasPrefix:@TAG_CLASS_BEGIN]) {
        _type = FARCommandTagTypeClassBegin;
        NSString *currentPrefix = @TAG_CLASS_BEGIN;
        NSString *endPrefix = @TAG_CLASS_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
        _pairsEndName = [NSString stringWithFormat:@"%@%@",endPrefix,_rawName];
    }else if ([self.name hasPrefix:@TAG_CLASS_END]) {
        _type = FARCommandTagTypeClassEnd;
        NSString *currentPrefix = @TAG_CLASS_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_FUNC_START]) {
        _type = FARCommandTagTypeFuncBegin;
        NSString *currentPrefix = @TAG_FUNC_START;
        NSString *endPrefix = @TAG_FUNC_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
        _pairsEndName = [NSString stringWithFormat:@"%@%@",endPrefix,_rawName];
    }else if ([self.name hasPrefix:@TAG_FUNC_END]) {
        _type = FARCommandTagTypeFuncEnd;
        NSString *currentPrefix = @TAG_FUNC_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_CLOSURE_BEGIN]) {
        _type = FARCommandTagTypeClosureStart;
        NSString *currentPrefix = @TAG_CLOSURE_BEGIN;
        NSString *endPrefix = @TAG_CLOSURE_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
        _pairsEndName = [NSString stringWithFormat:@"%@%@",endPrefix,_rawName];
    }else if ([self.name hasPrefix:@TAG_CLOSURE_END]) {
        _type = FARCommandTagTypeClosureEnd;
        NSString *currentPrefix = @TAG_CLOSURE_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_WHILE_BEGIN]) {
        _type = FARCommandTagTypeWhileBegin;
        NSString *currentPrefix = @TAG_WHILE_BEGIN;
        NSString *endPrefix = @TAG_WHILE_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
        _pairsEndName = [NSString stringWithFormat:@"%@%@",endPrefix,_rawName];
    }else if ([self.name hasPrefix:@TAG_WHILE_END]) {
        _type = FARCommandTagTypeWhileEnd;
        NSString *currentPrefix = @TAG_WHILE_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_CONTINUE]) {
        _type = FARCommandTagTypeContinuePoint;
        NSString *currentPrefix = @TAG_CONTINUE;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_IF_BEGIN]) {
        _type = FARCommandTagTypeIfBegin;
        NSString *currentPrefix = @TAG_IF_BEGIN;
        NSString *endPrefix = @TAG_IF_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
        _pairsEndName = [NSString stringWithFormat:@"%@%@",endPrefix,_rawName];
    }else if ([self.name hasPrefix:@TAG_IF_END]) {
        _type = FARCommandTagTypeIfEnd;
        NSString *currentPrefix = @TAG_IF_END;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }else if ([self.name hasPrefix:@TAG_IF_THEN]) {
        _type = FARCommandTagTypeIfThen;
        NSString *currentPrefix = @TAG_IF_THEN;
        _rawName = [self.name substringFromIndex:currentPrefix.length];
    }
}

@end
