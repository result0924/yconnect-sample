//
//  HttpClientTest.m
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectHttpClientTest.h"

@interface NSURLSession (Mock)
- (id)dummy;
+ (void)setDummyInstance:(id)instance;
@end
@implementation NSURLSession (Mock)
static id dummyInstance;
- (id)dummy
{
    NSLog(@"dummy method called");
    return dummyInstance;
}
+ (void)setDummyInstance:instance
{
    dummyInstance = instance;
}
@end

@implementation YConnectHttpClientTest
- (void)setUp
{
    [super setUp];
    client = [[YConnectHttpClient alloc] init];  //シングルトンだとpartialMockに影響するため通常のインスタンスとして生成
    parameters = [[YConnectHttpParameters alloc] init];
    headers = [[YConnectHttpHeaders alloc] init];
    url = @"https://auth.login.yahoo.co.jp/yconnect/v1/checktoken";
}

- (void)tearDown
{
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

/**
 * (void)requestGet:(NSString *)urlString parameters:(HttpParameters *)parameters requestHeaders:(HttpHeaders *)requestHeaders
 * @test Http通信をGETで行えているか(通信部分はダミー)
 **/
- (void)testRequestGet
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client = [[YConnectHttpClient alloc] init];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestGet:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)requestGet:(NSString *)urlString parameters:(HttpParameters *)parameters requestHeaders:(HttpHeaders *)requestHeaders
 * @test タイムアウトの設定ができているか
 **/
- (void)testRequestGetTimeout
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

    client.timeout = 1;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestGet:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual((int)err.code, -1001, @"not timed out");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
    /*
    //クラスメソッドをダミーに入れ替え
    method_exchangeImplementations(class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:returningResponse:error:)), class_getInstanceMethod([NSURLConnection class], @selector(dummy)));
    client = [[YConnectHttpClient alloc] init]; //シングルトンでなく、通常のインスタンスとして生成
    
    [parameters setValue:@"hogehoge" forKey:@"hoge"];
    
    //リクエストボディなし(デフォルトタイムアウト60s)
    client.requestBody = nil;
    double expected = 60;
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match timeout (60.0s = default)");
    
    //リクエストボディあり
    client.requestBody = @"piyopiyo";
    expected = 60;
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match timeout (60.0s or 240s)");
    
    //バイナリデータのリクエストボディ
    client.requestBody = [@"fugafuga" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match timeout (60.0s or 240s)");
    
    //リクエストボディなしでタイムアウトを明示的にセット
    client.requestBody = nil;
    client.timeout = 10;
    expected = client.timeout;
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match expected timeout");
    
    //リクエストボディあり、および、タイムアウトを明示的にセット
    client.requestBody = @"piyopiyo";
    client.timeout = 10;
    expected = client.timeout;
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match expected timeout or 240s");
    
    //バイナリデータのリクエストボディ
    client.requestBody = [@"fugafuga" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNoThrow([client requestGet:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match expected timeout or 240s");
    
    //ダミーに入れ替えたのを戻す
    method_exchangeImplementations(class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:returningResponse:error:)), class_getInstanceMethod([NSURLConnection class], @selector(dummy)));
     */
}
/**
 * (void)requestPost:(NSString *)urlString parameters:(HttpParameters *)parameters requestHeaders:(HttpHeaders *)requestHeaders
 * @test Http通信をPOSTで行えているか(通信部分はダミー)
 **/
- (void)testRequestPost
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client = [[YConnectHttpClient alloc] init];
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestPost:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];

    expectation = [self expectationWithDescription:@"UIDocument is opened."];
    client = [[YConnectHttpClient alloc] init];
    client.requestBody = [@"fugafuga" dataUsingEncoding:NSUTF8StringEncoding];
    err = nil;
    [client requestPost:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
/**
 * (void)requestPost:(NSString *)urlString parameters:(HttpParameters *)parameters requestHeaders:(HttpHeaders *)requestHeaders
 * @test タイムアウトが設定できているか
 **/
- (void)testRequestPostTimeout
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

    client.timeout = 1;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestPost:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual((int)err.code, -1001, @"not timed out");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:4 handler:nil];
    /*
    //クラスメソッドをダミーに入れ替え
    method_exchangeImplementations(class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:returningResponse:error:)), class_getInstanceMethod([NSURLConnection class], @selector(dummy)));
    client = [[YConnectHttpClient alloc] init]; //シングルトンでなく、通常のインスタンスとして生成
    
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    
    //パラメータセットなし(デフォルトタイムアウト60s)
    double expected = 60;
    XCTAssertNoThrow([client requestPost:url parameters:nil requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match timeout (60.0s = default)");
    
    //パラメータセット（iOS6.0以前だと強制的に240s）
    NSArray *versions = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    NSInteger iOsVersionMajor = [[versions objectAtIndex:0] intValue];
    if (iOsVersionMajor < 6) {
        expected = 240;
    } else {
        expected = 60;
    }
    XCTAssertNoThrow([client requestPost:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match timeout (60.0s or 240s)");
    
    //パラメータセットなしでタイムアウトを明示的にセット
    client.timeout = 10;
    expected = client.timeout;
    XCTAssertNoThrow([client requestPost:url parameters:nil requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match expected timeout");
    
    //パラメータのセット、および、タイムアウトを明示的にセット（iOS6.0以前だと無視され、強制的に240s）
    client.timeout = 10;
    if (iOsVersionMajor < 6) {
        expected = 240;
    } else {
        expected = client.timeout;
    }
    XCTAssertNoThrow([client requestPost:url parameters:parameters requestHeaders:headers], @"should not throw exception");
    XCTAssertTrue(client.timeout == expected, @"should match expected timeout or 240s");
    
    //ダミーに入れ替えたのを戻す
    method_exchangeImplementations(class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:returningResponse:error:)), class_getInstanceMethod([NSURLConnection class], @selector(dummy)));
     */
}

- (void)testRequestPut
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client = [[YConnectHttpClient alloc] init];
    [parameters setValue:@"fugafuga" forKey:@"fuga"];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestPut:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:4 handler:nil];
}
- (void)testRequestDelete
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    client = [[YConnectHttpClient alloc] init];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [client requestDelete:url parameters:parameters requestHeaders:headers handler:^(NSString *responseBody, NSInteger statusCode, YConnectHttpHeaders *heaedrs, NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:4 handler:nil];
}

/**
 * (void)enableSSLCheck
 * @test 例外を投げずに証明書検証フラグを有効にできるか(正常系)
 **/
- (void)testEnableSSLCheck
{
    XCTAssertNoThrow([YConnectHttpClient enableSSLCheck], @"Throw exception");
}
/**
 * +(void)disableSSLCheck
 * @test 例外を投げずに証明書検証フラグを無効にできるか(正常系)
 **/
- (void)testDisableSSLCheck
{
    XCTAssertNoThrow([YConnectHttpClient disableSSLCheck], @"Throw exception");
}

@end
