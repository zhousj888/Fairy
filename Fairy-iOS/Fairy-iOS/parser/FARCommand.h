//
//  FARCommand.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "FAROperCmd.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARCommand : NSObject

@property (nonatomic, assign) NSInteger operCmd;
@property (nonatomic, copy) NSString *oper1;
@property (nonatomic, copy) NSString *oper2;
@property (nonatomic, copy) NSString *oper3;
@property (nonatomic, copy) NSString *oper4;
@property (nonatomic, copy) NSString *oper5;
@property (nonatomic, assign) NSInteger line;
@property (nonatomic, copy) NSString *fileName;

+ (instancetype)commandWithCmd:(NSInteger)cmd line:(NSInteger)line fileName:(NSString *)fileName;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper:(nullable NSString *)oper line:(NSInteger)line fileName:(NSString *)fileName;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(nullable NSString *)oper1 oper2:(nullable NSString *)oper2 line:(NSInteger)line fileName:(NSString *)fileName;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(nullable NSString *)oper1 oper2:(nullable NSString *)oper2 oper3:(nullable NSString *)oper3 line:(NSInteger)line fileName:(NSString *)fileName;


@end

NS_ASSUME_NONNULL_END
