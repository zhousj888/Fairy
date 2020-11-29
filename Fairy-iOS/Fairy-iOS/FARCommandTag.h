//
//  FARCommandTag.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FARCommandTagType) {
    FARCommandTagTypeFuncBegin = 1,
    FARCommandTagTypeFuncEnd,
    FARCommandTagTypeClassBegin,
    FARCommandTagTypeClassEnd,
    FARCommandTagTypeClosureStart,
    FARCommandTagTypeClosureEnd,
    FARCommandTagTypeWhileBegin,
    FARCommandTagTypeWhileEnd,
    FARCommandTagTypeContinuePoint,
    FARCommandTagTypeIfBegin,
    FARCommandTagTypeIfEnd,
    FARCommandTagTypeIfThen,
};

@interface FARCommandTag : NSObject

@property (nonatomic, readonly) FARCommandTagType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger codeIndex;//指向这个tag的第一条指令

- (nullable NSString *)pairsEndName;
+ (instancetype)tagWithName:(NSString *)name codeIndex:(NSInteger)codeIndex;

@end

NS_ASSUME_NONNULL_END
