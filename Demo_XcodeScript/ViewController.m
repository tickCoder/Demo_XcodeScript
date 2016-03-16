//
//  ViewController.m
//  Demo_XcodeScript
//
//  Created by Claris on 2016.03.16.Wednesday.
//  Copyright © 2016 tickCoder. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _infoLabel.text = @"-";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSString *build = infoDict[@"CFBundleVersion"];
    NSString *gitVersion = infoDict[@"GITHash"];
    
    NSMutableString *labelStr = [[NSMutableString alloc] init];
    [labelStr appendFormat:@"version: %@\n", version];
    [labelStr appendFormat:@"build: %@\n", build];
    [labelStr appendFormat:@"gitVersion: %@\n", gitVersion];
    _infoLabel.text = labelStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
