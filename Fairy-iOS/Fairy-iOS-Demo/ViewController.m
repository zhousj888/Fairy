//
//  ViewController.m
//  Fairy-iOS-Demo
//
//  Created by 周孙静 on 2020/11/16.
//

#import "ViewController.h"
#import <Fairy_iOS/Fairy_iOS.h>

@interface ViewController ()

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
    
    UIView *view;
    [view removeFromSuperview];
    [view superview];
}


@end
