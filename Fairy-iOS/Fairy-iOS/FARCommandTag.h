//
//  FARCommandTag.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FARCommandTagType) {
    FARCommandTagTypeFuncStart,
    FARCommandTagTypeFuncEnd,
    FARCommandTagTypeFuncClassStart,
    FARCommandTagTypeFuncClassEnd,
    FARCommandTagTypeFuncClosureStart,
    FARCommandTagTypeFuncClosureEnd,
};

@interface FARCommandTag : NSObject

@property (nonatomic, copy) NSString *name;

+ (instancetype)tagWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
