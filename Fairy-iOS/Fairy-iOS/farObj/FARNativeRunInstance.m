//
//  FARNativeRunInstance.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/11/29.
//

#import "FARNativeRunInstance.h"

@implementation FARNativeRunInstance

- (FARBaseObj *)runWithParams:(NSDictionary *)params {
    NSLog(@"NativeLog----------%@",params[@"text"]);
    return nil;
}

@end
