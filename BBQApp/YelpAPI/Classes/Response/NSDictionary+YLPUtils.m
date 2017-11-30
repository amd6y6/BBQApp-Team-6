//
//  NSDictionary+YLPUtils.m
//  YelpAPI
//
//
//

#import "YLPResponsePrivate.h"

@implementation NSDictionary (YLPUtils)

- (id)ylp_objectMaybeNullForKey:(id)key {
    id obj = self[key];
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}

@end
