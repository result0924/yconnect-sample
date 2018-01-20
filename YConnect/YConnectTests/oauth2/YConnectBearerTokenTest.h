//
//  BearerTokenTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectBearerToken.h"

@interface YConnectBearerTokenTest : XCTestCase {
    NSString *accessToken;
    NSInteger expiresIn;
    NSInteger expiration;
    NSString *refreshToken;
    NSString *scope;

    YConnectBearerToken *bearerToken;
}

- (void)testInitWithParameters;
- (void)testInitWithParametersIncludeRefreshToken;
- (void)testInitWithParametersIncludeScope;
- (void)testToAuthorizationHeader;
- (void)testToQueryString;
- (void)testToString;
- (void)testToStringIncludeRefreshToken;
- (void)testToStringIncludeScope;
- (void)testExpirationWithExpiresIn;
@end
