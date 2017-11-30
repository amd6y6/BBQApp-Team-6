//
//  YLPClient+Business.m
//  Pods
//
//
//

#import "YLPClient+Business.h"
#import "YLPBusiness.h"
#import "YLPClientPrivate.h"
#import "YLPResponsePrivate.h"

@implementation YLPClient (Business)

- (NSURLRequest *)businessRequestWithId:(NSString *)businessId {
    NSString *businessPath = [@"/v3/businesses/" stringByAppendingString:businessId];
    return [self requestWithPath:businessPath];
}

- (void)businessWithId:(NSString *)businessId
     completionHandler:(void (^)(YLPBusiness *business, NSError *error))completionHandler {
    NSURLRequest *req = [self businessRequestWithId:businessId];
    [self queryWithRequest:req completionHandler:^(NSDictionary *responseDict, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            YLPBusiness *business = [[YLPBusiness alloc] initWithDictionary:responseDict];
            completionHandler(business, nil);
        }
    }];
    
}
@end
