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
@property (nonatomic, strong) id Oper1;
@property (nonatomic, strong) id Oper2;
@property (nonatomic, strong) id Oper3;
@property (nonatomic, strong) id Oper4;
@property (nonatomic, strong) id Oper5;

@end

NS_ASSUME_NONNULL_END
