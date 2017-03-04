//
//  WebViewController.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/18/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "MediaViewController.h"

@class MainNavViewController;
@class PLPConfig;
@class ViewController;
@class ImgViewController;

@interface WebViewController : MediaViewController 
@property (strong, nonatomic) MainNavViewController *mainNav;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSURL *url;


@property NSUInteger interval;

- (void) flip ;

@end
