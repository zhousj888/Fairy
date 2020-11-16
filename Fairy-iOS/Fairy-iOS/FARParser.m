//
//  FARParser.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/16.
//

#import "FARParser.h"
#include "y.tab.h"

int yyparse (void);
void* yy_scan_string (const char * yystr);

@implementation FARParser

- (void)parse:(NSString *)code {
    yy_scan_string(code.UTF8String);
    yyparse();
}


@end
