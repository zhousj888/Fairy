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


static NSString *const kRetPc = @"__retPc";
static NSString *const kRetSp = @"__retSp";

@interface FARVirtualMachine()

@property (nonatomic, strong) FARVMCode *vmCode;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) FARVMEnvironment *codeEnv;
@property (nonatomic, strong) FARVMEnvironment *mainEnv;
@property (nonatomic, strong) FARVMEnvironment *currentEnv;
@property (nonatomic, assign) NSInteger pc;
@property (nonatomic, assign) NSInteger sp;
@property (nonatomic, assign) BOOL isExit;

@end

@implementation FARVirtualMachine

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *vmCode = [parser parse:code];
    [vmCode.commandArr addObject:[FARCommand commandWithCmd:FAROperExit]];
    vmCode.tagDic[@"__log"] = [FARCommandTag tagWithName:@"__log" codeIndex:-110];
    
    
    self.vmCode = vmCode;
    [self prepare];
//    [self run];
}

- (void)prepare {
    self.codeEnv = [[FARVMCodeEnv alloc] initWithVMCode:self.vmCode];
    self.mainEnv = [[FARVMEnvironment alloc] initWithOuter:self.codeEnv];
    self.stack = [NSMutableArray array];
    self.currentEnv = self.mainEnv;
    self.pc = 0;
    self.sp = 0;
    self.isExit = NO;
}

- (void)run {
    while (!self.isExit) {
        FARCommand *cmd = self.vmCode.commandArr[self.pc];
        NSLog(@"pc = %@",@(self.pc));
        NSLog(@"excute cmd: %@",cmd);
        if ([self executeCmd:cmd]) {
            self.pc++;
        }
        [self printStack];
    }
}

- (BOOL)executeCmd:(FARCommand *)cmd {
    return NO;
}

- (id)pop {
    id lastObj = self.stack.lastObject;
    [self.stack removeLastObject];
    return lastObj;
}

- (void)push:(id)value {
    if (value) {
        [self.stack addObject:value];
    }
}

- (BOOL)isNumber:(NSString *)str {
    if ([str integerValue] || [str doubleValue] || [str isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isStringConst:(NSString *)str {
    if ([str hasPrefix:@"\""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isZero:(id)value {
    if ([value isEqual:@"0"] || [value isEqual:@(0)]) {
        return YES;
    }
    return NO;
}

- (void)jmp:(NSString *)tag {
    FARCodeObj *codeObj = (FARCodeObj *)[self.currentEnv findVarForKey:tag];
//    [self jmpToIndex:[codeObj codeIndex]];
}

- (void)jmpToIndex:(NSInteger)index {
    if (index >= 0) {
        self.pc = index;
    }else if(index == -110){
        NSLog(@"__log: ------------------------>%@",[self.currentEnv findVarForKey:@"text"]);
        self.pc++;
    }else {
        self.isExit = YES;
        NSLog(@"jmp to %@ failed",@(index));
    }
}

- (void)printStack {
    NSMutableString *mutStr = [NSMutableString string];
    for(id stackEle in self.stack) {
        [mutStr appendFormat:@"%@,",stackEle];
    }
    NSLog(@"stack:%@",mutStr);
}





- (NSInteger)sp {
    return self.stack.count;
}

- (void)setSp:(NSInteger)sp {
    while (sp < self.stack.count) {
        [self.stack removeLastObject];
    }
}


@end
