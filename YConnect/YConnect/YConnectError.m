//
//  YConnectError.m
//  YConnect
//
//  Created by 伊藤　雄哉 on 2014/04/16.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import "NSNull+isNull.h"
#import "YConnectError.h"
#import "YConnectLog.h"

NSString *const YConnectConnectionErrorDomain = @"jp.co.yahoo.login.yconnect.connection";
NSString *const YConnectIdTokenErrorDomain = @"jp.co.yahoo.login.yconnect.idtoken";

@implementation YConnectError

+ (NSError *)connectionErrorWithErrorCode:(NSString *)errorCode description:(NSString *)description
{
    NSInteger code;
    if ([errorCode isEqualToString:@"invalid_request"]) {
        code = YConnectErrorInvalidRequest;
    } else if ([errorCode isEqualToString:@"invalid_scope"]) {
        code = YConnectErrorInvalidScope;
    } else if ([errorCode isEqualToString:@"invalid_redirect_uri"]) {
        code = YConnectErrorInvalidRedirectUri;
    } else if ([errorCode isEqualToString:@"invalid_client"]) {
        code = YConnectErrorInvalidClient;
    } else if ([errorCode isEqualToString:@"invalid_grant"]) {
        code = YConnectErrorInvalidGrant;
    } else if ([errorCode isEqualToString:@"invalid_token"]) {
        code = YConnectErrorInvalidToken;
    } else if ([errorCode isEqualToString:@"login_required"]) {
        code = YConnectErrorLoginRequired;
    } else if ([errorCode isEqualToString:@"consent_required"]) {
        code = YConnectErrorConsentRequired;
    } else if ([errorCode isEqualToString:@"unsupported_grant_type"]) {
        code = YConnectErrorUnsupportedGrantType;
    } else if ([errorCode isEqualToString:@"unsupported_response_type"]) {
        code = YConnectErrorUnsupportedResponseType;
    } else if ([errorCode isEqualToString:@"unauthorized_client"]) {
        code = YConnectErrorUnauthorizedClient;
    } else if ([errorCode isEqualToString:@"access_denied"]) {
        code = YConnectErrorAccessDenied;
    } else if ([errorCode isEqualToString:@"server_error"]) {
        code = YConnectErrorServerError;
    } else if ([errorCode isEqualToString:@"insufficient_scope"]) {
        code = YConnectErrorInsufficientScope;
    } else {
        code = YConnectErrorUnexpectedError;
    }

    NSDictionary *userInfo = nil;
    if (![NSNull isNull:description]) {
        userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    }

    return [NSError errorWithDomain:YConnectConnectionErrorDomain code:code userInfo:userInfo];
}

+ (NSError *)idTokenVerificationErrorWithCode:(NSInteger)code description:(NSString *)description
{
    NSDictionary *userInfo = nil;
    if (![NSNull isNull:description]) {
        userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    }
    return [NSError errorWithDomain:YConnectIdTokenErrorDomain code:code userInfo:userInfo];
}

@end
