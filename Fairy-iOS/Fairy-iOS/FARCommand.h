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
@property (nonatomic, strong) id oper1;
@property (nonatomic, strong) id oper2;
@property (nonatomic, strong) id oper3;
@property (nonatomic, strong) id oper4;
@property (nonatomic, strong) id oper5;

+ (instancetype)commandWithCmd:(NSInteger)cmd;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper:(id)oper;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(id)oper1 oper2:(id)oper2;
+ (instancetype)commandWithCmd:(NSInteger)cmd oper1:(id)oper1 oper2:(id)oper2 oper3:(id)oper3;


@end

NS_ASSUME_NONNULL_END
