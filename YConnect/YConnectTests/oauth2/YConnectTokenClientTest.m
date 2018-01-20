//
//  TokenClientTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectError.h"
#import "YConnectTokenClientTest.h"

@implementation YConnectTokenClientTest

- (void)setUp
{
    [super setUp];
    client = [[YConnectTokenClient alloc] init];
    endpointUrl = @"http://www.yahoo.co.jp";
    clientId = @"qwerty";
    authorizationCode = @"asdfgh";
    redirectUri = @"http://redirect.com";
    idToken = @"zxcvbn";
    accessTokenString = @"asdfgh";
    refreshToken = @"poiuyt";
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration refreshToken:refreshToken];
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

/**
 * (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode redirectUri:(NSString *)redirectUri clientId:(NSString *)clientId handler:(YConnectTokenClientResponseHandler)handler
 * @test エラーでないことを確認(正常系)
 **/
- (void)testFetchTokenWithAuthorizationCode
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_success.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];
    expiration = 3600L + (long)floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - 60L;

    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    __block NSString *actualIdToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client fetchTokenWithAuthorizationCode:authorizationCode redirectUri:redirectUri clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSString *retIdToken, NSError *error) {
      err = error;
      actualAccessToken = retAccessToken;
      actualIdToken = retIdToken;
      XCTAssertNil(err, @"error is nil");
      XCTAssertNil(error, @"error is nil");
      XCTAssertEqualObjects(idToken, actualIdToken, @"not match idToken");
      XCTAssertEqualObjects(accessTokenString, actualAccessToken.accessToken, @"accessTokenString not match");
      XCTAssertEqual(expiration, actualAccessToken.expiration, @"expiration not match");
      XCTAssertEqualObjects(refreshToken, actualAccessToken.refreshToken, @"refreshToken not match");
      XCTAssertNil(actualAccessToken.scope, @"scope not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode redirectUri:(NSString *)redirectUri clientId:(NSString *)clientId handler:(YConnectTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:400)
 **/
- (void)testFetchTokenWithAuthorizationCodeWith400Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client fetchTokenWithAuthorizationCode:authorizationCode redirectUri:redirectUri clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSString *retIdToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode redirectUri:(NSString *)redirectUri clientId:(NSString *)clientId handler:(YConnectTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:400、不正なフォーマットのレスポンス)
 **/
- (void)testFetchTokenWithAuthorizationCodeWith400CodeAndInvalidFormatResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client fetchTokenWithAuthorizationCode:authorizationCode redirectUri:redirectUri clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSString *retIdToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)fetchTokenWithAuthorizationCode:(NSString *)authorizationCode redirectUri:(NSString *)redirectUri clientId:(NSString *)clientId handler:(YConnectTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:401)
 **/
- (void)testFetchTokenWithAuthorizationCodeWith401Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:401
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client fetchTokenWithAuthorizationCode:authorizationCode redirectUri:redirectUri clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSString *retIdToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken clientId:(NSString *)clientId handler:(YConnectRefreshTokenClientResponseHandler)handler
 * @test エラーでないことを確認(正常系)
 **/
- (void)testRefreshAccessTokenWithRefreshToken
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_refresh_success.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];
    expiration = 3600L + (long)floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - 60L;

    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client refreshAccessTokenWithRefreshToken:refreshToken clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      actualAccessToken = retAccessToken;
      XCTAssertNil(err, @"error is nil");
      XCTAssertEqualObjects(accessTokenString, actualAccessToken.accessToken, @"accessTokenString not match");
      XCTAssertEqual(expiration, actualAccessToken.expiration, @"expiration not match");
      XCTAssertEqualObjects(refreshToken, actualAccessToken.refreshToken, @"refreshToken not match");
      XCTAssertNil(actualAccessToken.scope, @"scope not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken clientId:(NSString *)clientId handler:(YConnectRefreshTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:400)
 **/
- (void)testRefreshAccessTokenWithRefreshTokenWith400Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client refreshAccessTokenWithRefreshToken:refreshToken clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken clientId:(NSString *)clientId handler:(YConnectRefreshTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:400、不正なフォーマットのレスポンス)
 **/
- (void)testRefreshAccessTokenWithRefreshTokenWith400CodeAndInvalidFormatResponse
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client refreshAccessTokenWithRefreshToken:refreshToken clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
    XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
}

/**
 * (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken clientId:(NSString *)clientId handler:(YConnectRefreshTokenClientResponseHandler)handler
 * @test エラーであることを確認(異常系、statusCode:401)
 **/
- (void)testRefreshAccessTokenWithRefreshTokenWith401Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:401
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client refreshAccessTokenWithRefreshToken:refreshToken clientId:clientId handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
