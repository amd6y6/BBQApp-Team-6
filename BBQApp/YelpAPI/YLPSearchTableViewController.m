//
//  YLPSearchTableViewController.m
//  YelpAPI
//
//  Copyright © 2016 Yelp. All rights reserved.
//

#import "YLPSearchTableViewController.h"
#import "YLPDetailBusinessViewController.h"
#import "YLPClient+Search.h"
#import "YLPSortType.h"
#import "YLPSearch.h"
#import "YLPBusiness.h"
#import "YLPCoordinate.h"
#import "YLPLocation.h"
#import "BBQApp-Swift.h"

@interface YLPSearchTableViewController ()
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) YLPSearch *search;
@end

@implementation YLPSearchTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.frame.size.width /2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
  
    
    YLPCoordinate *coordinate = [[YLPCoordinate alloc] initWithLatitude:(double)_userLocation.coordinate.latitude longitude:(double)_userLocation.coordinate.longitude];
    
    //use the coordinate of the users location to make the API call and generate relative results based on their location
   [[AppDelegate sharedClient] searchWithCoordinate: coordinate  term:nil limit:50 offset:0 categoryFilter:@[@"bbq"] sort:YLPSortTypeDistance completionHandler:^
     (YLPSearch *search, NSError* error) {
         self.search = search;
         dispatch_async(dispatch_get_main_queue(), ^{
             [activityIndicator stopAnimating];
             [self.tableView reloadData];
         });
     }];
}


#pragma mark - Table view data source
//fill the table view in accordance with the data returned
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.search.businesses.count;
}
//load each cell with name of each business
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    if (indexPath.item > [self.search.businesses count]) {
        cell.textLabel.text = @"";
    }
    else {
        cell.textLabel.text = self.search.businesses[indexPath.item].name;
        
        UIImage * originalImage;
        NSString * imageString = self.search.businesses[indexPath.item].imageURL.absoluteString;
        NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: imageString]];
        if(imageString.length == 0){
            originalImage = [UIImage imageNamed:@"bbq logo 161px"];
        } else {
            originalImage = [UIImage imageWithData: imageData];
        }
        UIImage *resizedImage = [YLPSearchTableViewController imageWithImage: originalImage scaledToSize: CGSizeMake(70, 70)];
        cell.imageView.image = resizedImage;
        [cell.imageView.layer setCornerRadius:8.0f];
        [cell.imageView.layer setMasksToBounds:YES];
        
    }
    
    return cell;
}
//prepare the segue for when a user clicks on a specific cell in the table view and take them to more detail of selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YLPDetailBusinessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YLPDetailBusinessViewController"];
    vc.business = self.search.businesses[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
