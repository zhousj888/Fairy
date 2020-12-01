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
@property (nonatomic, strong) FARVMCode *vmCode;

- (instancetype)initWithEnv:(FARVMEnvironment *)env stack:(FARVMStack *)stack codeObj:(FARCodeObj *)codeObj vmCode:(FARVMCode *)vmCode;

- (nullable FARBaseObj *)runWithParams:(nullable NSDictionary *)params;
- (void)resume;

//以下方法只能子类调用
- (BOOL)_executeCmd:(FARCommand *)cmd;

@end

NS_ASSUME_NONNULL_END