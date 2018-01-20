//
//  ImplicitCallbackUriParserTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectImplicitCallbackUriParserTest.h"
#import "YConnectError.h"

@implementation YConnectImplicitCallbackUriParserTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    callBackUri = @"hoge://callback";
    state = @"xyz";
    accessToken = @"qwertyuiop";
    expiresIn = 3600L;
    expiration = [YConnectBearerToken expirationWithExpiresIn:expiresIn];
    idToken = @"qawsedrftgyhujikolp";
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@&expires_in=%ld&id_token=%@", state, accessToken, expiresIn, idToken];
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri
 * @test リダイレクトURIとコールバックURIを入力して、エラーを起こさずに初期化できているか（正常系）
 **/
- (void)testInitWithParametersNoThrows {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNil(error, @"parse error");
    XCTAssertEqualObjects(parser.accessToken.accessToken, accessToken, @"Not match id token");
    XCTAssertEqual(parser.accessToken.expiration, expiration, @"Not match id token");
    XCTAssertEqualObjects(parser.idToken, idToken, @"Not match id token");
    XCTAssertNil(parser.accessToken.refreshToken, @"refreshToken not nil");
    XCTAssertNil(parser.accessToken.scope, @"scope not nil");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri
 * @test リダイレクトURIが空の場合(異常系)
 **/
- (void)testInitWithParametersNoRedirectUriNoThrows {
    redirectUri = nil;
    NSError *error = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not Found Callback URI", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri
 * @test コールバックURIが不正な初期化(異常系)
 **/
- (void)testInitWithParametersCallbackErrorNoThrows {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    callBackUri = @"fuga://";
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Invalid Callback URI", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri
 * @test リダイレクトURIについて、URI参照がない場合の初期化(異常系)
 **/
- (void)testInitWithParametersNoParamersErrorNoThrows {
    uriFragment = @"";
    NSError *error = nil;
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not Found Authorization Parameters", @"Not match error description");
}
/**
 * (id)initWithRedirectUri:(NSURL *)redirectUri callBackUri:(NSString *)callBackUri
 * @test リダイレクトURIについて、errorを含む初期化(異常系)
 **/
- (void)testInitWithParametersIncludeErrorNoThrows {
    uriFragment = @"error=invalid_request&error_description=description";
    NSError *error = nil;
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"description", @"Not match error description");
}

//アクセストークンがない場合(異常系)
- (void)testInitWithParametersNotIncludeAccessTokenNoThrows {
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&expires_in=%ld", state,  expiresIn];
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"No access_token or expires_in parameters", @"Not match error description");
}
//有効期限がない場合(異常系)
- (void)testInitWithParametersNotIncludeExpiresInNoThrows {
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@", state, accessToken];
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"No access_token or expires_in parameters", @"Not match error description");
}
//stateが一致しない場合(異常系)
- (void)testInitWithParametersNotMatchStateNoThrows {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    state = @"abc";
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
}
//stateが存在しない場合(異常系)
- (void)testInitWithParametersNotIncludeStateNoThrows {
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    state = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
}

//IDトークンがない場合(異常系)
- (void)testInitWithParametersNotIncludeIdTokenNoThrows {
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@&expires_in=%ld", state, accessToken, expiresIn];
    redirectUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", callBackUri, uriFragment]];
    NSError *error = nil;
    parser = [[YConnectImplicitCallbackUriParser alloc] initWithRedirectUri:redirectUri callBackUri:callBackUri state:state error:&error];
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
    XCTAssertEqualObjects([error localizedDescription], @"Not found id_token parameter", @"Not match error description");
}


@end
