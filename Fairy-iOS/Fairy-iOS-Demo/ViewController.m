//
//  ViewController.m
//  Fairy-iOS-Demo
//
//  Created by 周孙静 on 2020/11/16.
//

#import "ViewController.h"
#import <Fairy_iOS/Fairy_iOS.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *Container;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test"
                                                     ofType:@"far"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                      error:NULL];
    FARVirtualMachine *vm = [[FARVirtualMachine alloc] init];
    [vm runWithCode:content];
    
    UIView *view = [vm vmValueOfStackTop];
    [self.Container addSubview:view];
    view.frame = self.Container.bounds;
    
}

- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor*color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
    return [UIColor clearColor];
    
}


@end
