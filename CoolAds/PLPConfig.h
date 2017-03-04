//
//  PLPConfig.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/6/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@class ExtGCloud;

@interface PLPConfig : NSObject


@property (strong, nonatomic) NSArray *paths; //1
@property (strong, nonatomic) NSString *documentsDirectory; //2
@property (strong, nonatomic) NSString *path; //3
@property (strong, nonatomic) NSFileManager *fileManager;
@property NSUInteger curVersion;
@property Boolean isUpdate;

- (NSString *) readConfigPath;
- (void)setConfigPath: (NSString *) newConfigPath;

- (NSUInteger) readInterval;
- (void)setInterval: (NSUInteger) newInterval;

- (NSUInteger) readVersion;
- (void)setVersion: (NSUInteger) newVersion;

- (NSString *) readWebUrl;
- (void)setWebUrl: (NSString *) newWebUrl;

- (NSArray *) readImages ;
- (void)setImages: (NSArray *) newImages ;

- (NSArray *) readVideos ;
- (void)setVideos: (NSArray *) newVideos ;

- (void)queryConfigWithGcloud: (ExtGCloud *) gCloud
                  WithHandler: (void (^) (GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error)) handler;

- (void)fetchConfigWithGcloud: (ExtGCloud *) gCloud
                     WithFile: (GTLDriveFile *) gFile
           WithSuccessHandler: (void (^) (void)) successHandler
             WithErrorHandler: (void (^) (NSError *error)) errHandler;

@end
