

#import <UIKit/UIKit.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"


@import AVFoundation;
@import AVKit;

@class PLPConfig;
@class ExtGCloud;
@class PLPFileHelper;
@class MainNavViewController;
@class ImgViewController;
@class AvViewController;

@interface ViewController : UIViewController

//@property (nonatomic, strong) GTLServiceDrive *service;
@property (nonatomic, strong) UITextView *output;

@property NSUInteger tmpCount;
@property NSUInteger timerExpectedNoImgs;
@property NSUInteger timerExpectedNoVids;

@property NSTimeInterval intervalFileCheck;

@property (strong, nonatomic) PLPConfig *config;

@property (strong, nonatomic) PLPFileHelper *fiHelper;
@property (strong, nonatomic) ExtGCloud *gCloud;

@property (strong, nonatomic) MainNavViewController *nav;

@property (strong, nonatomic) UIActivityIndicatorView *activityindicator;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSArray *downloadImgs;
@property (strong, nonatomic) NSArray *downloadVids;
@property (strong, nonatomic) NSMutableArray *vidPaths;

- (void)updateConfig:(GTLServiceTicket *)ticket finishedWithObject:(GTLDriveFileList *)response error:(NSError *)error;
- (void) imgRun;
@end