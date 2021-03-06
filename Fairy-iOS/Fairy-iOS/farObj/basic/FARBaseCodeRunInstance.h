//
//  FARCodeRunInstance.h
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/28.
//

#import "FARBaseObj.h"
#import "FARCommand.h"
#import "FARVMStack.h"
#import "FARVMCode.h"

@class FARCodeObj;

NS_ASSUME_NONNULL_BEGIN

@interface FARBaseCodeRunInstance : FARBaseObj

@property (nonatomic, weak) FARBaseCodeRunInstance *callerInstance;
@property (nonatomic, weak) FARBaseCodeRunInstance *capturedEnvInstance;//被捕获的环境的宿主对象
@property (nonatomic, readonly) NSInteger currentSp;
@property (nonatomic, readwrite) FARVMStack *stack;
@property (nonatomic, strong) FARCodeObj *codeObj;
@property (nonatomic, weak) FARVMCode *vmCode;
@property (nonatomic, assign) BOOL isFuncFinished;//是不是没有return的跑完了所有代码
@property (nonatomic, assign) BOOL isRet;//是否已经runWithParams过

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;

- (nullable FARBaseObj *)runWithParams:(nullable NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
