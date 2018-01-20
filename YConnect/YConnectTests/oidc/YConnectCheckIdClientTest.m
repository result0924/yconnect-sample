//
//  CheckIdClientTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectCheckIdClientTest.h"
#import "YConnectError.h"

@implementation YConnectCheckIdClientTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    endpointUrl = @"yj-qvn://callback";
    idToken = @"abcdefghijklmnopqrstubwxyz";
    nonce = @"lkjhg";
    clientId = @"qwerty";
    iss = @"https://auth.login.yahoo.co.jp";
    userId = @"hogehoge";
    aud = clientId;
    exp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 600UL;  //有効期限(現在時刻＋10分)
    iat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 300UL;  //発行時間(現在時刻−5分)
    checkIdClient = [[YConnectCheckIdClient alloc] init];

    idToken = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"user_id\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%lu, \"iat\":%lu}", iss, userId, aud, nonce, exp, iat];
    checkIdEndpintResponse = [idToken dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID TokenとチェックするエンドポイントのURLを用いて、ID Tokenのパラメータを取得できるか(正常系、モック利用)
 **/
- (void)testCheckRequestWithClientId
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *dateHeader = [dateFormatter stringFromDate:[NSDate date]];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithData:checkIdEndpintResponse
                                            statusCode:200
                                               headers:@{ @"Content-Type" : @"application/json",
                                                          @"Date" :
                                                              dateHeader
                                               }];
        }];

    __block NSError *err = nil;
    __block YConnectIdTokenObject *actualIdTokenObject = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      actualIdTokenObject = retIdTokenObject;
      XCTAssertNil(err, @"error is nil");
      XCTAssertEqualObjects(actualIdTokenObject.iss, iss, @"should match expectedIss");
      XCTAssertEqualObjects(actualIdTokenObject.userId, userId, @"should match expectedUserId");
      XCTAssertEqualObjects(actualIdTokenObject.aud, aud, @"should match expectedAud");
      XCTAssertEqualObjects(actualIdTokenObject.nonce, nonce, @"should match expectedNonce");
      XCTAssertEqual(actualIdTokenObject.exp, exp, @"should match expectedExp");
      XCTAssertEqual(actualIdTokenObject.iat, iat, @"should match expectedIat");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID TokenとチェックするエンドポイントのURLを用いて、ID Tokenのパラメータを取得できるか(正常系、モック利用、不正なDateHeader)
 **/
- (void)testCheckRequestWithClientIdWithNoDateHeader
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithData:checkIdEndpintResponse
                                            statusCode:200
                                               headers:@{ @"Content-Type" : @"application/json"
                                               }];
        }];

    __block NSError *err = nil;
    __block YConnectIdTokenObject *actualIdTokenObject = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      actualIdTokenObject = retIdTokenObject;
      XCTAssertNil(err, @"error is nil");
      XCTAssertEqualObjects(actualIdTokenObject.iss, iss, @"should match expectedIss");
      XCTAssertEqualObjects(actualIdTokenObject.userId, userId, @"should match expectedUserId");
      XCTAssertEqualObjects(actualIdTokenObject.aud, aud, @"should match expectedAud");
      XCTAssertEqualObjects(actualIdTokenObject.nonce, nonce, @"should match expectedNonce");
      XCTAssertEqual(actualIdTokenObject.exp, exp, @"should match expectedExp");
      XCTAssertEqual(actualIdTokenObject.iat, iat, @"should match expectedIat");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID TokenとチェックするエンドポイントのURLを用いて、ID Tokenのパラメータを取得できるか(正常系、モック利用、DateHeader無し)
 **/
- (void)testCheckRequestWithClientIdWithInvalidDateHeader
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithData:checkIdEndpintResponse
                                            statusCode:200
                                               headers:@{ @"Content-Type" : @"application/json",
                                                          @"Date" : @"hoge"
                                               }];
        }];

    __block NSError *err = nil;
    __block YConnectIdTokenObject *actualIdTokenObject = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      actualIdTokenObject = retIdTokenObject;
      XCTAssertNil(err, @"error is nil");
      XCTAssertEqualObjects(actualIdTokenObject.iss, iss, @"should match expectedIss");
      XCTAssertEqualObjects(actualIdTokenObject.userId, userId, @"should match expectedUserId");
      XCTAssertEqualObjects(actualIdTokenObject.aud, aud, @"should match expectedAud");
      XCTAssertEqualObjects(actualIdTokenObject.nonce, nonce, @"should match expectedNonce");
      XCTAssertEqual(actualIdTokenObject.exp, exp, @"should match expectedExp");
      XCTAssertEqual(actualIdTokenObject.iat, iat, @"should match expectedIat");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID Tokenのチェックポイントへのアクセスについて、通信のステータスコードが200以外の場合のテスト(異常系、モック利用)
 **/
- (void)testCheckRequestWithClientIdWithNo200Code
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:403
                                                     headers:
                                                         @{ @"Bearer realm" : @"yahooapis.jp",
                                                            @"WWW-Authenticate" : @"error=\"insufficient_scope\",error_description=\"The access token expired\""
                                                         }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorInsufficientScope, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"The access token expired", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID Tokenのチェックポイントへのアクセスについて、通信のステータスコードが200以外であり、WWW-Authenticateがない場合のテスト(異常系、モック利用)
 **/
- (void)testCheckRequestWithClientIdWithNo200CodeAndNoWWWAuthenticate
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:403
                                                     headers:nil];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID Tokenのチェックポイントへのアクセスについて、通信のステータスコードが200以外であり、WWW-Authenticateがあるが空の場合のテスト(異常系、モック利用)
 **/
- (void)testCheckRequestWithClientIdWithNo200CodeAndBlankWWWAuthenticate
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:403
                                                     headers:@{ @"WWW-Authenticate" : @"" }];
        }];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)checkRequestWithClientId:(NSString *)clientId nonce:(NSString *)nonce idToken:(NSString *)idToken handler:(YConnectCheckIdClientResponseHandler)handler
 * @test ID Tokenのチェックポイントへのアクセスについて、タイムアウトが設定できているか(モック利用)
 **/
- (void)testCheckRequestWithClientIdWithTimeout
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [[OHHTTPStubsResponse responseWithData:checkIdEndpintResponse
                                             statusCode:200
                                                headers:@{ @"WWW-Authenticate" : @"" }]
               requestTime:1.0
              responseTime:2.0];
        }];

    double expected = 1;
    checkIdClient.checkIdTimeout = expected;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [checkIdClient checkRequestWithClientId:clientId nonce:nonce idToken:idToken handler:^(YConnectIdTokenObject *retIdTokenObject, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual((int)err.code, -1001, @"not timed out");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
