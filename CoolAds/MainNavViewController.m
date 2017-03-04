//
//  MainNavViewController.m
//  AdvertPS
//
//  Created by Pongsak Srithongnopawong on 7/2/2559 BE.
//  Copyright © 2559 Pongsak Srithongnopawong. All rights reserved.
//

#import "MainNavViewController.h"
//#import "PageContentViewController.h"
#import "AvViewController.h"
#import "ImgViewController.h"
#import "ViewController.h"
#import "PLPConfig.h"
#import "WebViewController.h"

@interface MainNavViewController ()

@end

@implementation MainNavViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_avVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AvViewController"];
    
    //_pvcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PvcViewController"];
    _imgVC = [[ImgViewController alloc]init];
    _avVC = [[AvViewController alloc]init];
    
    [self setViewControllers:[NSArray arrayWithObjects:_imgVC, _avVC, nil]];
    
    [self.navigationBar setHidden:YES];
    //[self setViewControllers:[NSArray arrayWithObject:_avVC]];
    
    // for testing
    //[self setViewControllers:[NSArray arrayWithObject:_pvcVC]];
    
    
    _webController = [[WebViewController alloc] init];
    _webview=[[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _webController.view = _webview;
    _webController.mainNav = self;
    
    _imgVC.webController = _webController;
    _imgVC.webview = _webview;
    _avVC.webController = _webController;
    _avVC.webview = _webview;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [_webview addGestureRecognizer:tap];
    
}

- (void) flip {
    NSLog(@"flipped");
    [_webController flip];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
