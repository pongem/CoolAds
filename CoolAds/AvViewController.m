//
//  AvViewController.m
//  AdvertPS
//
//  Created by Pongsak Srithongnopawong on 7/2/2559 BE.
//  Copyright © 2559 Pongsak Srithongnopawong. All rights reserved.
//

#import "AvViewController.h"
#import "WebViewController.h"
#import "MainNavViewController.h"
#import "PLPConfig.h"


@interface AvViewController ()

@end

@implementation AvViewController

- (void)viewDidLoad {
    
    NSLog(@"Av View Did Load");
    
    [super viewDidLoad];
    
    //_avIndex = 0;
    
    _mainNav = (MainNavViewController *) self.parentViewController;
    _avController = [[AVPlayerViewController alloc]init];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    NSLog(@"vid reach end");
    [_avPlayer pause];
    
    _avIndex++;
    
    if (_avIndex < [_vidPaths count])
    {
        NSString *path = _vidPaths[_avIndex];
        
        
        
        [UIView transitionWithView:_avController.view
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self playWithPath:path];
                        } completion:nil];
    } else {
        NSLog(@"all vid done .. need to repeat img");
        _handler();
    }
    
    //AVPlayerItem *p = [notification object];
    //[p seekToTime:kCMTimeZero];
}


- (void) playWithPaths: (NSArray *) vidPaths
    WithHandler: (void (^) (void)) handler
{
    _vidPaths = vidPaths;
    _avIndex = 0;
    _handler = handler;
    
    if ([_vidPaths count] > 0)
    {
    
        NSString *path = _vidPaths[_avIndex];
        
        [self playWithPath:path];
    }
    
    
}

- (void) playWithPath: (NSString *) vidPath
{
    
    NSString *path = vidPath;
    _vidURL = [[NSURL alloc] initFileURLWithPath:path];
    
    // create an AVPlayer
    _avPlayer = [AVPlayer playerWithURL:self.vidURL];
    
    // create a player view controller
    //_avController = [[AVPlayerViewController alloc]init];
    
    
    _avController.player = _avPlayer;
    _avController.showsPlaybackControls = NO;
    
    //controller.player = player;
    //[player play];
    
    // show the view controller
    [self addChildViewController:_avController];
    [self.view addSubview:_avController.view];
    
    
    _avController.view.frame = self.view.frame;
    _avController.view.userInteractionEnabled = NO;
    _avPlayer.closedCaptionDisplayEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_avPlayer currentItem]];
    
    _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [_avPlayer pause];
    [_avPlayer play];
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
    
    /*
    WebViewController *controller = [[WebViewController alloc] init];
    UIWebView *webview=[[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    controller.view = webview;
    controller.mainNav = _mainNav;*/
    
    NSString *url = [_mainNav.config readWebUrl];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _webController.url = nsurl;
    //if(!_webController.url) {
        [_webview loadRequest:nsrequest];
    //}
    
    [_avPlayer pause];
    
    [_mainNav pushViewController:_webController animated:NO];
    
}

@end
