//
//  YLPDetailBusinessViewController.m
//  YelpAPI
//
//  Copyright © 2016 Yelp. All rights reserved.
//

#import "YLPDetailBusinessViewController.h"
#import <YelpAPI/YLPBusiness.h>
#import <YelpAPI/YLPLocation.h>
#import <YelpAPI/YLPCoordinate.h>


//outlets for the information presented about the selected business
@interface YLPDetailBusinessViewController ()
@property (nonatomic) IBOutlet UILabel *businessName;
@property (nonatomic) IBOutlet UITextView *businessAddress;
@property (nonatomic) IBOutlet UITextField *businessPhone;
@end

@implementation YLPDetailBusinessViewController
//display the information
- (void)viewDidLoad {
    [super viewDidLoad];
    self.businessName.text = self.business.name;
    self.businessPhone.text = self.business.phone;
    
    for (int x = 0; x < self.business.location.address.count; x++) {
        self.businessAddress.text = [NSString stringWithFormat:@"%@" " " @"%@" "\n", self.businessAddress.text, self.business.location.address[x]];
    }
    self.businessAddress.text = [NSString stringWithFormat:@"%@" @"%@" ", " @"%@" " " @"%@", self.businessAddress.text, self.business.location.city, self.business.location.stateCode, self.business.location.postalCode];
 }

@end
