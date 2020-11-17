//
//  FARVirtualMachine.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/17.
//

#import "FARVirtualMachine.h"
#import "FARParser.h"

@implementation FARVirtualMachine

- (void)runWithCode:(NSString *)code {
    FARParser *parser = [[FARParser alloc] init];
    FARVMCode *vmCode = [parser parse:code];
    NSLog(@">>>>开始跑咯");
}

@end
