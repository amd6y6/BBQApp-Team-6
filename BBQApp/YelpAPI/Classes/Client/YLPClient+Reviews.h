//
//  YLPClient+Reviews.h
//  YelpAPI
//
//
//

#import "YLPClient.h"

@class YLPBusinessReviews;

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLPReviewsCompletionHandler)(YLPBusinessReviews *_Nullable reviews, NSError *_Nullable error);

@interface YLPClient (Reviews)

- (void)reviewsForBusinessWithId:(NSString *)businessId
               completionHandler:(YLPReviewsCompletionHandler)completionHandler;

- (void)reviewsForBusinessWithId:(NSString *)businessId
                          locale:(nullable NSString *)locale
               completionHandler:(YLPReviewsCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
