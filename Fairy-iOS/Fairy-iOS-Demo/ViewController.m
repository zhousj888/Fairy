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
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
@property (nonatomic, strong) FARVirtualMachine *vm;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.container.layer.borderWidth = 1;
    self.container.layer.borderColor = [UIColor blueColor].CGColor;
    [self.updateButton addTarget:self action:@selector(hotReload) forControlEvents:UIControlEventTouchUpInside];
    [self.cleanButton addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    [self loadVMView];
}

- (void)clean {
    for (UIView *sub in self.container.subviews) {
        [sub removeFromSuperview];
    }
    self.vm = nil;
    self.vmView = nil;
}

- (void)hotReload {
    for (UIView *sub in self.container.subviews) {
        [sub removeFromSuperview];
    }
    [self loadVMView];
}

- (void)loadVMView {
    NSString *filePath = [NSString stringWithUTF8String:__FILE__];
    NSRange range = [filePath rangeOfString:@"ViewController.m"];
    
    NSString *pathPrefix = [filePath substringToIndex:range.location];
    NSString *path = [NSString stringWithFormat:@"%@test.far", pathPrefix];
    
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                      error:NULL];
    self.vm = [[FARVirtualMachine alloc] init];
    [self.vm runWithCode:content];
    
    self.vmView = [self.vm vmRetValue];
    [self.container addSubview:self.vmView];
    
}

- (void)viewWillLayoutSubviews {
    self.vmView.frame = self.container.bounds;
}


@end
