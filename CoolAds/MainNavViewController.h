//
//  MainNavViewController.h
//  AdvertPS
//
//  Created by Pongsak Srithongnopawong on 7/2/2559 BE.
//  Copyright © 2559 Pongsak Srithongnopawong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class PageContentViewController;
@class AvViewController;
@class ImgViewController;
@class ViewController;
@class PLPConfig;
@class WebViewController;

@interface MainNavViewController : UINavigationController <UIGestureRecognizerDelegate>


//@property (strong, nonatomic) PageContentViewController *pageContentVC;
@property (strong, nonatomic) AvViewController *avVC;
@property (strong, nonatomic) ImgViewController *imgVC;
@property (strong, nonatomic) ViewController *pvcVC;

@property (strong, nonatomic)  WebViewController *webController;
@property (strong, nonatomic)  UIWebView *webview;

@property (strong, nonatomic) PLPConfig *config;



@end
