//
//  FARNativeApi.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import "FARNativeApi.h"
#import <UIKit/UIKit.h>

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

- (id)createInstance:(NSDictionary *)params {
    NSString *className = params[@"className"];
    Class cls = NSClassFromString(className);
    return [[cls alloc] init];
}

- (void)setValue:(NSDictionary *)params {
    id obj = params[@"obj"];
    NSString *key = params[@"key"];
    id value = params[@"value"];
    [obj setValue:value forKey:key];
}

- (void)addSubview:(NSDictionary *)params {
    UIView *obj = params[@"obj"];
    UIView *subview = params[@"subview"];
    [obj addSubview:subview];
}


@end
