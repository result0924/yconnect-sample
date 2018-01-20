//
//  APIClientTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectAPIClientTest.h"

@implementation YConnectAPIClientTest
- (void)setUp
{
    [super setUp];
    client = [[YConnectAPIClient alloc] init];
    url = @"https://auth.login.yahoo.co.jp/yconnect/v1/checktoken";
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}
/**
 * (NSString *) POST_METHOD
 * @test POST用の定数値が取得できるか（正常系）
 **/
- (void)testPOST_METHOD
{
    XCTAssertEqualObjects([YConnectAPIClient POST_METHOD], @"POST", @"not match POST");
}

/**
 * (NSString *) GET_METHOD
 * @test GET用の定数値が取得できるか（正常系）
 **/
- (void)testGET_METHOD
{
    XCTAssertEqualObjects([YConnectAPIClient GET_METHOD], @"GET", @"not match GET");
}

/**
 * (NSString *) DELETE_METHOD
 * @test DELETE用の定数値が取得できるか（正常系）
 **/
- (void)testDELETE_METHOD
{
    XCTAssertEqualObjects([YConnectAPIClient DELETE_METHOD], @"DELETE", @"not match DELETE");
}

/**
 * (NSString *) PUT_METHOD
 * @test PUT用の定数値が取得できるか（正常系）
 **/
- (void)testPUT_METHOD
{
    XCTAssertEqualObjects([YConnectAPIClient PUT_METHOD], @"PUT", @"not match PUT");
}

/**
 * (id) init
 * @test 例外を投げずに、リクエスト用の変数を初期化できているか（正常系）
 **/
- (void)testInit
{
    XCTAssertNoThrow(client = [[YConnectAPIClient alloc] init], @"should not throw exception");
    XCTAssertTrue([client.parameters count] == 0, @"Client parameters not initialize");
    XCTAssertTrue([client.requestHeaders count] == 0, @"Client request headers not initialize");
    XCTAssertTrue(client.isShouldMoveAccessTokenFromParameterToHeader, @"Client accessToken  move flag not true");
}

/**
 * (id) initWithAccessTokenString:(NSString *)accessToken
 * @test アクセストークンを入力して、初期化できているか（正常系）
 **/
- (void)testInitWithAccessTokenString
{
    NSString *accessToken = @"qwertyuiop";
    client = [[YConnectAPIClient alloc] initWithAccessTokenString:accessToken];
    XCTAssertTrue([client.requestHeaders count] == 0, @"Client request headers not initialize");
    XCTAssertTrue(client.isShouldMoveAccessTokenFromParameterToHeader, @"Client accessToken  move flag not true");

    XCTAssertTrue([client.parameters count] == 1, @"Client parameters not initialize");
    XCTAssertEqualObjects([client.parameters objectForKey:@"access_token"], accessToken, @"accessToken not set");
}

/**
 * (id) initWithAccessToken:(BearerToken *)accessToken
 * @test アクセストークン群を入力して、初期化できているか（正常系）
 **/
- (void)testInitWithAccessToken
{
    YConnectBearerToken *token = [[YConnectBearerToken alloc] initWithAccessToken:@"qwertyuiop" expiration:100L];
    client = [[YConnectAPIClient alloc] initWithAccessToken:token];
    XCTAssertTrue([client.requestHeaders count] == 0, @"Client request headers not initialize");
    XCTAssertTrue(client.isShouldMoveAccessTokenFromParameterToHeader, @"Client accessToken  move flag not true");

    XCTAssertTrue([client.parameters count] == 1, @"Client parameters not initialize");
    XCTAssertEqualObjects([client.parameters objectForKey:@"access_token"], token.accessToken, @"accessToken(BearerToken) not set");
}

/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test GETで通信を行い、APIへアクセスできているか(モック)
 **/
- (void)testGet
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test ステータスコードの境界値テスト:201が成功レスポンスとして扱われる(モック)
 **/
- (void)testGetReturn201HttpStatusCode
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:201
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test ステータスコードの境界値テスト:199が失敗レスポンスとして扱われる(モック)
 **/
- (void)testGetReturn199HttpStatusCode
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

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual(err.code, YConnectErrorInvalidToken, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"invalid token format", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test ステータスコードの境界値テスト:300が失敗レスポンスとして扱われる(モック)
 **/
- (void)testGetReturn300HttpStatusCode
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:300
                                                     headers:@{ @"Content-Type" : @"application/json",
                                                                @"Www-Authenticate" : @"error=\"invalid_token\", error_description=\"invalid token format\"" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual(err.code, YConnectErrorInvalidToken, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"invalid token format", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test GETで通信を行い、アクセストークンをGETパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testGetInParameter
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client.isShouldMoveAccessTokenFromParameterToHeader = NO;  //ヘッダへ移動しない
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)get:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test タイムアウトが正しくセットされているか
 **/
- (void)testGetTimeout
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                   statusCode:200
                                                      headers:@{ @"Content-Type" : @"application/json" }]
               requestTime:1.0
              responseTime:2.0];
        }];

    double expected = 1;
    client.apiTimeout = expected;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client get:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual((int)err.code, -1001, @"not timed out");
      XCTAssertTrue(client.httpClient.timeout == expected, @"should match expected timeout");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)post:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test POSTで通信を行い、APIへアクセスできているか(モック)
 **/
- (void)testPost
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client post:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)post:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test POSTで通信を行い、アクセストークンをPOSTパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testPostInParameter
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client.isShouldMoveAccessTokenFromParameterToHeader = NO;  //ヘッダへ移動しない
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client post:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void) delete:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test DELETEで通信を行い、APIへアクセスできているか(モック)
 **/
- (void)testDelete
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client delete:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void) delete:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test DELETEで通信を行い、アクセストークンをDELETEパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testDeleteInParameter
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client.isShouldMoveAccessTokenFromParameterToHeader = NO;  //ヘッダへ移動しない
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client delete:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * (void)put:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test PUTで通信を行い、APIへアクセスできているか(モック)
 **/
- (void)testPut
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client put:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)put:(NSString *)url handler:(YConnectAPIClientResponseHandler)handler
 * @test PUTで通信を行い、アクセストークンをPUTパラメータで利用し、APIへアクセスできているか(モック)
 **/
- (void)testPutInParameter
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client.isShouldMoveAccessTokenFromParameterToHeader = NO;  //ヘッダへ移動しない
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client put:url handler:^(NSString *responseBody, YConnectHttpHeaders *headers, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)execute:(NSString *)url method:(NSString *)method handler:(YConnectAPIClientResponseHandler)handler
 * @test メソッドの指定が不正な場合、通信は行われずに例外を投げているか
 **/
- (void)testExecuteIllegalMethod
{
    XCTAssertThrowsSpecificNamed([client execute:url method:@"hoge" handler:nil], NSException, @"MethodError", @"should thrown NSException");
}

/**
 * (void) setParameter:(NSString *)name value:(NSString *)value
 * @test リクエストパラメータにキーと値をセットできているか（正常系）
 **/
- (void)testSetParameter
{
    NSString *name = @"hoge";
    NSString *value = @"hoge_value";
    XCTAssertNoThrow([client setParameter:name value:value], @"should not throw exception");
    XCTAssertTrue([[client.parameters allKeys] containsObject:name], @"Client parameters not include key");
    XCTAssertEqualObjects([client.parameters objectForKey:name], value, @"Client pamaters not include value");
}

/**
 * (void) setHeader:(NSString *)field value:(NSString *)value
 * @test リクエストヘッダにフィールド名と値をセットできているか（正常系）
 **/
- (void)testSetHeader
{
    NSString *expected = @"hoge";
    NSString *value = @"hoge_value";
    XCTAssertNoThrow([client setHeader:@"hoge" value:value], @"should not throw exception");
    XCTAssertTrue([[client.requestHeaders allKeys] containsObject:expected], @"Client requestHeaders not include key");
    XCTAssertEqualObjects([client.requestHeaders objectForKey:expected], value, @"Client requestHeaders not include value");
}
/**
 * (void) setHeader:(NSString *)field value:(NSString *)value
 * @test リクエストヘッダにフィールド名(コロンと空白を含む)と値をセットできているか（正常系）
 **/
- (void)testSetHeaderIncludeColonAndSpace
{
    NSString *expected = @"hoge";  //空白とコロンが除去されてる
    NSString *value = @"hoge_value";
    XCTAssertNoThrow([client setHeader:@" hoge :" value:value], @"should not throw exception");
    XCTAssertTrue([[client.requestHeaders allKeys] containsObject:expected], @"Client requestHeaders not include key");
    XCTAssertEqualObjects([client.requestHeaders objectForKey:expected], value, @"Client requestHeaders not include value");
}

/**
 * (void) setAccessToken:(BearerToken *)accessToken
 * @test リクエストパラメータにアクセストークンをセットできているか（正常系）
 **/
- (void)testSetAccessToken
{
    YConnectBearerToken *value = [[YConnectBearerToken alloc] initWithAccessToken:@"qwertyuiopasdfghjkl" expiration:10L];
    XCTAssertNoThrow([client setAccessToken:value], @"should not throw exception");
    XCTAssertTrue([[client.parameters allKeys] containsObject:@"access_token"], @"Client parameters not access_token key");
    XCTAssertEqualObjects([client.parameters objectForKey:@"access_token"], value.accessToken, @"Client pamaters not access_token");
}

/**
 * (void) moveAccessTokenFromParameterToHeader
 * @test 正しくパラメータからヘッダへ移動できているか（正常系）
 **/
- (void)testMoveAccessTokenFromParameterToHeader
{
    NSString *token = @"hogehoge";
    NSString *header = @"Bearer hogehoge";
    client = [client initWithAccessTokenString:token];

    XCTAssertTrue([[client.parameters.nsMutableDictionary allKeys] containsObject:@"access_token"], @"shoud parameters contain access_token key");
    XCTAssertEqualObjects([client.parameters.nsMutableDictionary objectForKey:@"access_token"], token, @"shoud parameterss match access_token value");
    XCTAssertFalse([[client.requestHeaders.nsMutableDictionary allKeys] containsObject:@"Authorization"], @"shoud not requestHeaders contain Authorization key");

    XCTAssertNoThrow([client moveAccessTokenFromParameterToHeader], @"should not throw exception");

    XCTAssertTrue([[client.requestHeaders.nsMutableDictionary allKeys] containsObject:@"Authorization"], @"shoud requestHeaders contain Authorization key");
    XCTAssertEqualObjects([client.requestHeaders.nsMutableDictionary objectForKey:@"Authorization"], header, @"shoud parameterss match Authorization value(Bearer 'accessToken')");
    XCTAssertFalse([[client.parameters.nsMutableDictionary allKeys] containsObject:@"access_token"], @"shoud parameters contain access_token key");
}
@end
