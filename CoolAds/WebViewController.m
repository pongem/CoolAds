//
//  WebViewController.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/18/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "WebViewController.h"
#import "MainNavViewController.h"
#import "PLPConfig.h"
#import "ViewController.h"
#import "ImgViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_interval = 30;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Web View Did appear");
    _interval = 30;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval
                                     target:self
                                   selector:@selector(timeImgRun)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController) {
        [_mainNav.webview loadHTMLString: @"" baseURL: nil];
    }
}

- (void) timeImgRun {
    NSLog(@"Web delay img run");
    [_mainNav.imgVC setStop:NO];
    [_mainNav.pvcVC imgRun];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) flip {
    
    NSLog(@"Reset timer");
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval
                                              target:self
                                            selector:@selector(timeImgRun)
                                            userInfo:nil
                                             repeats:NO];
}

/*
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Reset timer");
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval
                                              target:self
                                            selector:@selector(timeImgRun)
                                            userInfo:nil
                                             repeats:NO];
    
}*/

@end
