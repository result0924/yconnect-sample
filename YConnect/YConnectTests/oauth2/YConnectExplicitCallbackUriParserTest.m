//
//  ExplicitCallbackUriParserTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectExplicitCallbackUriParserTest.h"
#import "YConnectError.h"

@implementation YConnectExplicitCallbackUriParserTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    callBackUri = @"hoge://callback";
    state = @"xyz";
    code = @"qwertyuiop";
    queryParameter = [[NSString alloc] initWithFormat:@"state=%@&code=%@", state, code];
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test リダイレクトURIとコールバックURIとstateを入力して、エラーを起こさずに初期化できているか（正常系）
 **/
- (void)testInitWithParameters {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, queryParameter]];
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNil(error, @"parse error");
    XCTAssertEqualObjects(parser.authorizationCode, code, @"Not match authorization code");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test リダイレクトURIが空の場合(異常系)
 **/
- (void)testInitWithParametersNoRedirectUri {
    redirectUri = nil;
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not Found Callback URI", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test コールバックURIが不正な初期化(異常系)
 **/
- (void)testInitWithParametersCallbackError {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, queryParameter]];
    callBackUri = @"fuga://";
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Invalid Callback URI", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test リダイレクトURIについて、URI参照がない場合の初期化(異常系)
 **/
- (void)testInitWithParametersNoParamersError {
    queryParameter = @"";
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not Found Authorization Parameters", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test リダイレクトURIについて、errorを含む初期化(異常系)
 **/
- (void)testInitWithParametersIncludeError {
    queryParameter = @"error=invalid_request&error_description=description";
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"description", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test stateが一致しない(異常系)
 **/
- (void)testInitWithParametersIncludeInvalidState {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    NSString *invalidState = @"abc";
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:invalidState error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test stateがnil(異常系)
 **/
- (void)testInitWithParametersNotIncludeState {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    NSString *invalidState = nil;
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:invalidState error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri error:(NSError **)error
 * @test authorization codeが存在しない(異常系)
 **/
- (void)testInitWithParametersNotIncludeAuthorizationCode {
    queryParameter = [[NSString alloc] initWithFormat:@"state=%@", state];
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    NSError *error = nil;
    parser = [[YConnectExplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"No authorization code parameters", @"Not match error description");
}

@end
