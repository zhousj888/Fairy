//
//  FARCodeObj.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/21.
//

#import "FARBaseObj.h"
#import "FARBaseCodeRunInstance.h"

NS_ASSUME_NONNULL_BEGIN

@interface FARCodeObj : FARBaseObj

@property (nonatomic, strong) NSMutableArray<NSNumber*> *codeIndexArr;
@property (nonatomic, strong) NSMutableArray<FARCodeObj *> *codeObjArr;
@property (nonatomic, copy) NSString *name;

- (void)addCodeIndex:(NSInteger)codeIndex;
- (void)addSubCodeObj:(FARCodeObj *)subCodeObj;
- (FARBaseCodeRunInstance *)newRunInstanceWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;

@end

NS_ASSUME_NONNULL_END
