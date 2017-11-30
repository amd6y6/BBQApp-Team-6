//
//  YLPCategory.m
//  Pods
//
//
//

#import "YLPCategory.h"

@implementation YLPCategory

- (instancetype) initWithName:(NSString *)name alias:(NSString *)alias {
    if (self = [super init]) {
        _name = name;
        _alias = alias;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)categoryDict {
    return [self initWithName:categoryDict[@"title"]
                        alias:categoryDict[@"alias"]];
}

@end
