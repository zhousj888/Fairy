//
//  FARVirtualMachine.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVirtualMachine.h"
#import "FARParser.h"
#import "FARVMEnvironment.h"
#import "FARVMCodeEnv.h"
#import "FARCodeObj.h"
#import "FARFuncCodeObj.h"
#import "FARFuncRunInstance.h"


static NSString *const kRetPc = @"__retPc";
static NSString *const kRetSp = @"__retSp";

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) FARVMStack *stack;
@property (nonatomic, strong) FARVMEnvironment *codeEnv;
@property (nonatomic, strong) FARVMEnvironment *mainEnv;
@property (nonatomic, assign) BOOL isExit;

@end

@implementation FARVirtualMachine

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *vmCode = [parser parse:code];
    [vmCode.commandArr addObject:[FARCommand commandWithCmd:FAROperExit line:0]];
    
    self.vmCode = vmCode;
    [self prepare];
    [self run];
}

- (void)prepare {
    self.codeEnv = [[FARVMCodeEnv alloc] initWithVMCode:self.vmCode];
    self.mainEnv = [[FARVMEnvironment alloc] initWithOuter:self.codeEnv];
    self.stack = [[FARVMStack alloc] init];
    self.isExit = NO;
}

- (void)run {
    FARFuncCodeObj *mainCode = (FARFuncCodeObj *)[self.mainEnv findVarForKey:FAR_MAIN_CODE];
    FARBaseCodeRunInstance *mainRunInstance = [mainCode newRunInstanceWithEnv:self.mainEnv stack:self.stack vmCode:self.vmCode];
    [mainRunInstance runWithParams:nil];
    
    
}

@end
