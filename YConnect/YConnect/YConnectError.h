//
//  YConnectError.h
//  YConnect
//
//  Created by 伊藤　雄哉 on 2014/04/16.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YConnectConnectionErrorDomain;
extern NSString *const YConnectIdTokenErrorDomain;

typedef NS_ENUM(NSInteger, YConnectErrorCode) {
    YConnectErrorInvalidRequest = 1,
    YConnectErrorInvalidScope,
    YConnectErrorInvalidRedirectUri,
    YConnectErrorInvalidClient,
    YConnectErrorInvalidGrant,
    YConnectErrorInvalidToken,
    YConnectErrorLoginRequired,
    YConnectErrorConsentRequired,
    YConnectErrorUnsupportedGrantType,
    YConnectErrorUnsupportedResponseType,
    YConnectErrorUnauthorizedClient,
    YConnectErrorAccessDenied,
    YConnectErrorServerError,
    YConnectErrorInsufficientScope,
    YConnectErrorUnexpectedError = 999,
};

typedef NS_ENUM(NSInteger, YConnectIdTokenVerificationErrorCode) {
    YConnectErrorInvalidIssuer = 1,
    YConnectErrorInvalidNonce,
    YConnectErrorInvalidAudience,
    YConnectErrorExpiredIdToken,
    YConnectErrorOverAcceptableRange,
    YConnectErrorInvalidSignature,
};

@interface YConnectError : NSError
+ (NSError *)connectionErrorWithErrorCode:(NSString *)errorCode description:(NSString *)description;
+ (NSError *)idTokenVerificationErrorWithCode:(NSInteger)code description:(NSString *)description;
@end
