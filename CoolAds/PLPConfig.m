//
//  PLPConfig.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/6/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "PLPConfig.h"
#import "ExtGCloud.h"

@implementation PLPConfig

- (id)init {
    self = [super init];
    if (self) {
        NSError *error;
        
        _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
        _documentsDirectory = [_paths objectAtIndex:0]; //2
        _path = [_documentsDirectory stringByAppendingPathComponent:@"config.plist"]; //3
        _curVersion = [self readVersion];
        _isUpdate = NO;
        NSLog(@"read cur version for the first time: %lu", (unsigned long)_curVersion);
        
        _fileManager = [NSFileManager defaultManager];
        
        if (![_fileManager fileExistsAtPath: _path]) //4
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]; //5
            
            [_fileManager copyItemAtPath:bundle toPath: _path error:&error]; //6
        }
    }
    return self;
}

- (NSString *) readConfigPath {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSString *value;
    value = [savedStock objectForKey:@"config_path"];
    
    return value;
}

- (void)setConfigPath: (NSString *) newConfigPath {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:newConfigPath forKey:@"config_path"];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new config");
    
}

- (NSUInteger) readInterval {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSUInteger value;
    value = [[savedStock objectForKey:@"interval"] unsignedIntegerValue];
    
    return value;
}

- (void)setInterval: (NSUInteger) newInterval {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:[[NSNumber alloc] initWithUnsignedInteger:newInterval] forKey:@"interval"];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new interval");
    
}

- (NSUInteger) readVersion {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSUInteger value;
    value = [[savedStock objectForKey:@"version"] unsignedIntegerValue];
    
    return value;
}

- (void)setVersion: (NSUInteger) newVersion {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:[[NSNumber alloc] initWithUnsignedInteger:newVersion] forKey:@"version"];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new version");
    
}

- (NSString *) readWebUrl {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSString *value;
    value = [savedStock objectForKey:@"webUrl"];
    
    return value;
}

- (void)setWebUrl:(NSString *)newWebUrl {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:[NSString stringWithFormat:@"%@",newWebUrl] forKey:@"webUrl" ];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new weburl");
    
}

- (NSArray *) readImages {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSArray *value;
    value = [savedStock objectForKey:@"images"];
    
    return value;
}

- (void)setImages: (NSArray *) newImages {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:newImages forKey:@"images"];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new images");
    
}

- (NSArray *) readVideos {
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    //load from savedStock example int value
    NSArray *value;
    value = [savedStock objectForKey:@"videos"];
    
    return value;
}

- (void)setVideos:(NSArray *)newVideos {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: _path];
    
    [data setObject:newVideos forKey:@"videos"];
    
    [data writeToFile: _path atomically:YES];
    NSLog(@"saved new videos");
    
}


- (void)queryConfigWithGcloud: (ExtGCloud *) gCloud
    WithHandler: (void (^) (GTLServiceTicket *ticket, GTLDriveFileList *response, NSError *error)) handler {
    [gCloud queryAFile:@"config.txt" WithHandler:handler];
}


- (void)fetchConfigWithGcloud: (ExtGCloud *) gCloud
                     WithFile: (GTLDriveFile *) gFile
             WithSuccessHandler: (void (^) (void)) successHandler
                  WithErrorHandler: (void (^) (NSError *error)) errHandler {
    
    [gCloud fetchAFile:gFile WithHandler:^(NSData *data, NSError *error) {
        
        if (error == nil) {
            NSLog(@"Retrieved file content");
            
            
            if (data) {
                
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:gFile.name];
                [self setConfigPath:dataPath];
                
                
                // Save it into file system
                if([data writeToFile:dataPath atomically:YES]){
                    NSLog(@"success: saving file");
                    
                    NSData *configData = [NSData dataWithContentsOfFile:dataPath];
                    NSString *strConfig = [[NSString alloc]initWithData:configData encoding:NSUTF8StringEncoding];
                    NSLog( @"%@" , strConfig );
                    
                    //NSString *configPath = [[NSBundle mainBundle] pathForResource:@"configfile" ofType:nil];
                    //NSData *data = [[NSFileManager defaultManager] contentsAtPath:configPath];
                    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
                    NSUInteger version = [[config valueForKeyPath:@"main.version"] intValue];
                    
                    //for testing
                    //version++;
                    
                    // disable condition for testing
                    //if (version > _curVersion)
                        _isUpdate = YES;
                    
                    if (_isUpdate){
                        [self setVersion:version];
                        NSLog(@"new version: %lu" , (unsigned long)[self readVersion]);
                        NSUInteger interval = [[config valueForKeyPath:@"main.interval"] intValue];
                        NSArray *imgs = [config valueForKeyPath:@"main.images"];
                        NSArray *vids = [config valueForKeyPath:@"main.videos"];
                        NSString *url = [config valueForKeyPath:@"main.webUrl"];
                        [self setInterval:interval];
                        [self setImages:imgs];
                        [self setVideos:vids];
                        [self setWebUrl:url];
                    
                        NSLog(@"Config Loaded");
                    } else
                        NSLog(@"Using old config");
                    
                    NSLog(@"int: %lu" , (unsigned long)[self readInterval]);
                    NSLog(@"imgs: %@" , [[self readImages] componentsJoinedByString:@","]);
                    NSLog(@"vids: %@" , [[self readVideos] componentsJoinedByString:@","]);
                    
                    successHandler();
                    
                    
                }
                
            }
        } else {
            errHandler(error);
        }

    }];
}






@end
