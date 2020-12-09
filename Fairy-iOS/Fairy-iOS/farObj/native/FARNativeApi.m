//
//  FARNativeApi.m
//  Fairy-iOS
//
//  Created by 周孙静 on 2020/12/2.
//

#import "FARNativeApi.h"
#import <UIKit/UIKit.h>
#import "UIGestureRecognizer+Fairy.h"
#import "FARObjectWrapper.h"
#import "FARFuncRunInstance.h"
#import "FARClassRunInstance.h"

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
    NSString *text = params[@"_raw_text"];
    FARLog(@"NativeLog: ------------------>     %@",text);
}

- (id)createInstance:(NSDictionary *)params {
    NSString *className = params[@"className"];
    Class cls = NSClassFromString(className);
    return [[cls alloc] init];
}

- (id)createStack:(NSDictionary *)params {
    UIStackView *stackView = [[UIStackView alloc] init];
    NSString *axis = params[@"axis"];
    if ([axis isEqualToString:@"hor"]) {
        stackView.axis = UILayoutConstraintAxisHorizontal;
    }else {
        stackView.axis = UILayoutConstraintAxisVertical;
    }
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    
    return stackView;
}

- (void)setStackBgColor:(NSDictionary *)params {
    UIStackView *stackView = params[@"obj"];
    UIColor *color = params[@"color"];
    //如果之前设置了背景色要先去掉
    if (stackView.tag) {
        stackView.tag = 0;
        UIView *bgView = stackView.subviews[0];
        [bgView removeFromSuperview];
    }
    stackView.tag = 1;
    UIView *bgView = [[UIView alloc] initWithFrame:stackView.bounds];
    bgView.backgroundColor = color;
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [stackView insertSubview:bgView atIndex:0];
}

- (void)setClickListener:(NSDictionary *)params {
    UIView *view = params[@"obj"];
    view.userInteractionEnabled = YES;
    FARObjectWrapper *wrapper = params[@"clickListener"];
    FARClassRunInstance *sender = params[@"_raw_sender"];
    
    UIGestureRecognizer *rec = [UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^(UITapGestureRecognizer* senderView) {
        [wrapper callWithParams:@{@"sender": sender}];
    }];
    
    [view addGestureRecognizer:rec];
    
}

- (void)setValue:(NSDictionary *)params {
    id obj = params[@"obj"];
    NSString *key = params[@"key"];
    id value = params[@"value"];
    [obj setValue:value forKey:key];
}

- (void)callFunc:(NSDictionary *)params {
    id obj = params[@"obj"];
    NSString *funcName = params[@"funcName"];
    SEL sel = NSSelectorFromString(funcName);
    [obj performSelector:sel];
}

- (void)addArrangedSubview:(NSDictionary *)params {
    UIStackView *obj = params[@"obj"];
    UIView *subview = params[@"subview"];
    [obj addArrangedSubview:subview];
}

- (void)setViewSize:(NSDictionary *)params {
    NSNumber *width = params[@"width"];
    NSNumber *height = params[@"height"];
    UIView *obj = params[@"obj"];
    [obj.widthAnchor constraintEqualToConstant:width.floatValue].active = YES;
    [obj.heightAnchor constraintEqualToConstant:height.floatValue].active = YES;
}

- (UIColor *)createColor:(NSDictionary *)params {
    NSString *hexStr = params[@"hex"];
    return [self.class colorFromHexString:hexStr];
}

- (UIImage *)createImage:(NSDictionary *)params {
    return [UIImage imageNamed:params[@"src"]];
}

- (void)setRadius:(NSDictionary *)params {
    UIView *view = params[@"obj"];
    NSNumber *radius = params[@"radius"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius.floatValue;
}

static NSString *const TextAlignmentCenter = @"TextAlignmentCenter";
static NSString *const TextAlignmentLeft = @"TextAlignmentLeft";
static NSString *const TextAlignmentRight = @"TextAlignmentRight";

- (void)setTextAlignment:(NSDictionary *)params {
    UILabel *label = params[@"obj"];
    NSString *aligment = params[@"textAlignment"];
    if ([aligment isEqualToString:TextAlignmentLeft]) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if ([aligment isEqualToString:TextAlignmentCenter]) {
        label.textAlignment = NSTextAlignmentCenter;
    }else if([aligment isEqualToString:TextAlignmentRight]) {
        label.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setTextSize:(NSDictionary *)params {
    UILabel *label = params[@"obj"];
    NSNumber *size = params[@"textSize"];
    label.font = [UIFont systemFontOfSize:size.floatValue];
}

- (void)setTextBold:(NSDictionary *)params {
    UILabel *label = params[@"obj"];
    NSNumber *bold = params[@"bold"];
    if ([bold boolValue]) {
        label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
    }else {
        label.font = [UIFont systemFontOfSize:label.font.pointSize];
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
