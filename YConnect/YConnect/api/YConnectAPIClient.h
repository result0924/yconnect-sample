//
//  APIClient.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectBearerToken.h"
#import "YConnectHttpClient.h"
#import "YConnectHttpHeaders.h"
#import "YConnectHttpParameters.h"
#import "YConnectError.h"

typedef void (^YConnectAPIClientResponseHandler)(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error);

@interface YConnectAPIClient : NSObject
@property (nonatomic, copy) NSString *responseBody;
@property (nonatomic, strong) YConnectHttpHeaders *responseHeaders;
@property (nonatomic, copy) NSString *requestBody;  //リクエストで送る本文
@property (nonatomic, strong) YConnectHttpHeaders *requestHeaders;
@property (nonatomic, strong) YConnectHttpParameters *parameters;

@property (nonatomic) BOOL isShouldMoveAccessTokenFromParameterToHeader;  //追加
@property (nonatomic) NSTimeInterval apiTimeout;

@property (nonatomic, retain) YConnectHttpClient *httpClient;

+ (NSString *)POST_METHOD;
+ (NSString *)GET_METHOD;
+ (NSString *)DELETE_METHOD;
+ (NSString *)PUT_METHOD;

- (id)init;
- (id)initWithAccessTokenString:(NSString *)accessToken;
- (id)initWithAccessToken:(YConnectBearerToken *)accessToken;
- (void)setParameter:(NSString *)name value:(NSString *)value;
- (void)setHeader:(NSString *)field value:(NSString *)value;
- (void)setAccessToken:(YConnectBearerToken *)accessToken;

- (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler;
- (void)post:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler;
- (void) delete:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler;
- (void)put:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler;

- (void)moveAccessTokenFromParameterToHeader;

- (void)cancel;

// 旧interface
- (void)execute:(NSString *)url method:(NSString *)method handler:(YConnectAPIClientResponseHandler)handler;
@end
