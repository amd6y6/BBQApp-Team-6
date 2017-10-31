//
//  YLPAppDelegate.m
//  YelpAPI
//
//  Created by David Chen on 12/07/2015.
//  Copyright (c) 2015 David Chen. All rights reserved.
//

#import "YLPAppDelegate.h"

@import YelpAPI;

@interface YLPAppDelegate ()
@property (strong, nonatomic) YLPClient *client;
@end

@implementation YLPAppDelegate

+ (YLPClient *)sharedClient {
    YLPAppDelegate *appDelegate = (YLPAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.client;
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //#warning Fill in the API keys below with your developer v3 keys.
    [YLPClient authorizeWithAppId:@"RS4jBI4iBtuHFTnestIvUQ" secret:@"ASUi04wdzwMVuaebZaXZ8oZjddzO9fgs7HMET4AsXG7WE5CgPzReTFDfhLXrlxkj" completionHandler:^(YLPClient *client, NSError *error) {
        self.client = client;
        if (!client) {
            NSLog(@"Authentication failed: %@", error);
        }
    }];

    return YES;
}

@end
