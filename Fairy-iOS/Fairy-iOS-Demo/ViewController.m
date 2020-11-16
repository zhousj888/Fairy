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
    NSLog(@"11");
    FARParser *parser = [[FARParser alloc] init];
    NSLog(@"22");
    [parser parse];
    NSLog(@"33");
}


@end
