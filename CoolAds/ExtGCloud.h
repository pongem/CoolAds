//
//  ExtGCloud.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/9/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@interface ExtGCloud : NSObject

@property (nonatomic, strong) GTLServiceDrive *service;

@property (nonatomic, strong) NSString *kKeychainItemName;
@property (nonatomic, strong) NSString *kClientID;
@property (nonatomic, strong) NSString *scope;

@property (nonatomic, strong) GTMOAuth2ViewControllerTouch *authController;

//static NSString *const kKeychainItemName = @"Drive API";
//static NSString *const kClientID = @"101595793756-0a12cka1c8giqf34nea6d9s4d374jsls.apps.googleusercontent.com";

- (id)initWithClientID: (NSString *) kClientID;
//- (GTMOAuth2ViewControllerTouch *)createAuthController;
- (GTMOAuth2ViewControllerTouch *)createAuthControllerWithHandler: (void (^) (GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error)) handler;

- (void)queryAFile: (NSString *) finame
       WithHandler: (void (^) (GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error)) handler;

- (void)fetchAFile: (GTLDriveFile *) fetchFile
       WithHandler: (void (^) (NSData *data, NSError *error)) handler;

@end
