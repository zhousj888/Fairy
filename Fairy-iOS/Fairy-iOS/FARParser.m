//
//  FARParser.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import "FARParser.h"
#include "y.tab.h"
#include "FAROperCmd.h"

int yyparse (void);
void* yy_scan_string (const char * yystr);

void addCmd0(int cmd) {
    NSLog(@">>>>>>>>add cmd = %@",@(FAROperCmdAdd));
}

void addCmd1(int cmd, char *oper1) {
    NSLog(@">>>>>>>>add cmd = %@,%s",@(cmd),oper1);
}

@implementation FARParser

- (void)parse:(NSString *)code {
    yy_scan_string(code.UTF8String);
    yyparse();
}


@end
