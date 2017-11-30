//
//  YLPClientPrivate.h
//  Pods
//
//
//
#import "YLPClient.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kYLPErrorDomain;

@interface YLPClient ()

- (instancetype)initWithAccessToken:(NSString *)accessToken;

- (NSURLRequest *)requestWithPath:(NSString *)path;
- (NSURLRequest *)requestWithPath:(NSString *)path params:(nullable NSDictionary *)params;
- (void)queryWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSDictionary *responseDict, NSError *error))completionHandler;

+ (NSCharacterSet *)URLEncodeAllowedCharacters;
+ (NSURLRequest *)authRequestWithAppId:(NSString *)appId secret:(NSString *)secret;

@end

NS_ASSUME_NONNULL_END
