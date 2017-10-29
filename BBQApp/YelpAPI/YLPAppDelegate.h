//
//  YLPAppDelegate.h
//  YelpAPI
//
//  Created by David Chen on 12/07/2015.
//  Copyright (c) 2015 David Chen. All rights reserved.
//

@import UIKit;

@class YLPClient;

@interface YLPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (YLPClient *)sharedClient;

@end
