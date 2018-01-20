//
//  AuthorizationCallBackUriParser.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectAuthorizationCallBackUriParser.h"
#import "YConnectLog.h"
#import "YConnectError.h"
#import "YConnectConfig.h"
#import "NSNull+isNull.h"

/**
 * Authorizational Code flowでのコールバック処理
 **/
@implementation YConnectAuthorizationCallBackUriParser

+ (void)parseExplicitCallbackUri:(NSURL *)callbackUri uriScheme:(NSString *)uriScheme state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler
{
    NSError *error = nil;
    if (![self validateCallbackUri:callbackUri uriScheme:uriScheme error:&error]) {
        handler(nil, nil, error);
        return;
    }

    YConnectHttpParameters *params = [self extractParams:[callbackUri fragment]];
    if (![self validateParams:params state:state error:&error]) {
        handler(nil, nil, error);
        return;
    }

    NSString *authCodeString = [params objectForKey:@"code"];
    if ([NSNull isNull:authCodeString]) {
        YConnectLogDebug(@"%@: No authorization code parameters.", NSStringFromClass([self class]));
        error = [YConnectError connectionErrorWithErrorCode:nil description:@"No authorization code parameters"];
        handler(nil, nil, error);
        return;
    }

    NSString *idTokenString = [params objectForKey:@"id_token"];
    if ([NSNull isNull:idTokenString]) {
        YConnectLogDebug(@"%@: No id_token parameters.", NSStringFromClass([self class]));
        error = [YConnectError connectionErrorWithErrorCode:nil description:@"No id_token parameters"];
        handler(nil, nil, error);
        return;
    }

    handler(authCodeString, idTokenString, nil);
}

+ (void)parseImplicitCallbackUri:(NSURL *)callbackUri uriScheme:(NSString *)uriScheme state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler
{
    NSError *error = nil;
    if (![self validateCallbackUri:callbackUri uriScheme:uriScheme error:&error]) {
        handler(nil, nil, error);
        return;
    }

    YConnectHttpParameters *params = [YConnectAuthorizationCallBackUriParser extractParams:[callbackUri fragment]];

    if (![self validateParams:params state:(NSString *)state error:&error]) {
        handler(nil, nil, error);
        return;
    }

    NSString *accessTokenString = [params objectForKey:@"access_token"];
    NSString *expiresInString = [params objectForKey:@"expires_in"];
    YConnectBearerToken *accessToken;
    if ([NSNull isNull:accessTokenString] || [NSNull isNull:expiresInString]) {
        YConnectLogDebug(@"%@: No access_token or expires_in parameters.", NSStringFromClass([self class]));
        error = [YConnectError connectionErrorWithErrorCode:nil description:@"No access_token or expires_in parameters"];
        handler(nil, nil, error);
        return;
    }

    NSInteger expiration = [YConnectBearerToken expirationWithExpiresIn:[expiresInString longLongValue]];
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration];

    NSString *idToken = [params objectForKey:@"id_token"];
    if ([NSNull isNull:idToken]) {
        YConnectLogDebug(@"%@: Not found id_token parameter.", NSStringFromClass([self class]));
        error = [YConnectError connectionErrorWithErrorCode:nil description:@"Not found id_token parameter"];
        handler(nil, nil, error);
        return;
    }

    handler(accessToken, idToken, nil);
}

/**
 * コールバックされたURIの解析
 * @param NSURL *responseUri
 * @param NSError **error
 **/
+ (BOOL)validateParams:(YConnectHttpParameters *)params state:(NSString *)state error:(NSError **)error
{
    if (![NSNull isNull:[params objectForKey:@"error"]]) {
        NSString *errorDescription;
        NSString *errorCode = [params objectForKey:@"error"];
        if ([NSNull isNull:errorCode]) {
            errorCode = @"error";
        }
        errorDescription = [params objectForKey:@"error_description"];
        YConnectLogDebug(@"%@: error_code=%@ error_description=%@", NSStringFromClass([self class]), errorCode, errorDescription);
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:errorCode description:errorDescription];
        }
        return NO;
    }
    if ([params count] == 0) {
        YConnectLogDebug(@"%@: Not Found Authorization Parameters.", NSStringFromClass([self class]));
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Not Found Authorization Parameters"];
        }
        return NO;
    }

    if (![state isEqualToString:[params objectForKey:@"state"]]) {
        YConnectLogDebug(@"%@: Not match state.", NSStringFromClass([self class]));
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Not match state"];
        }
        return NO;
    }

    YConnectLogDebug(@"%@: Finished Parsing. %@", NSStringFromClass([self class]), params.toQueryString);
    return YES;
}

+ (BOOL)validateCallbackUri:(NSURL *)callbackUri uriScheme:(NSString *)uriScheme error:(NSError **)error
{
    if ([NSNull isNull:callbackUri]) {
        YConnectLogDebug(@"%@: Not Found Callback URI.", NSStringFromClass([self class]));
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Not Found Callback URI"];
        }
        return NO;
    }
    YConnectLogDebug(@"%@: Response Uri: %@", NSStringFromClass([self class]), callbackUri);

    if ([NSNull isNull:uriScheme]) {
        YConnectLogDebug(@"%@: Not Found URI Scheme.", NSStringFromClass([self class]));
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Not Found URI Scheme"];
        }
        return NO;
    }
    YConnectLogDebug(@"%@: URI Scheme: %@", NSStringFromClass([self class]), uriScheme);

    if (![[callbackUri absoluteString] hasPrefix:uriScheme]) {
        YConnectLogDebug(@"%@: Invalid Callback URI.", NSStringFromClass([self class]));
        if (error) {
            *error = [YConnectError connectionErrorWithErrorCode:nil description:@"Invalid Callback URI"];
        }
        return NO;
    }

    return YES;
}

+ (YConnectHttpParameters *)extractParams:(NSString *)query
{
    NSArray *keyValues = [query componentsSeparatedByString:@"&"];

    NSString *k, *v;
    YConnectHttpParameters *params = [[YConnectHttpParameters alloc] init];
    for (NSString *keyValue in keyValues) {
        NSArray *kv = [keyValue componentsSeparatedByString:@"="];
        if ([kv count] == 2) {
            k = [kv objectAtIndex:0];
            v = [kv objectAtIndex:1];
            [params setValue:v forKey:k];
            YConnectLogDebug(@"%@: Put parameter. %@=%@", NSStringFromClass([self class]), k, v);
        }
    }
    return params;
}

@end
