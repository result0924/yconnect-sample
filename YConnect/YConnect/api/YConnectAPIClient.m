//
//  APIClient.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectAPIClient.h"
#import "YConnectLog.h"
#import "NSNull+isNull.h"

static NSString *const POST_METHOD = @"POST";
static NSString *const GET_METHOD = @"GET";
static NSString *const DELETE_METHOD = @"DELETE";
static NSString *const PUT_METHOD = @"PUT";
static NSTimeInterval const DEFAULT_TIMEOUT = 60.0;  // デフォルトタイムアウト

/**
 * APIにアクセスする
 **/
@implementation YConnectAPIClient

void (^_checkResponse)(NSString *responseBody, NSInteger *statusCode, YConnectHttpHeaders *headers, NSError *error);
typedef void (^responseHandler)(NSString *responseBody, NSInteger *statusCode, YConnectHttpHeaders *headers, NSError *error);

/**
 * POST_METHODの静的取得
 * @return NSString * @"POST"
 **/
+ (NSString *)POST_METHOD
{
    return POST_METHOD;
}
/**
 * GET_METHODの静的取得
 * @return NSString * @"GET"
 **/
+ (NSString *)GET_METHOD
{
    return GET_METHOD;
}
/**
 * DELETE_METHODの静的取得
 * @return NSString * @"DELETE"
 **/
+ (NSString *)DELETE_METHOD
{
    return DELETE_METHOD;
}
/**
 * PUT_METHODの静的取得
 * @return NSString * @"PUT"
 **/
+ (NSString *)PUT_METHOD
{
    return PUT_METHOD;
}

/**
 * 初期化
 * @return id
 **/
- (id)init
{
    self = [super init];
    if (self) {
        _parameters = [[YConnectHttpParameters alloc] init];
        _requestHeaders = [[YConnectHttpHeaders alloc] init];
        _isShouldMoveAccessTokenFromParameterToHeader = true;
        _httpClient = [[YConnectHttpClient alloc] init];
    }
    return self;
}
/**
 * アクセストークン(NSString)を用いた初期化
 * @param NSString *accessToken
 * @return id
 **/
- (id)initWithAccessTokenString:(NSString *)accessToken
{
    self = [super init];
    if (self) {
        _parameters = [[YConnectHttpParameters alloc] init];
        _requestHeaders = [[YConnectHttpHeaders alloc] init];
        [self setParameter:@"access_token" value:accessToken];
        _isShouldMoveAccessTokenFromParameterToHeader = true;
        _httpClient = [[YConnectHttpClient alloc] init];
    }
    return self;
}
/**
 * アクセストークンを用いた初期化
 * @param BearerToken *accessToken
 * @return id
 **/
- (id)initWithAccessToken:(YConnectBearerToken *)accessToken
{
    self = [super init];
    if (self) {
        _parameters = [[YConnectHttpParameters alloc] init];
        _requestHeaders = [[YConnectHttpHeaders alloc] init];
        [self setParameter:@"access_token" value:accessToken.accessToken];
        _isShouldMoveAccessTokenFromParameterToHeader = true;
        _httpClient = [[YConnectHttpClient alloc] init];
    }
    return self;
}

- (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
{
    YConnectLogDebug(@"GET");
    [self prepare];
    [self.httpClient requestGet:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
}

- (void)post:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
{
    YConnectLogDebug(@"POST");
    [self prepare];
    self.httpClient.requestBody = self.requestBody;
    [self.httpClient requestPost:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
}

- (void)delete:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
{
    YConnectLogDebug(@"DELETE");
    [self prepare];
    [self.httpClient requestDelete:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
}

- (void)put:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
{
    YConnectLogDebug(@"PUT");
    [self prepare];
    self.httpClient.requestBody = self.requestBody;
    [self.httpClient requestPut:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
}

- (void)prepare
{
    //accessTokenをパラメータではなくヘッダに記述する場合
    if (self.isShouldMoveAccessTokenFromParameterToHeader) {
        [self moveAccessTokenFromParameterToHeader];
    }
    if (self.apiTimeout) {
        self.httpClient.timeout = self.apiTimeout;
    } else {
        self.httpClient.timeout = DEFAULT_TIMEOUT;
    }
}

- (id)generateHandler:(YConnectAPIClientResponseHandler)handler
{
    return ^(NSString *responseBody, NSInteger *statusCode, YConnectHttpHeaders *headers, NSError *error) {
        if (error) {
            handler(nil, nil, error);
            return;
        }
        YConnectLogDebug(@"response body: %@", responseBody);
        NSString *wwwAuthHeader = [headers objectForKey:@"Www-Authenticate"];
        YConnectLogDebug(@"Headers: %@", [headers toHeaderString]);
        if((int)statusCode < 200 || (int)statusCode >= 300) {
            YConnectLogDebug(@"status code is not 2xx");
            if([wwwAuthHeader length] > 0) {
                YConnectLogDebug(@"Www-Authenticate Header: %@", wwwAuthHeader);
                NSArray *parameters = [wwwAuthHeader componentsSeparatedByString:@","];
                
                NSMutableArray *keys = [NSMutableArray array];
                NSMutableArray *vals = [NSMutableArray array];
                for (int i = 0; i < [parameters count]; i++) {
                    NSString *parameter = [[parameters objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *kv = [parameter componentsSeparatedByString:@"="];
                    [keys addObject:[[kv objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [vals addObject:[[kv objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                }
                NSDictionary *wwwAuthHeaderDict = [[NSDictionary alloc] initWithObjects:vals forKeys:keys];
                NSString *errorCode = [wwwAuthHeaderDict objectForKey:@"error"];
                NSString *errorDescription = [wwwAuthHeaderDict objectForKey:@"error_description"];
                YConnectLogDebug(@"_checkResponse: %@ / %@", errorCode, errorDescription);
                error = [YConnectError connectionErrorWithErrorCode:errorCode description:errorDescription];
            } else {
                YConnectLogDebug(@"_checkResponse: An unexpected error has occurred.");
                error = [YConnectError connectionErrorWithErrorCode:nil description:@"An unexpected error has occurred"];
            }
            handler(nil, nil, error);
        } else {
            handler(responseBody, headers, nil);
        }
    };
}

/**
 * リクエストパラメータにセット
 * @param NSString *name パラメータ名(キー)
 * @param NSString *value
 **/
- (void)setParameter:(NSString *)name value:(NSString *)value
{
    [self.parameters setValue:value forKey:name];
}

/**
 * リクエストヘッダにセット
 * @param NSString *field フィールド名(キー)
 * @param NSString *value
 **/
- (void)setHeader:(NSString *)field value:(NSString *)value
{
    //コロンの除去
    field = [field stringByReplacingOccurrencesOfString:@":" withString:@""];
    //文字列の両端の空白を除去
    field = [field stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.requestHeaders setValue:value forKey:field];
}

/**
 * リクエストパラメータにアクセストークンをセット
 * @param accessToken
 **/
- (void)setAccessToken:(YConnectBearerToken *)accessToken
{
    [self setParameter:@"access_token" value:accessToken.accessToken];
}

/**
 * accessTokenをリクエストパラメータからリクエストヘッダへ移動する
 **/
- (void)moveAccessTokenFromParameterToHeader
{
    NSString *key = @"access_token";
    NSString *accessToken = [self.parameters objectForKey:key];
    if (![NSNull isNull:accessToken]) {
        [self.requestHeaders setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];  //ヘッダに追加
        [self.parameters.nsMutableDictionary removeObjectForKey:key];                                                  //パラメータから削除
    }
}

- (void)cancel
{
    if (self.httpClient && self.httpClient.task) {
        [self.httpClient.task cancel];
    }
}

// 旧interface
/**
 * URLとそのときのメソッドを指定して非同期通信を行う
 * @param NSString *url
 * @param NSString *method @"GET",@"POST",@"DELETE",@"PUT"(小文字でも可)
 * @param YConnectAPIClientResponseHandler handler
 **/

- (void)execute:(NSString *)url method:(NSString *)method handler:(YConnectAPIClientResponseHandler)handler
{
    [self prepare];

    //大文字小文字を無視したメソッドの判定
    if ([POST_METHOD caseInsensitiveCompare:method] == NSOrderedSame) {
        YConnectLogDebug(@"POST");
        self.httpClient.requestBody = self.requestBody;
        [self.httpClient requestPost:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
    } else if ([GET_METHOD caseInsensitiveCompare:method] == NSOrderedSame) {
        YConnectLogDebug(@"GET");
        [self.httpClient requestGet:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
    } else if ([DELETE_METHOD caseInsensitiveCompare:method] == NSOrderedSame) {
        YConnectLogDebug(@"DELETE");
        [self.httpClient requestDelete:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
    } else if ([PUT_METHOD caseInsensitiveCompare:method] == NSOrderedSame) {
        YConnectLogDebug(@"PUT");
        self.httpClient.requestBody = self.requestBody;
        [self.httpClient requestPut:url parameters:self.parameters requestHeaders:self.requestHeaders handler:[self generateHandler:handler]];
    } else {
        YConnectLogDebug(@"%@: Undefined Http method", NSStringFromClass([self class]));
        //例外をスロー
        @throw [[NSException alloc] initWithName:@"MethodError" reason:@"Undefined Http method." userInfo:nil];
    }
}

@end
