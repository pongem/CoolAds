//
//  PLPAlert.h
//  CoolAds
//
//  Created by Pongsak Srithongnopawong on 7/6/2559 BE.
//  Copyright © 2559 ppl.cools. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PLPAlert : NSObject

- (void)showAlert:(NSString *)title message:(NSString *)message viewController: (UIViewController *) vc  ;

@end
