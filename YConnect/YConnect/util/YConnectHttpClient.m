//
//  HttpClient.m
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectHttpClient.h"
#import "YConnectLog.h"
#import "NSNull+isNull.h"

static BOOL checkSSL = true;  //default true

/**
 * 証明書の検証
 * リリース時には削除(必須!!)
 **/
@implementation NSURLRequest (SSL)
/**
 * 証明書の検証の実行
 * @param NSString *host
 * @return YESを返す場合は証明書を無視、NOは証明書を確認する
 **/
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    if (checkSSL) {
        return NO;
    } else {
        return YES;
    }
}
@end

/** 
 * Http通信を行うクラス
 **/
@implementation YConnectHttpClient

/**
 * 初期化
 **/
- (id)init
{
    self = [super init];
    if (self) {
        _responseBody = @"";
        _responseHeaders = [[YConnectHttpHeaders alloc] init];
    }
    return self;
}

/**
 * GETによる通信(非同期リクエスト)
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param HttpClientResponseHandler handler
 **/
- (void)requestGet:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler
{
    [self requestCommon:urlString parameters:parameters requestHeaders:requestHeaders httpMethod:@"GET" hander:handler];
}

/**
 * POSTによる通信(非同期リクエスト)
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param HttpClientResponseHandler handler
 **/
- (void)requestPost:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler
{
    [self requestCommon:urlString parameters:parameters requestHeaders:requestHeaders httpMethod:@"POST" hander:handler];
}

/**
 * PUTによる通信(非同期リクエスト)
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param HttpClientResponseHandler handler
 **/
- (void)requestPut:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler
{
    [self requestCommon:urlString parameters:parameters requestHeaders:requestHeaders httpMethod:@"PUT" hander:handler];
}

/**
 * DELETEによる通信(非同期リクエスト)
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param HttpClientResponseHandler handler
 **/
- (void)requestDelete:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders handler:(HttpClientResponseHandler)handler
{
    [self requestCommon:urlString parameters:parameters requestHeaders:requestHeaders httpMethod:@"DELETE" hander:handler];
}

/**
 * GET,POST,PUT,DELETEの共通通信メソッド(非同期リクエスト)
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param NSString *httpMethod [Description]
 * @param HttpClientResponseHandler handler
 **/
- (void)requestCommon:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders httpMethod:(NSString *)httpMethod hander:(HttpClientResponseHandler)handler
{
    NSURLRequest *request = [self getURLRequestWithURLString:urlString parameters:parameters requestHeaders:requestHeaders httpMethod:httpMethod];

    // 取得データを格納
    self.handler = handler;

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue currentQueue]];
    self.task = [session dataTaskWithRequest:request
                           completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

                             // StatusCodeの取得
                             self.responseCode = [((NSHTTPURLResponse *)response)statusCode];

                             NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                             NSString *value, *key;
                             for (key in [headers allKeys]) {
                                 value = [headers objectForKey:key];
                                 if (value != nil) {
                                     [self.responseHeaders setValue:value forKey:key];
                                 }
                             }
                             YConnectLogDebug(@"%@: Response Headers:\n%@", NSStringFromClass([self class]), self.responseHeaders.toHeaderString);

                             if (error) {
                                 YConnectLogDebug(@"error: %@", [error localizedDescription]);
                                 self.handler(nil, (int)nil, nil, error);
                                 return;
                             } else {
                                 YConnectLogDebug(@"%@", data);
                                 self.responseBody = [[NSString alloc] initWithData:data
                                                                           encoding:NSUTF8StringEncoding];
                                 self.handler(self.responseBody, self.responseCode, self.responseHeaders, nil);
                             }

                             [session invalidateAndCancel];
                           }];
    [self.task resume];
}

/**
 * URLリクエストを作成する
 * @param NSString *urlString
 * @param HttpParameters *parameters
 * @param HttpHeaders *requestHeaders
 * @param NSString *httpMethod [Description]
 **/
- (NSURLRequest *)getURLRequestWithURLString:(NSString *)urlString parameters:(YConnectHttpParameters *)parameters requestHeaders:(YConnectHttpHeaders *)requestHeaders httpMethod:(NSString *)httpMethod
{
    //URLリクエスト作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:httpMethod];

    if ([httpMethod isEqualToString:@"GET"] || [httpMethod isEqualToString:@"DELETE"]) {
        //URLの作成
        //GETパラメータを整形して取得
        NSString *queryString = [parameters toQueryString];
        if (![NSNull isNull:queryString]) {
            urlString = [urlString stringByAppendingFormat:@"?%@", queryString];
        }
    } else {
        //リクエストパラメータ設定
        [request setHTTPBody:[[parameters toQueryString] dataUsingEncoding:NSUTF8StringEncoding]];
        YConnectLogDebug(@"%@: Parameters: %@", NSStringFromClass([self class]), [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);

        //リクエストに本文のセット
        if (![NSNull isNull:self.requestBody]) {
            // *リクエストパラメータを上書きする
            if ([self.requestBody isKindOfClass:[NSData class]]) {
                [request setHTTPBody:self.requestBody];
                YConnectLogDebug(@"%@: Body: %@", NSStringFromClass([self class]), self.requestBody);
            } else if ([self.requestBody isKindOfClass:[NSString class]]) {
                [request setHTTPBody:[self.requestBody dataUsingEncoding:NSUTF8StringEncoding]];
                YConnectLogDebug(@"%@: Body: %@", NSStringFromClass([self class]), self.requestBody);
            }
        }
    }

    YConnectLogDebug(@"%@: URL:%@", NSStringFromClass([self class]), urlString);

    if ([urlString hasPrefix:@"https"]) {
        YConnectLogDebug(@"%@: HTTPS", NSStringFromClass([self class]));
        YConnectLogDebug(@"%@: SSLCheck = %@", NSStringFromClass([self class]), checkSSL == YES ? @"YES" : @"NO");
    } else {
        YConnectLogDebug(@"%@: HTTP", NSStringFromClass([self class]));
    }

    NSURL *url = [NSURL URLWithString:urlString];
    [request setURL:url];

    //リクエストヘッダ設定
    NSString *value;
    for (NSString *key in [requestHeaders allKeys]) {
        value = [requestHeaders objectForKey:key];
        [request addValue:value forHTTPHeaderField:key];
    }
    YConnectLogDebug(@"%@: Headers: %@", NSStringFromClass([self class]), requestHeaders.toHeaderString);

    //タイムアウトのセット
    //(iOS6以前だと、「POSTでかつリクエストのボディが空でない」場合は設定が無視され、240秒になってしまう)
    if (self.timeout != 0) {
        [request setTimeoutInterval:self.timeout];
    }
    self.timeout = [request timeoutInterval];
    YConnectLogDebug(@"%@: Timeout: %f", NSStringFromClass([self class]), self.timeout);

    return request;
}

/**
 * 証明書検証を有効化
 **/
+ (void)enableSSLCheck
{
    checkSSL = YES;
}
/**
 * 証明書検証を無効化
 **/
+ (void)disableSSLCheck
{
    checkSSL = NO;
}

@end
