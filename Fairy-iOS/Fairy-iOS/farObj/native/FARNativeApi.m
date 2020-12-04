//
//  FARNativeApi.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import "FARNativeApi.h"
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

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

- (UIColor *)createColor:(NSDictionary *)params {
    NSString *hexStr = params[@"hex"];
    return [self.class colorFromHexString:hexStr];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
