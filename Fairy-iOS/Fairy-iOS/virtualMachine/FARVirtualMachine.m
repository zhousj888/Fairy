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

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) FARVMStack *stack;
@property (nonatomic, strong) FARVMEnvironment *codeEnv;
@property (nonatomic, strong) FARVMEnvironment *mainEnv;
@property (nonatomic, assign) BOOL isExit;

@end

@implementation FARVirtualMachine

- (void)dealloc {
    [self.stack destroy];
    [self.codeEnv destroy];
    [self.mainEnv destroy];
    NSLog(@"FARVirtualMachine dealloc");
}

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *rawCode = [parser parse:code withFileName:@"userCode"];
    FARVMCode *internalCode = [self generInternalCode];
    
    FARVMCode *linkedCode = [FARVMCode linkCode:internalCode code2:rawCode];
    
    self.vmCode = linkedCode;
    [self prepare];
    [self run];
}

- (FARVMCode *)generInternalCode {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:@"internalScript" ofType:@"far"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *code = [parser parse:content withFileName:@"interbalScript"];
    return code;
}

- (void)prepare {
    self.codeEnv = [[FARVMCodeEnv alloc] initWithVMCode:self.vmCode];
    self.mainEnv = [[FARVMEnvironment alloc] initWithOuter:self.codeEnv];
    self.stack = [[FARVMStack alloc] init];
    self.isExit = NO;
}

- (void)run {
    FARLog(@"-------------------👇是执行信息----------------------------");
    FARFuncCodeObj *mainCode = (FARFuncCodeObj *)[self.mainEnv findVarForKey:FAR_MAIN_CODE];
    FARBaseCodeRunInstance *mainRunInstance = [mainCode newRunInstanceWithEnv:self.mainEnv stack:self.stack vmCode:self.vmCode];
    //这里做一个特殊逻辑，mainCode里面的env就是global
    mainRunInstance.env = self.mainEnv;
    [mainRunInstance runWithParams:nil];
}

- (id)vmRetValue {
    return self.stack.peek.toNativeObj;
}

- (id)vmValueForKey:(NSString *)key {
    return [self.mainEnv findVarForKey:key].toNativeObj;
}

@end
