//
//  ImgViewController.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/13/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "MediaViewController.h"
@class WebViewController;
@class MainNavViewController;
@class PLPConfig;

@interface ImgViewController : MediaViewController

@property (strong, nonatomic) NSData *imgData;

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) MainNavViewController *mainNav;

@property (strong, nonatomic)  WebViewController *webController;
@property (strong, nonatomic)  UIWebView *webview;

@property Boolean stop;

@property NSUInteger imgIndex;

@end
