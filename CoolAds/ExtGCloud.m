//
//  ExtGCloud.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/9/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "ExtGCloud.h"


@implementation ExtGCloud


- (id)initWithClientID: (NSString *) kClientID {
    self = [super init];
    if (self) {
        _kKeychainItemName = @"Drive API";
        //_kClientID = @"101595793756-0a12cka1c8giqf34nea6d9s4d374jsls.apps.googleusercontent.com";
        _kClientID = kClientID;
        _scope = @"https://www.googleapis.com/auth/drive";
        
        self.service = [[GTLServiceDrive alloc] init];
        self.service.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:_kKeychainItemName
                                                                                           clientID:kClientID
                                                                                       clientSecret:nil];
    }
    return self;
}


// Creates the auth controller for authorizing access to Drive API.

- (GTMOAuth2ViewControllerTouch *)createAuthControllerWithHandler: (void (^) (GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error)) handler {
    //GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    //NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeDriveMetadataReadonly, nil];
    //NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeDrive , nil];
    _authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:_scope
                                               clientID:_kClientID
                                           clientSecret:nil
                                       keychainItemName:_kKeychainItemName
                                      completionHandler:handler];
    
   /* _authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope: _scope  //[scopes componentsJoinedByString:@" "]
                      clientID:_kClientID
                      clientSecret:nil
                      keychainItemName:_kKeychainItemName
                      delegate:self
                       
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
                       //finishedSelector: finishSelector];*/
    return _authController;
}


- (void)queryAFile: (NSString *) finame
       WithHandler: (void (^) (GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error)) handler {
    
    GTLQueryDrive *query =
    [GTLQueryDrive queryForFilesList];
    query.q = [NSString stringWithFormat:@"name='%@' and trashed=false", finame];
    query.pageSize = 1;
    //query.fields = @"nextPageToken, files(id, name)";
    [_service executeQuery:query completionHandler:handler];
}


- (void)fetchAFile: (GTLDriveFile *) fetchFile
       WithHandler: (void (^) (NSData *data, NSError *error)) handler {
    
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/drive/v3/files/%@?alt=media",fetchFile.identifier];
    GTMSessionFetcher *fetcher = [_service.fetcherService fetcherWithURLString:url];
    
    [fetcher beginFetchWithCompletionHandler:handler];

}


@end
