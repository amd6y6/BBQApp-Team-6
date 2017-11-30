//
//  YLPSearch.h
//  Pods
//
//
//

#import <Foundation/Foundation.h>

@class YLPBusiness;

NS_ASSUME_NONNULL_BEGIN

@interface YLPSearch : NSObject

@property (nonatomic, readonly) NSArray<YLPBusiness *> *businesses;
@property (nonatomic, readonly) NSUInteger total;

@end

NS_ASSUME_NONNULL_END
