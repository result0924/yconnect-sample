//
//  AuthorizationCallBackUriParserTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectAuthorizationCallBackUriParserTest.h"
#import "YConnectError.h"

@implementation YConnectAuthorizationCallBackUriParserTest
- (void)setUp
{
    [super setUp];
    //デフォルト値
    callBackUri = [NSURL URLWithString:@"hoge://callback"];
    uriScheme = @"hoge://";
    idTokenString = @"qawsedrftgyhujikolp";
    state = @"xyz";
    code = @"qwertyuiop";
    accessTokenString = @"qwertyuiop";
    expiresIn = 3600L;
    expiration = [YConnectBearerToken expirationWithExpiresIn:expiresIn];

    queryParameter = [[NSString alloc] initWithFormat:@"state=%@&code=%@", state, code];
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@&expires_in=%ld&id_token=%@", state, accessTokenString, expiresIn, idTokenString];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test リダイレクトURIとコールバックURIとstateを入力して、エラーを起こさずに初期化できているか（正常系）
 **/
- (void)testParseExplicitCallbackUri
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", callBackUri, queryParameter]];
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNil(error, @"parse error");
        XCTAssertEqualObjects(authorizationCode, code, @"Not match authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test Callback URIが空の場合(異常系)
 **/
- (void)testParseExplicitCallbackUriNoCallbackUri
{
    callBackUri = nil;
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not Found Callback URI", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test リダイレクトURIが空の場合(異常系)
 **/
- (void)testParseExplicitCallbackUriNoRedirectUri
{
    uriScheme = nil;
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not Found URI Scheme", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test コールバックURIが不正な初期化(異常系)
 **/
- (void)testParseExplicitCallbackUriCallbackError
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    uriScheme = @"fuga://";
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Invalid Callback URI", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test リダイレクトURIについて、URI参照がない場合の初期化(異常系)
 **/
- (void)testParseExplicitCallbackUriNoParamersError
{
    queryParameter = @"";
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not Found Authorization Parameters", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test リダイレクトURIについて、errorを含む初期化(異常系)
 **/
- (void)testParseExplicitCallbackUriIncludeError
{
    queryParameter = @"error=invalid_request&error_description=description";
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"description", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test stateが一致しない(異常系)
 **/
- (void)testParseExplicitCallbackUriIncludeInvalidState
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    NSString *invalidState = @"abc";
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:invalidState handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test stateがnil(異常系)
 **/
- (void)testParseExplicitCallbackUriNotIncludeState
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    NSString *invalidState = nil;
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:invalidState handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}
/**
 * (void)parseExplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectExplicitCallbackUriHandler)handler;
 * @test authorization codeが存在しない(異常系)
 **/
- (void)testParseExplicitCallbackUriNotIncludeAuthorizationCode
{
    queryParameter = [[NSString alloc] initWithFormat:@"state=%@", state];
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@?%@", uriScheme, queryParameter]];
    [YConnectAuthorizationCallBackUriParser parseExplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(NSString *authorizationCode, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"No authorization code parameters", @"Not match error description");
        XCTAssertNil(authorizationCode, @"Not null authorization code");
    }];
}

/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test リダイレクトURIとコールバックURIを入力して、エラーを起こさずに初期化できているか（正常系）
 **/
- (void)testParseImplicitCallbackUri
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNil(error, @"parse error");
        XCTAssertEqualObjects(accessToken.accessToken, accessTokenString, @"Not match id token");
        XCTAssertEqual(accessToken.expiration, expiration, @"Not match id token");
        XCTAssertNil(accessToken.refreshToken, @"refreshToken not nil");
        XCTAssertNil(accessToken.scope, @"scope not nil");
        XCTAssertEqualObjects(idToken, idTokenString, @"Not match id token");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test リダイレクトURIが空の場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNoRedirectUri
{
    callBackUri = nil;
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not Found Callback URI", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test コールバックURIが不正な初期化(異常系)
 **/
- (void)testParseImplicitCallbackUriCallbackError
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    uriScheme = @"fuga://";
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Invalid Callback URI", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test リダイレクトURIについて、URI参照がない場合の初期化(異常系)
 **/
- (void)testParseImplicitCallbackUriNoParamersError
{
    uriFragment = @"";
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not Found Authorization Parameters", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test リダイレクトURIについて、errorを含む初期化(異常系)
 **/
- (void)testParseImplicitCallbackUriIncludeError
{
    uriFragment = @"error=invalid_request&error_description=description";
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorInvalidRequest, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"description", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}

/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test アクセストークンがない場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNotIncludeAccessToken
{
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&expires_in=%ld", state, expiresIn];
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"No access_token or expires_in parameters", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test 有効期限がない場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNotIncludeExpiresIn
{
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@", state, accessTokenString];
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"No access_token or expires_in parameters", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test stateが一致しない場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNotMatchState
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    state = @"abc";
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}
/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test stateが存在しない場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNotIncludeState
{
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    state = nil;
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not match state", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}

/**
 * (void)parseImplicitCallbackUri:(NSURL *)callbackUri redirectUri:(NSString *)redirectUri state:(NSString *)state handler:(YConnectImplicitCallbackUriHandler)handler;
 * @test IDトークンがない場合(異常系)
 **/
- (void)testParseImplicitCallbackUriNotIncludeIdToken
{
    uriFragment = [[NSString alloc] initWithFormat:@"state=%@&access_token=%@&expires_in=%ld", state, accessTokenString, expiresIn];
    callBackUri = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@#%@", uriScheme, uriFragment]];
    [YConnectAuthorizationCallBackUriParser parseImplicitCallbackUri:callBackUri uriScheme:uriScheme state:state handler:^(YConnectBearerToken *accessToken, NSString *idToken, NSError *error) {
        XCTAssertNotNil(error, @"No error returned");
        XCTAssertEqual(error.code, YConnectErrorUnexpectedError, @"Not match error code");
        XCTAssertEqualObjects([error localizedDescription], @"Not found id_token parameter", @"Not match error description");
        XCTAssertNil(accessToken, @"accessToken not nil");
        XCTAssertNil(idToken, @"idToken not nil");
    }];
}

@end
