//
//  RefreshTokenClientTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectRefreshTokenClientTest.h"

@implementation YConnectRefreshTokenClientTest

- (void)setUp
{
    [super setUp];
    endpointUrl = @"http://www.yahoo.co.jp";
    clientId = @"qwerty";
    accessTokenString = @"asdfgh";
    refreshToken = @"zxcvbn";
    expiration = [YConnectBearerToken expirationWithExpiresIn:3600L];
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration];
}

/**
 * (id)initWithEndpointUrl
 * @test エンドポイントのURLとclient idを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithEndpointUrl {
    refreshTokenClient = [[YConnectRefreshTokenClient alloc] initWithEndpointUrl:endpointUrl refreshToken:refreshToken clientId:clientId];
    XCTAssertEqual(endpointUrl, refreshTokenClient.endpointUrl, @"endpointUrl not match");
    XCTAssertEqual(refreshToken, refreshTokenClient.refreshToken, @"refreshToken not match");
    XCTAssertEqual(clientId, refreshTokenClient.clientId, @"clientId not match");
}

/**
 * (void)fetch
 * @test
 **/
- (void)testFetch {
    // TODO
}

/**
 * (BearerToken *)getAccessToken:(NSString *)state
 * @test トークンを取得し、各パラメータが正しいか(正常系)
 **/
- (void)testGetAccessToken {
    refreshTokenClient = [[YConnectRefreshTokenClient alloc] initWithEndpointUrl:endpointUrl refreshToken:refreshToken clientId:clientId];
    refreshTokenClient.accessToken = accessToken;
    XCTAssertEqualObjects(refreshTokenClient.accessToken, accessToken, @"not match accessToken");
    
    XCTAssertEqualObjects(accessToken, refreshTokenClient.accessToken, @"accessToken not match");
    XCTAssertEqual(accessTokenString, refreshTokenClient.accessToken.accessToken, @"accessTokenString not match");
    XCTAssertEqual(expiration, refreshTokenClient.accessToken.expiration, @"expiration not match");
    XCTAssertNil(refreshTokenClient.accessToken.refreshToken, @"refreshToken not nil");
    XCTAssertNil(refreshTokenClient.accessToken.scope, @"scope not nil");
}

/**
 * (BearerToken *)getAccessToken:(NSString *)state
 * @test トークンを取得し、各パラメータが正しいか(異常系、access token無し)
 **/
- (void)testGetAccessTokenNoAccessToken {
    refreshTokenClient = [[YConnectRefreshTokenClient alloc] initWithEndpointUrl:endpointUrl refreshToken:refreshToken clientId:clientId];
    refreshTokenClient.accessToken = nil;
    XCTAssertNil(refreshTokenClient.accessToken, @"access token not nil");
}

@end
