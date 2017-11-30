//
//  YLPBusinessReviews.h
//  YelpAPI
//
//
//

#import <Foundation/Foundation.h>

@class YLPReview;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusinessReviews : NSObject

@property (nonatomic, readonly) NSArray<YLPReview *> *reviews;
@property (nonatomic, readonly) NSUInteger total;

@end

NS_ASSUME_NONNULL_END
