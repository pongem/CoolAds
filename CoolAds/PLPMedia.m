//
//  PLPMedia.m
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/10/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import "PLPMedia.h"

@implementation PLPMedia


- (id)initWithFiname: (NSString *) iFiname
        WithDataPath: (NSString *) iDataPath {
    self = [super init];
    if (self) {
        //code
        _finame = iFiname;
        _dataPath = iDataPath;
    }
    return self;
}

@end
