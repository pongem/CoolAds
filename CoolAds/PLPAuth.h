//
//  PLPAuth.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/6/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@class PLPAlert;

@interface PLPAuth : NSObject

@property (nonatomic, strong) GTLServiceDrive *service;

@property (nonatomic, strong)  NSString *kKeychainItemName;
@property (nonatomic, strong)  NSString *kClientID;

@end
