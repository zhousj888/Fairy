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

@interface FARVMCode : NSObject<NSMutableCopying>

@property (nonatomic, strong) NSMutableArray<FARCommand *> *commandArr;
@property (nonatomic, strong) NSMutableDictionary<NSString *, FARCommandTag *> *tagDic;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<FARCommandTag *>*> *tagIndexDic;

- (void)printCode;
+ (FARVMCode *)linkCode:(FARVMCode *)code1 code2:(FARVMCode *)code2;

@end

NS_ASSUME_NONNULL_END
