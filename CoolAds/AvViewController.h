//
//  AvViewController.h
//  AdvertPS
//
//  Created by Pongsak Srithongnopawong on 7/2/2559 BE.
//  Copyright © 2559 Pongsak Srithongnopawong. All rights reserved.
//

#import "MediaViewController.h"

@import AVFoundation;
@import AVKit;

@class WebViewController;
@class MainNavViewController;
@class PLPConfig;


@interface AvViewController : MediaViewController

@property (strong, nonatomic) NSURL *vidURL;
@property (strong, nonatomic) NSArray *vidPaths;

@property NSUInteger avIndex;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerViewController *avController;
@property (strong, nonatomic) MainNavViewController *mainNav;

@property (strong, nonatomic)  WebViewController *webController;
@property (strong, nonatomic)  UIWebView *webview;

@property (nonatomic, copy) void (^handler) (void);

- (void) playWithPath: (NSString *) vidPath;
- (void) playWithPaths: (NSArray *) vidPaths
           WithHandler: (void (^) (void)) handler;

@end
