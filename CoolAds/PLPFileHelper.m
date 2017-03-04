//
//  PLPFileHelper.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/10/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "PLPFileHelper.h"

#import "ExtGCloud.h"

@implementation PLPFileHelper


- (id)initWithImgNames: (NSArray *) iImgNames
        WithVidNames: (NSArray *) iVidNames
          WithIsUpdate: (Boolean) iIsUpdate
            WithGcloud: (ExtGCloud *) iGCloud
      WithErrorHandler: (void (^) (NSError *error)) iErrHandler  {
    
    self = [super init];
    if (self) {
        
        //code
        NSError *error;
        _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
        _documentsDirectory = [_paths objectAtIndex:0]; //2
        _path = [_documentsDirectory stringByAppendingPathComponent:@"config.plist"]; //3
        
        if (![_fileManager fileExistsAtPath: _path]) //4
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]; //5
            
            [_fileManager copyItemAtPath:bundle toPath: _path error:&error]; //6
        }
        
        _img_names = iImgNames;
        _vid_names = iVidNames;
        
        _img_paths = [[NSMutableDictionary alloc]init];
        _vid_paths = [[NSMutableDictionary alloc]init];
        
        if(!iIsUpdate) {
            _img_paths = [[NSMutableDictionary alloc] initWithDictionary:[self readImgPaths] copyItems:YES];
            _vid_paths = [[NSMutableDictionary alloc] initWithDictionary:[self readVidPaths] copyItems:YES];
            
        }
        
        [self setNewImgPaths:_img_paths];
        [self setNewVidPaths:_vid_paths];
        
        if(iIsUpdate) {
            [self downloadMediasByGCloud:iGCloud
                        WithErrorHandler:iErrHandler];
        }
        
        
        
    }
    return self;
}

- (void) downloadMediasByGCloud: (ExtGCloud *) iGCloud
               WithErrorHandler: (void (^) (NSError *error)) iErrHandler {
    
    //imgs
    for (NSString *imgName in _img_names) {
        NSLog(@"querying img: %@", imgName);
        //code
        [iGCloud queryAFile:imgName
                WithHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error) {
                    NSLog(@"downloading img");
                    GTLDriveFile *imgFile = response.files[0];
                    //NSString *identifier = imgFile.identifier;
                    
                    //fetch image
                    [iGCloud fetchAFile:imgFile WithHandler:^(NSData *data, NSError *error) {
                        
                        if (error == nil) {
                            NSLog(@"Retrieved file content");
                            
                            if (data) {
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:imgFile.name];
                                
                                // Save it into file system
                                if([data writeToFile:dataPath atomically:YES]){
                                    NSLog(@"success: saving file");
                                    if (dataPath && imgFile.name)
                                        [_img_paths setObject:dataPath forKey:[imgFile.name copy]];
                                    else
                                        [_img_paths setObject:@"error" forKey:@"error"];
                                } else {
                                    [_img_paths setObject:@"error" forKey:@"error"];
                                    
                                }
                                
                            }
                        } else {
                            [_img_paths setObject:@"error" forKey:@"error"];
                            iErrHandler(error);
                        }
                        [self setNewImgPaths:_img_paths];
                        NSLog(@"img_names: %@", _img_names);
                        NSLog(@"img_paths: %@", [self readImgPaths]);
                        
                    }];
                    
                }];
    }
    
    //vids
    for (NSString *vidName in _vid_names) {
        //code
        [iGCloud queryAFile:vidName
                WithHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error) {
                    NSLog(@"downloading vid");
                    GTLDriveFile *vidFile = response.files[0];
                    //NSString *identifier = vidFile.identifier;
                    
                    [iGCloud fetchAFile:vidFile WithHandler:^(NSData *data, NSError *error) {
                        
                        if (error == nil) {
                            NSLog(@"Retrieved file content");
                            
                            if (data) {
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:vidFile.name];
                                
                                // Save it into file system
                                if([data writeToFile:dataPath atomically:YES]){
                                    NSLog(@"success: saving file");
                                    if (dataPath && vidFile.name)
                                        [_vid_paths setObject:dataPath forKey:[vidFile.name copy]];
                                    else
                                        [_vid_paths setObject:@"error" forKey:@"error"];
                                } else {
                                    [_vid_paths setObject:@"error" forKey:@"error"];
                                    
                                }
                                
                            }
                        } else {
                            [_vid_paths setObject:@"error" forKey:@"error"];
                            iErrHandler(error);
                        }
                        [self setNewVidPaths:_vid_paths];
                        NSLog(@"vid_names: %@", _vid_names);
                        NSLog(@"vid_paths: %@", [self readVidPaths]);
                        
                    }];
                    
                }];
    }
    
    
    
    
}

- (NSDictionary *) readImgPaths {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSDictionary *value;
    value = [savedStock objectForKey:@"imgPaths"];
    
    return value;
}

- (void)setNewImgPaths: (NSDictionary *) newImgPaths {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:newImgPaths forKey:@"imgPaths"];
    
    [data writeToFile: _path atomically:YES];
    
    //[self setImgPaths:newImgPaths];
    
    NSLog(@"saved new imgPaths");
    
}

- (NSDictionary *) readVidPaths {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSDictionary *value;
    value = [savedStock objectForKey:@"vidPaths"];
    
    return value;
}

- (void)setNewVidPaths: (NSDictionary *) newVidPaths {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:newVidPaths forKey:@"vidPaths"];
    
    [data writeToFile: _path atomically:YES];
    
    //[self setVidPaths:newVidPaths];
    
    NSLog(@"saved new vidPaths");
    
}

@end
