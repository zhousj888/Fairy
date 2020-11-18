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
@property (nonatomic, strong) NSString *oper1;
@property (nonatomic, strong) NSString *oper2;
@property (nonatomic, strong) NSString *oper3;
@property (nonatomic, strong) NSString *oper4;
@property (nonatomic, strong) NSString *oper5;

+ (instancetype)commandWithCmd:(NSInteger)cmd;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper:(NSString *)oper;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(NSString *)oper1 oper2:(NSString *)oper2;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(NSString *)oper1 oper2:(NSString *)oper2 oper3:(NSString *)oper3;


@end

NS_ASSUME_NONNULL_END
