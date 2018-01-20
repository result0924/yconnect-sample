//
//  RefreshTokenClientTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectRefreshTokenClient.h"

@interface YConnectRefreshTokenClientTest : XCTestCase {
    NSString *endpointUrl;
    NSString *clientId;
    YConnectBearerToken *accessToken;
    NSString *refreshToken;
    NSString *accessTokenString;
    YConnectHttpClient *client;
    long expiration;
    
    YConnectRefreshTokenClient *refreshTokenClient;
}

- (void)testInitWithEndpointUrl;
- (void)testFetch;
- (void)testGetAccessToken;
- (void)testGetAccessTokenNoAccessToken;
@end
