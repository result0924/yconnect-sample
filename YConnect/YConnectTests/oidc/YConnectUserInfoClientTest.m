//
//  UserInfoClientTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectError.h"
#import "YConnectUserInfoClientTest.h"

@implementation YConnectUserInfoClientTest

- (void)setUp
{
    [super setUp];
    accessTokenString = @"qwertyuiop";
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:100L];
    userId = @"chkminiyj_yconnect_ios_test1";
    json = @"{"
            "\"user_id\":\"chkminiyj_yconnect_ios_test1\","
            "\"locale\":\"ja_JP\","
            "\"name\":\"矢風太郎\","
            "\"given_name\":\"太郎\","
            "\"given_name#ja-Kana-JP\":\"タロウ\","
            "\"given_name#ja-Hani-JP\":\"太郎\","
            "\"family_name\":\"矢風\","
            "\"family_name#ja-Kana-JP\":\"ヤフウ\","
            "\"family_name#ja-Hani-JP\":\"矢風\","
            "\"email\":\"yahootaro@example.com\","
            "\"email_verified\":\"true\","
            "\"gender\":\"male\","
            "\"birthday\":\"01/01/1970\","
            "\"address\":{"
            "\"country\":\"jp\","
            "\"postal_code\":\"1076211\","
            "\"region\":\"東京都\","
            "\"locality\":\"港区\","
            "\"street_address\":\"赤坂９丁目７-1\""
            "},"
            "\"phone_number\":\"0364406000\""
            "}";
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

/**
 * (id) initWithAccessTokenString:(NSString *)accessToken
 * @test アクセストークンを入力して、初期化できているか（正常系）
 **/
- (void)testInitWithAccessTokenString
{
    userInfoClient = [[YConnectUserInfoClient alloc] initWithAccessTokenString:accessTokenString];
    XCTAssertTrue([userInfoClient.requestHeaders count] == 0, @"UserInfoClient request headers not initialize");
    XCTAssertTrue(userInfoClient.isShouldMoveAccessTokenFromParameterToHeader, @"UserInfoClient accessToken  move flag not true");
    XCTAssertTrue([userInfoClient.parameters count] == 1, @"UserInfoClient parameters not initialize");
    XCTAssertEqualObjects([userInfoClient.parameters objectForKey:@"access_token"], accessTokenString, @"accessToken not set");
}

/**
 * (id) initWithAccessToken:(BearerToken *)accessToken
 * @test アクセストークン群を入力して、初期化できているか（正常系）
 **/
- (void)testInitWithAccessToken
{
    userInfoClient = [[YConnectUserInfoClient alloc] initWithAccessToken:accessToken];
    XCTAssertTrue([userInfoClient.requestHeaders count] == 0, @"UserInfoClient request headers not initialize");
    XCTAssertTrue(userInfoClient.isShouldMoveAccessTokenFromParameterToHeader, @"UserInfoClient accessToken  move flag not true");
    XCTAssertTrue([userInfoClient.parameters count] == 1, @"UserInfoClient parameters not initialize");
    XCTAssertEqualObjects([userInfoClient.parameters objectForKey:@"access_token"], accessTokenString, @"accessToken not set");
}

/**
 * (void)fetch:(YConnectUserInfoClientResponseHandler)handler
 * @test GETで通信を行い、アクセストークンをGETパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testFetch
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"userinfo_endpoint_success.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    userInfoClient = [[YConnectUserInfoClient alloc] initWithAccessTokenString:accessTokenString];
    __block YConnectUserInfoObject *actualUserInfoObj = nil;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [userInfoClient fetch:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
      err = error;
      actualUserInfoObj = userInfoObject;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(userId, actualUserInfoObj.userId, @"userid is not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)fetch:(YConnectUserInfoClientResponseHandler)handler
 * @test GETで通信を行い、アクセストークンをGETパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testFetchWith400Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:199
                                                     headers:@{ @"Content-Type" : @"application/json",
                                                                @"Www-Authenticate" : @"error=\"invalid_token\", error_description=\"invalid token format\"" }];
        }];

    userInfoClient = [[YConnectUserInfoClient alloc] initWithAccessTokenString:accessTokenString];
    __block YConnectUserInfoObject *actualUserInfoObj = nil;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [userInfoClient fetch:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
      err = error;
      actualUserInfoObj = userInfoObject;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual(err.code, YConnectErrorInvalidToken, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"invalid token format", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)fetch:(YConnectUserInfoClientResponseHandler)handler
 * @test GETで通信を行い、アクセストークンをGETパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testFetchWithInvalidUserInfo
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    userInfoClient = [[YConnectUserInfoClient alloc] initWithAccessTokenString:accessTokenString];
    __block YConnectUserInfoObject *actualUserInfoObj = nil;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [userInfoClient fetch:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
      err = error;
      actualUserInfoObj = userInfoObject;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertNil(actualUserInfoObj.userId, @"userId is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
