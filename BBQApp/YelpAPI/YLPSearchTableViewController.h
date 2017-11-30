//
//  YLPSearchTableViewController.h
//  YelpAPI
//
//  Copyright © 2016 Yelp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class YLPClient;
@class YLPSearch;

@interface YLPSearchTableViewController : UITableViewController <UITableViewDelegate>
@property (strong, nonatomic) CLLocation *userLocation;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

@end
