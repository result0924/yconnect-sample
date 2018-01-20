//
//  UserInfoClientTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectUserInfoClient.h"

@interface YConnectUserInfoClientTest : XCTestCase {
    NSString *accessTokenString;
    YConnectBearerToken *accessToken;
    NSString *json;
    NSString *userId;

    YConnectUserInfoClient *userInfoClient;
}

- (void)testInitWithAccessToken;
- (void)testInitWithAccessTokenString;
- (void)testFetch;
- (void)testFetchWith400Code;
- (void)testFetchWithInvalidUserInfo;

@end
