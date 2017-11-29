//
//  YLPSearchTableViewController.h
//  YelpAPI
//
//  Created by David Chen on 3/31/16.
//  Copyright © 2016 Yelp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class YLPClient;
@class YLPSearch;

@interface YLPSearchTableViewController : UITableViewController <UITableViewDelegate>
@property (strong, nonatomic) CLLocation *userLocation;

@end
