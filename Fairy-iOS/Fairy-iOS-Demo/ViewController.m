//
//  ViewController.m
//  Fairy-iOS-Demo
//
//  Created by 周孙静 on 2020/11/16.
//

#import "ViewController.h"
#import <Fairy_iOS/Fairy_iOS.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (nonatomic, strong) UIView *vmView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.container.layer.borderWidth = 1;
    self.container.layer.borderColor = [UIColor blueColor].CGColor;
    [self.updateButton addTarget:self action:@selector(hotReload) forControlEvents:UIControlEventTouchUpInside];
    [self loadVMView];
}

- (void)hotReload {
    for (UIView *sub in self.container.subviews) {
        [sub removeFromSuperview];
    }
    [self loadVMView];
}

- (void)loadVMView {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"far"];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                      error:NULL];
    FARVirtualMachine *vm = [[FARVirtualMachine alloc] init];
    [vm runWithCode:content];
    
    self.vmView = [vm vmValueOfStackTop];
    [self.container addSubview:self.vmView];
//    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillLayoutSubviews {
    self.vmView.frame = self.container.bounds;
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
