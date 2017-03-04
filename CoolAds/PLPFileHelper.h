//
//  PLPFileHelper.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/10/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@class ExtGCloud;

@interface PLPFileHelper : NSObject


@property (strong, nonatomic) NSArray *paths; //1
@property (strong, nonatomic) NSString *documentsDirectory; //2
@property (strong, nonatomic) NSString *path; //3
@property (strong, nonatomic) NSFileManager *fileManager;

@property (strong, nonatomic) NSMutableArray *imgs; // array of PLPImg
@property (strong, nonatomic) NSMutableArray *vids; // array of PLPVid

@property (strong, nonatomic) NSArray *img_names; //array of image names
@property (strong, nonatomic) NSMutableDictionary *img_paths; //array of image paths


@property (strong, nonatomic) NSArray *vid_names; //array of image names
@property (strong, nonatomic) NSMutableDictionary *vid_paths; //array of image paths


- (id)initWithImgNames: (NSArray *) iImgNames
          WithVidNames: (NSArray *) iVidNames
          WithIsUpdate: (Boolean) iIsUpdate
            WithGcloud: (ExtGCloud *) iGCloud
      WithErrorHandler: (void (^) (NSError *error)) errHandler;

- (void) downloadMediasByGCloud: (ExtGCloud *) iGCloud
               WithErrorHandler: (void (^) (NSError *error)) errHandler;
    
- (NSDictionary *) readImgPaths;
- (void)setNewImgPaths: (NSDictionary *) newImgPaths;
- (NSDictionary *) readVidPaths;
- (void)setNewVidPaths: (NSDictionary *) newVidPaths;


@end
