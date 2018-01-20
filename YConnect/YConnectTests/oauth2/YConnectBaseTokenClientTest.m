//
//  BaseTokenClientTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectBaseTokenClientTest.h"
#import "YConnectError.h"

@implementation YConnectBaseTokenClientTest

- (void)setUp
{
    [super setUp];
    endpointUrl = @"http://www.yahoo.co.jp";
    clientId = @"abcde";
    accessTokenString = @"hoge";
    expiration = [YConnectBearerToken expirationWithExpiresIn:3600L];
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration];
    response = [NSDictionary dictionaryWithObjectsAndKeys:
                @"invalid_request", @"error",
                @"required+parameter+is+empty.+%5B%22response_type%22%5D", @"error_description", nil];
}

/**
 * (id)initWithEndpointUrl
 * @test エンドポイントのURLとclient idを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithEndpointUrl {
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    XCTAssertEqual(endpointUrl, baseTokenClient.endpointUrl, @"endpointUrl not match");
    XCTAssertEqual(clientId, baseTokenClient.clientId, @"clientId not match");
}

/**
 * (void)fetch
 * @test 実装は無し
 **/
- (void)testFetch {
}

/**
 * (BearerToken *)getAccessToken:(NSString *)state
 * @test トークンを取得し、各パラメータが正しいか(正常系)
 **/
- (void)testAccessToken {
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    baseTokenClient.accessToken = accessToken;
    XCTAssertEqualObjects(baseTokenClient.accessToken, accessToken, @"not match accessToken");
    
    XCTAssertEqualObjects(accessToken, baseTokenClient.accessToken, @"accessToken not match");
    XCTAssertEqual(accessTokenString, baseTokenClient.accessToken.accessToken, @"accessTokenString not match");
    XCTAssertEqual(expiration, baseTokenClient.accessToken.expiration, @"expiration not match");
    XCTAssertNil(baseTokenClient.accessToken.refreshToken, @"refreshToken not nil");
    XCTAssertNil(baseTokenClient.accessToken.scope, @"scope not nil");
}

/**
 * (BearerToken *)getAccessToken:(NSString *)state
 * @test トークンを取得し、各パラメータが正しいか(異常系、access token無し)
 **/
- (void)testAccessTokenNoAccessToken {
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    baseTokenClient.accessToken = nil;
    XCTAssertNil(baseTokenClient.accessToken, @"access token not nil");
}

/**
 * (void)checkErrorResponse:(int)statusCode jsonObject:(NSDictionary *)jsonObject error:(NSError **)error
 * @test レスポンスのチェックを行い、エラーでないことを確認(正常系)
 **/
- (void)testCheckErrorResponse {
    NSError *error = nil;
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    BOOL ret = [baseTokenClient checkErrorResponse:200 jsonObject:response error:&error];
    XCTAssertTrue(ret, @"BaseTokenClient CheckErrorResponse Error.");
    XCTAssertNil(error, @"BaseTokenClient CheckErrorResponse Error. Error returned.");
}
/**
 * (void)checkErrorResponse:(int)statusCode jsonObject:(NSDictionary *)jsonObject error:(NSError **)error
 * @test レスポンスのチェックを行い、エラーであることを確認(正常系、statusCode:400)
 **/
- (void)testCheckErrorResponseWith400Code {
    NSError *error = nil;
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    BOOL ret = [baseTokenClient checkErrorResponse:400 jsonObject:response error:&error];
    XCTAssertFalse(ret, @"BaseTokenClient CheckErrorResponse Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D", @"Not match description");
}
/**
 * (void)checkErrorResponse:(int)statusCode jsonObject:(NSDictionary *)jsonObject error:(NSError **)error
 * @test レスポンスのチェックを行い、エラーであることを確認(異常系、statusCode:401)
 **/
- (void)testCheckErrorResponseWith401Code {
    NSError *error = nil;
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    BOOL ret = [baseTokenClient checkErrorResponse:401 jsonObject:response error:&error];
    XCTAssertFalse(ret, @"BaseTokenClient CheckErrorResponse Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D", @"Not match description");
}
/**
 * (void)checkErrorResponse:(int)statusCode jsonObject:(NSDictionary *)jsonObject error:(NSError **)error
 * @test レスポンスのチェックを行い、エラーであることを確認(異常系、statusCode:400、不正なフォーマットのレスポンス)
 **/
- (void)testCheckErrorResponseWith400CodeAndInvalidFormatResponse {
    response = [NSDictionary dictionaryWithObjectsAndKeys:
                @"required+parameter+is+empty.+%5B%22response_type%22%5D", @"error_description", nil];
    NSError *error = nil;
    baseTokenClient = [[YConnectBaseTokenClient alloc] initWithEndpointUrl:endpointUrl clientId:clientId];
    BOOL ret = [baseTokenClient checkErrorResponse:400 jsonObject:response error:&error];
    XCTAssertFalse(ret, @"BaseTokenClient CheckErrorResponse Error. YES returned.");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"An unexpected error has occurred", @"Not match description");
}
@end
