//
//  YLPQueryPrivate.h
//  YelpAPI
//
//
//

#import "YLPQuery.h"

typedef NS_ENUM(NSUInteger, YLPSearchMode) {
    YLPSearchModeLocation,
    YLPSearchModeCoordinate,
};

NS_ASSUME_NONNULL_BEGIN

@interface YLPQuery ()

@property (assign, nonatomic) YLPSearchMode mode;
@property (copy, nonatomic, nullable) NSString *location;
@property (strong, nonatomic, nullable) YLPCoordinate *coordinate;

- (NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
