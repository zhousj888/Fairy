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
@property (nonatomic, assign) FARCommandTagType type;
//class
@property (nonatomic, copy) NSString *superClassName;

+ (instancetype)funcTagWithName:( NSString * _Nullable ) name isStart:(BOOL)isStart;
+ (instancetype)classTagWithName:( NSString * _Nullable )name superClassName:( NSString * _Nullable )superClassName isStart:(BOOL)isStart;
+ (instancetype)closureTagWithName:(NSString * _Nullable)name isStart:(BOOL)isStart;

@end

NS_ASSUME_NONNULL_END
