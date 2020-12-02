//
//  FARNativeApi.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import "FARNativeApi.h"

@implementation FARNativeApi


+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)log:(NSDictionary *)params {
    NSString *text = params[@"text"];
    NSLog(@"NativeLog: ------------------>     %@",text);
}


@end
