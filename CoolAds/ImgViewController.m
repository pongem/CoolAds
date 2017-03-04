//
//  ImgViewController.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/13/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "ImgViewController.h"
#import "WebViewController.h"
#import "MainNavViewController.h"
#import "PLPConfig.h"

@interface ImgViewController ()

@end

@implementation ImgViewController

- (void)viewDidLoad {
    
    NSLog(@"Img View Did Load");
    
    [super viewDidLoad];
    
    _stop = NO;
    
    //_imgIndex = 0;
    
    // Do any additional setup after loading the view.
    _mainNav = (MainNavViewController *) self.parentViewController;
    _imgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (_imgData)
        _imgView.image=[UIImage imageWithData:_imgData];
    [self.view addSubview:_imgView];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //_imgView.image=[UIImage imageWithData:_imgData];
    //[self.view addSubview:_imgView];
    
    
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

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[_mainNav pushViewController:((UIViewController *) _mainNav.pvcVC) animated:false];
    NSLog(@"Touch Media");

    NSString *url = [_mainNav.config readWebUrl];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _webController.url = nsurl;
    //if(!_webController.url) {
        [_webview loadRequest:nsrequest];
    ///}
    _stop = YES;
    
    [_mainNav pushViewController:_webController animated:NO];
    
}

@end
