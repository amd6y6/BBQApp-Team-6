//
//  YLPCoordinate.h
//  Pods
//
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPCoordinate : NSObject

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
