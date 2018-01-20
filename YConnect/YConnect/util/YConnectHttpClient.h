//
//  HttpClient.h
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YConnectHttpParameters.h"
#import "YConnectHttpHeaders.h"

@class YConnectHttpClient;

typedef void (^HttpClientResponseHandler)(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error);

@interface YConnectHttpClient : NSObject
@property (nonatomic, assign) NSInteger responseCode;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) YConnectHttpHeaders *responseHeaders;
@property (nonatomic, copy) NSString *responseBody;
//リクエストに追加する本文
@property (nonatomic, strong) id requestBody;
//接続タイムアウト(デフォルト60秒)
@property (nonatomic) NSTimeInterval timeout;

//非同期リクエスト
@property (nonatomic, copy) HttpClientResponseHandler handler;

//非同期リクエスト
- (void)requestGet:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler;
- (void)requestPost:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler;
- (void)requestPut:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler;
- (void)requestDelete:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler;

+ (void)enableSSLCheck;
+ (void)disableSSLCheck;
@end
