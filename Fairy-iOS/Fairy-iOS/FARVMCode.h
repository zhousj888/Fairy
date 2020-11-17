//
//  FARVMCode.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import "FARCommand.h"
#import "FARCommandTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARVMCode : NSObject

@property (nonatomic, strong) NSMutableArray<FARCommand *> *commandArr;
@property (nonatomic, strong) NSMutableArray<FARCommandTag *> *tagArr;

@end

NS_ASSUME_NONNULL_END
