//
//  TokenClient.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectTokenClient.h"
#import "YConnectLog.h"
#import "YConnectConfig.h"
#import "YConnectError.h"

@implementation YConnectTokenClient

- (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode redirectUri:(NSString *)redirectUri clientId:(NSString *)clientId handler:(YConnectTokenClientResponseHandler)handler
{
    YConnectHttpParameters *parameters = [[YConnectHttpParameters alloc] init];
    [parameters setValue:YConnectConfigGrantTypeAuthorizationCode forKey:@"grant_type"];
    [parameters setValue:authorizationCode forKey:@"code"];
    [parameters setValue:redirectUri forKey:@"redirect_uri"];
    [parameters setValue:clientId forKey:@"client_id"];

    YConnectHttpHeaders *requestHeaders = [[YConnectHttpHeaders alloc] init];
    [requestHeaders setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forKey:@"Content-Type"];

    YConnectHttpClient *client = [[YConnectHttpClient alloc] init];
    [client requestPost:YConnectConfigTokenEndpoint parameters:parameters requestHeaders:requestHeaders handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *headers, NSError *error) {
        if (error) {
            handler(nil, nil, error);
            return;
        }
        
        YConnectLogDebug(@"%@: %@", NSStringFromClass([self class]), responseBody);
        YConnectLogDebug(@"%@: %@", NSStringFromClass([self class]), [headers toHeaderString]);
        
        NSDictionary *jsonObject = [self parseResponse:responseBody statusCode:statusCode error:&error];
        if (error) {
            handler(nil, nil, error);
            return;
        }
        
        NSString *accessTokenString = [jsonObject objectForKey:@"access_token"];
        NSInteger expiresIn = [[jsonObject objectForKey:@"expires_in"] longLongValue];
        NSInteger expiration = [YConnectBearerToken expirationWithExpiresIn:expiresIn];
        NSString *refreshToken = [jsonObject objectForKey:@"refresh_token"];
        YConnectBearerToken *accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration refreshToken:refreshToken];
        
        NSString *idToken = [jsonObject objectForKey:@"id_token"];
        handler(accessToken, idToken, nil);
    }];
}

- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken clientId:(NSString *)clientId handler:(YConnectRefreshTokenClientResponseHandler)handler;
{
    YConnectHttpParameters *parameters = [[YConnectHttpParameters alloc] init];
    [parameters setValue:YConnectConfigGrantTypeRefreshToken forKey:@"grant_type"];
    [parameters setValue:refreshToken forKey:@"refresh_token"];
    [parameters setValue:clientId forKey:@"client_id"];

    YConnectHttpHeaders *requestHeaders = [[YConnectHttpHeaders alloc] init];
    [requestHeaders setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forKey:@"Content-Type"];

    YConnectHttpClient *client = [[YConnectHttpClient alloc] init];
    [client requestPost:YConnectConfigTokenEndpoint parameters:parameters requestHeaders:requestHeaders handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
        if (error) {
            handler(nil, error);
            return;
        }
        
        YConnectLogDebug(@"%@: %@", NSStringFromClass([self class]), responseBody);
        YConnectLogDebug(@"%@: %@", NSStringFromClass([self class]), [heaedrs toHeaderString]);
        
        NSDictionary *jsonObject = [self parseResponse:responseBody statusCode:statusCode error:&error];
        if (error) {
            handler(nil, error);
            return;
        }
        
        NSString *accessTokenString = [jsonObject objectForKey:@"access_token"];
        NSInteger expiresIn = [[jsonObject objectForKey:@"expires_in"] longLongValue];
        NSInteger expiration = [YConnectBearerToken expirationWithExpiresIn:expiresIn];
        
        YConnectBearerToken *accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration refreshToken:refreshToken];
        
        handler(accessToken, nil);
    }];
}

- (NSDictionary *)parseResponse:(NSString *)responseBody statusCode:(NSInteger)statusCode error:(NSError **)error
{
    NSDictionary *jsonObject = [NSJSONSerialization
        JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding]
                   options:NSJSONReadingAllowFragments
                     error:error];
    if (*error) {
        return nil;
    }

    [self checkErrorResponse:statusCode jsonObject:jsonObject error:error];

    if (*error) {
        return nil;
    }

    return jsonObject;
}

- (BOOL)checkErrorResponse:(NSInteger)statusCode jsonObject:(NSDictionary *)jsonObject error:(NSError **)error
{
    if (statusCode != 200) {
        NSString *errorCode = [jsonObject objectForKey:@"error"];
        if ([errorCode length] > 0) {
            NSString *errorDescription = [jsonObject objectForKey:@"error_description"];
            YConnectLogDebug(@"%@: %@ / %@", NSStringFromClass([self class]), errorCode, errorDescription);

            if (error) {
                *error = [YConnectError connectionErrorWithErrorCode:errorCode description:errorDescription];
            }
        } else {
            YConnectLogDebug(@"%@: An unexpected error has occurred.", NSStringFromClass([self class]));
            if (error) {
                *error = [YConnectError connectionErrorWithErrorCode:nil description:@"An unexpected error has occurred"];
            }
        }
        return NO;
    }
    return YES;
}

@end
