//
//  PLPAuth.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/6/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "PLPAuth.h"
#import "PLPAlert.h"

@implementation PLPAuth

- (id) init {
    self = [super init];
    if (self) {
        // Any custom setup work goes here
        _kKeychainItemName = @"Drive API";
        _kClientID = @"101595793756-0a12cka1c8giqf34nea6d9s4d374jsls.apps.googleusercontent.com";
    }
    return self;
    
}

// Creates the auth controller for authorizing access to Drive API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    //NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeDriveMetadataReadonly, nil];
    //NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeDrive , nil];
    NSString *scope = @"https://www.googleapis.com/auth/drive";
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope: scope  //[scopes componentsJoinedByString:@" "]
                      clientID:_kClientID
                      clientSecret:nil
                      keychainItemName:_kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Drive API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    
    PLPAlert alert = [[PLPAlert alloc]init];
    if (error != nil) {
        [alert showAlert:@"Authentication Error" message:error.localizedDescription viewController:self];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
