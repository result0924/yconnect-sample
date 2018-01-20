//
//  TokenClientTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectTokenClient.h"

@interface YConnectTokenClientTest : XCTestCase {
    NSString *endpointUrl;
    NSString *clientId;
    NSString *authorizationCode;
    NSString *redirectUri;
    NSString *idToken;
    YConnectTokenClient *client;
    YConnectBearerToken *accessToken;
    NSString *refreshToken;
    NSString *accessTokenString;
    long expiration;

    YConnectTokenClient *tokenClient;
}

- (void)testFetchTokenWithAuthorizationCode;
- (void)testFetchTokenWithAuthorizationCodeWith400Code;
- (void)testFetchTokenWithAuthorizationCodeWith400CodeAndInvalidFormatResponse;
- (void)testFetchTokenWithAuthorizationCodeWith401Code;

- (void)testRefreshAccessTokenWithRefreshToken;
- (void)testRefreshAccessTokenWithRefreshTokenWith400Code;
- (void)testRefreshAccessTokenWithRefreshTokenWith400CodeAndInvalidFormatResponse;
- (void)testRefreshAccessTokenWithRefreshTokenWith401Code;
@end
