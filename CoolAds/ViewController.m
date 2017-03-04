

#import "ViewController.h"

#import "PLPConfig.h"
#import "PLPFileHelper.h"
#import "ExtGCloud.h"
#import "MainNavViewController.h"
#import "ImgViewController.h"
#import "AvViewController.h"

@implementation ViewController

@synthesize output = _output;

// When the view loads, create necessary subviews, and initialize the Drive API service.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConfig:[[PLPConfig alloc] init]];
    _vidPaths = [[NSMutableArray alloc]initWithCapacity:20];
    _timerExpectedNoImgs = 3;
    _timerExpectedNoVids = 1;
    NSLog(@"config path: %@", [_config readConfigPath]); // shall set the plist in dir for the first time
    _intervalFileCheck = 0.1;
    
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.output.editable = false;
    self.output.contentInset = UIEdgeInsetsMake(20.0, 0.0, 20.0, 0.0);
    self.output.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.output];
    
    
    //loading
    
    _activityindicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(round((self.view.frame.size.width - 500) / 2), (round((self.view.frame.size.height - 50) / 2))+50, 500, 50)];
    _label.text = @"Downloading";
    [_label setTextAlignment:NSTextAlignmentCenter];
    _activityindicator.center = CGPointMake(240,160);
    _activityindicator.color = [UIColor blackColor];
    _activityindicator.frame = CGRectMake(round((self.view.frame.size.width - 250) / 2), round((self.view.frame.size.height - 250) / 2), 250, 250);
    _activityindicator.tag  = 1;
    
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.gCloud = [[ExtGCloud alloc]initWithClientID:@"101595793756-0a12cka1c8giqf34nea6d9s4d374jsls.apps.googleusercontent.com"];
    
    //reset authorizer for testing
    //_gCloud.service.authorizer = nil;
    
    //create main nav
    _nav = [[MainNavViewController alloc]init];
    _nav.config = _config;
    _nav.pvcVC = self;
    
    
}

// When the view appears, ensure that the Drive API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated {
    
    
    if (!_gCloud.service.authorizer.canAuthorize) {
       // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:
         [_gCloud createAuthControllerWithHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
            
            if (error != nil) {
                [self showAlert:@"Authentication Error" message:error.localizedDescription];
                _gCloud.service.authorizer = nil;
            }
            else {
                _gCloud.service.authorizer = auth;
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }] animated:YES completion:nil];
        
    } else {
        
        //fetch and download file
        [_config queryConfigWithGcloud:_gCloud WithHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error) {
            NSLog(@"Update config success!");
            
            [self updateConfig:ticket finishedWithObject:response error:error];
            
      
            
        }];
        
        //waiting process
        [self.view addSubview:_label];
        [self.view addSubview:_activityindicator];
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
        [NSTimer scheduledTimerWithTimeInterval:_intervalFileCheck target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
        
    }
}

- (void) threadStartAnimating {
    [_activityindicator startAnimating];
}

- (void)timerMethod:(NSTimer*)theTimer{
    NSLog(@"Timer wait for download file");
    NSUInteger countImgs = 0;
    NSUInteger countVids = 0;
    
    if(_fiHelper){
        countImgs =[[_fiHelper readImgPaths] count];
        countVids =[[_fiHelper readVidPaths] count];
        
        _label.text = [NSString stringWithFormat: @"Downloading Image: %lu/%lu files, Videos: %lu/%lu files.",(unsigned long)countImgs, _timerExpectedNoImgs,(unsigned long)countVids, _timerExpectedNoVids];
        
        NSLog(@"download imgs %lu / %lu files",(unsigned long)countImgs, _timerExpectedNoImgs);
        NSLog(@"download vids: %lu / %lu files",(unsigned long)countVids, _timerExpectedNoVids);
        
        //timerExpectedNoImgs
    }
    if ((countImgs >= _timerExpectedNoImgs) &&(countVids >= _timerExpectedNoVids))
    {
        [self downloadready];
    } else {
        
        [NSTimer scheduledTimerWithTimeInterval:_intervalFileCheck target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (void) downloadready {
    NSLog(@"Download ready");
    
    [_activityindicator stopAnimating];
    //[self showAlert:@"downloadready" message: [NSString stringWithFormat:@"download files are now ready img: %@ vid: %@ ",[_fiHelper readImgPaths],[_fiHelper readVidPaths]]];
    
    _downloadImgs = [_config readImages];
    _downloadVids = [_config readVideos];
    
    for (NSString *vid in _downloadVids) {
        NSString *path = [[_fiHelper readVidPaths] objectForKey: vid];
        if(path)
            [_vidPaths addObject:path];
    }
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_nav animated:YES completion:nil];
    
    //[self imgRun];
    [self imgRun];
    
    
}

- (void) vidRun {
    
    _nav.avVC.avIndex = 0;
    
    //[_nav popToViewController:_nav.avVC animated:NO];
    //[_nav popToViewController:[_nav.viewControllers objectAtIndex:1] animated:NO];
    [_nav setViewControllers:[NSArray arrayWithObjects:_nav.imgVC, _nav.avVC, nil]];
    [_nav popToViewController:[_nav.viewControllers objectAtIndex:1] animated:NO];
    //[_nav pushViewController:_nav.avVC animated:NO];
    [_nav.avVC playWithPaths:_vidPaths WithHandler:^{
        NSLog(@"test handler");
        [self imgRun];
    }];
}

- (void) imgRun {
    
    _nav.imgVC.imgIndex = 0;
    
    //[_nav popToViewController:_nav.imgVC animated:NO];
    //[_nav popToViewController:[_nav.viewControllers objectAtIndex:0] animated:NO];
    [_nav setViewControllers:[NSArray arrayWithObjects:_nav.imgVC, _nav.avVC, nil]];
    [_nav popToViewController:[_nav.viewControllers objectAtIndex:0] animated:NO];
    //[_nav present:_nav.imgVC animated:NO];
    [self timeImgRun];
    
}


- (void) timeImgRun {
    
    
    NSUInteger imgIndex = _nav.imgVC.imgIndex;
    
    if(_nav.imgVC.stop) {
        return;
    }
    
    if ((imgIndex < [_downloadImgs count]) ) {
        
        NSLog(@"time img run at index: %lu image: %@", (unsigned long)imgIndex, _downloadImgs[imgIndex]);
        NSString *path = [[_fiHelper readImgPaths] objectForKey: _downloadImgs[imgIndex]];
        
        
        if (![path  isEqual: @"error"] ) {
            
            NSData *imgData = [NSData dataWithContentsOfFile:path];
            
            //_nav.imgVC.imgView.image=[UIImage imageWithData:imgData];
            
            UIImage * toImage = [UIImage imageWithData:imgData];
            
            if (imgIndex == 0) {
                _nav.imgVC.imgData = imgData;
                _nav.imgVC.imgView.image = toImage;
                
            } else
            
            [UIView transitionWithView:_nav.imgVC.imgView
                              duration:1.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                _nav.imgVC.imgView.image = toImage;
                            } completion:nil];
            
            
            [_nav.imgVC.imgView setNeedsDisplay];
            
        } else {
            NSLog(@"error img");
        }
        
        _nav.imgVC.imgIndex++;
        
        
        [NSTimer scheduledTimerWithTimeInterval:_config.readInterval
                                         target:self
                                       selector:@selector(timeImgRun)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        NSLog(@"transition to new view");
        [self vidRun];
        
    }
    

}



- (void)updateConfig:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLDriveFileList *)response
                          error:(NSError *)error {
    if (error == nil) {
        
        GTLDriveFile *configFile = response.files[0];
        NSString *identifier = configFile.identifier;
        //NSString *name = configFile.name;
        
        
        if (!identifier) {
            [self showAlert:@"Error" message:@"File config not found!"];
            return;
        }
        
        [_config fetchConfigWithGcloud:_gCloud
                              WithFile:configFile
                    WithSuccessHandler:^{
                        //code here
                        
                        NSArray *imgs = [[_config readImages] copy] ;
                        NSArray *vids = [[_config readVideos] copy] ;
                        _timerExpectedNoImgs = [imgs count];
                        _timerExpectedNoVids = [vids count];
                        
                        NSLog(@"imgs: %@" , [imgs componentsJoinedByString:@","]);
                        NSLog(@"vids: %@" , [vids componentsJoinedByString:@","]);
                        NSLog(@"Success fecthconfig");
                        
                        
                        _fiHelper = [[PLPFileHelper alloc] initWithImgNames:imgs
                         WithVidNames:vids
                         WithIsUpdate:YES //yes for testing
                         WithGcloud:_gCloud
                         WithErrorHandler:^(NSError *error) {
                         [self showAlert:@"err" message:error.localizedDescription];
                         }];
                    }
                      WithErrorHandler:^(NSError *error) {
                          //[_config fetchConfigWithGcloud:_gCloud WithFile:configFile WithErrorHandler:^(NSError *error) {
                          [self showAlert:@"Error" message:error.localizedDescription];
                      }];
        
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}



// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    NSLog(@"ERROR: %@, %@", title, message);
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    //[self presentViewController:alert animated:YES completion:nil];
    
}


@end