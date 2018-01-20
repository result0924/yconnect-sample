//
//  AuthorizationRequestClientTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectAuthorizationRequestClientTest.h"

@implementation YConnectAuthorizationRequestClientTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    responseType = YConnectConfigResponseTypeTokenIdToken;
    clientId = @"abcde";
    redirectUri = @"hoge://fuga";
    state = @"zzz";
    
    endpointUri = @"https://auth.login.yahoo.co.jp/yconnect/v1/authorization"; 
    requestClient = [[YConnectAuthorizationRequestClient alloc] initWithEndpointUri:endpointUri clientId:clientId];
}

- (void)tearDown
{   
    [super tearDown];
}
/**
 * (id)initWithEndpointUri:(NSString *)endpointUri clientId:(NSString *)clientId
 * @test エラーなく初期化が行えているか(正常系)
 **/
- (void)testInitWithParameters {
    XCTAssertNoThrow(requestClient = [[YConnectAuthorizationRequestClient alloc] initWithEndpointUri:endpointUri clientId:clientId], @"Throw exception");
}

/**
 * (NSURL *)generateAuthorizationUri
 * @test 認証・認可用URLが生成できているか(正常系)
 **/
- (void)testGenerateAuthorizationUri {
    requestClient.responseType = responseType;
    requestClient.state = state;
    requestClient.redirectUri = redirectUri;
    requestClient.dic = @{@"hoge": @"value"};
    NSURL *authUrl = [requestClient generateAuthorizationUri];
    NSLog(@"%@",authUrl);
    NSString *url = [[NSString alloc] initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@&state=%@&hoge=value", endpointUri, clientId, redirectUri, responseType, state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUri not match expectedUrl");
}
/**
 * (void)setParameter:(NSString *)name value:(NSString *)value
 * @test リクエストパラメータをセットおよびゲットできているか(正常系)
 **/
- (void)testSetAndGetParameter {
    NSString *name = @"hoge";
    NSString *value = @"fuga";
    [requestClient setParameter:name value:value];
    XCTAssertEqual([requestClient getParameterValue:name], value, @"");
}

@end
