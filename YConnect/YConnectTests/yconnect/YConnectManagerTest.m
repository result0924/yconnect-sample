//
//  YConnectManagerTest.m
//  YConnect
//
//  Created by yitou on 2014/08/12.
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHHttpStubs.h"
#import "OHPathHelpers.h"
#import "YConnectConfig.h"
#import "YConnectError.h"
#import "YConnectManager.h"

@interface YConnectManager ()
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *nonce;
@property (nonatomic, copy, readwrite) NSString *idToken;
@property (nonatomic, strong, readwrite) YConnectBearerToken *accessToken;
@end

@interface YConnectManagerTest : XCTestCase
//- (void)testInit;
//- (void)testInitWithRedirectUri;
//- (void)testInitWithScopes;
//- (void)testInitWithRedirectUriAndScopes;
- (void)testInitWithClientId;

- (void)testSharedInstance;
- (void)testSharedInstanceSingleton;
- (void)testGenerateAuthorizationUri;
- (void)testGenerateAuthorizationUriWithState;
- (void)testGenerateAuthorizationUriWithStateNoState;
- (void)testGenerateAuthorizationUriWithPrompt;
- (void)testGenerateAuthorizationUriWithPromptNoPrompt;
- (void)testGenerateAuthorizationUriWithStateAndPromptAndNonce;
- (void)testGenerateAuthorizationUriWithStateAndPromptAndNonceButAllParameterIsNil;

//- (void)testRequestAuthorization;
//- (void)testRequestAuthorizationWithState;
//- (void)testRequestAuthorizationWithPrompt;
//- (void)testRequestAuthorizationWithStatePromptNonce;
- (void)testParseAuthorizationResponseWithCodeIdToken;
- (void)testParseAuthorizationResponseErrorWithCodeIdToken;
- (void)testParseAuthorizationResponseWithToken;
- (void)testParseAuthorizationResponseErrorWithToken;
- (void)testParseAuthorizationResponseWithTokenIdToken;
- (void)testParseAuthorizationResponseErrorWithTokenIdToken;
- (void)testFetchAccesTokenWithCode;
- (void)testFetchAccesTokenErrorWithCode;
- (void)testFetchAccesTokenWithCodeIdToken;
- (void)testFetchAccesTokenErrorWithCodeIdToken;
- (void)testRefreshAccessToken;
- (void)testRefreshAccessTokenError;
- (void)testFetchUserInfo;
- (void)testFetchUserInfoError;
- (void)testAccessTokenString;
- (void)testAccessTokenExpiration;
- (void)testRefreshTokenString;
@end

YConnectManager *yconnect;
NSString *responseType;
NSString *display;
NSString *prompt;
NSArray *scopeArray;
NSString *scope;
NSString *nonce;

NSString *userId;
NSInteger idTokenExp;
NSInteger idTokenIat;

NSString *authzCode;

NSString *clientId;
NSString *redirectUri;
NSString *state;
NSString *idToken;
YConnectIdTokenObject *idTokenObject;

NSString *accessTokenString;
NSString *refreshToken;
NSInteger expiration;
YConnectBearerToken *accessToken;

@implementation YConnectManagerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    responseType = YConnectConfigResponseTypeCodeIdToken;
    display = YConnectConfigDisplayTouch;
    prompt = YConnectConfigPromptLoginConsent;
    scopeArray = @[ YConnectConfigScopeOpenid, YConnectConfigScopeProfile ];
    scope = [scopeArray componentsJoinedByString:@"%20"];
    nonce = @"qwertyuiop";

    authzCode = @"lkjhg";

    clientId = @"abcde";
    redirectUri = @"hoge://fuga";
    state = @"zzz";
    idToken = @"zxcvbn";
    idTokenExp = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) + 600UL;  //有効期限(現在時刻＋10分)
    idTokenIat = (unsigned long)floor([[NSDate date] timeIntervalSince1970]) - 300UL;  //発行時間(現在時刻−5分)
    idTokenObject = [[YConnectIdTokenObject alloc] initWithIss:@"a" userId:@"b" aud:@"c" nonce:@"d" exp:3600UL iat:1374239865UL];
    userId = @"chkminiyj_yconnect_ios_test1";

    accessTokenString = @"asdfgh";
    refreshToken = @"poiuyt";
    expiration = [YConnectBearerToken expirationWithExpiresIn:3600L];
    accessToken = [[YConnectBearerToken alloc] initWithAccessToken:accessTokenString expiration:expiration refreshToken:refreshToken];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

/*
- (void)testInit {
    yconnect = [[YConnectManager sharedInstance] init];
    XCTAssertEqualObjects(yconnect.responseType, responseType, @"init error (responseType not match)");
    XCTAssertEqualObjects(yconnect.display, display, @"init error (display not match)");
    XCTAssertEqualObjects(yconnect.scopes, scopeArray, @"init error (scope not match)");
    XCTAssertEqualObjects(yconnect.clientId, clientId, @"init error (clientId not match)");
    XCTAssertEqualObjects(yconnect.redirectUri, redirectUri, @"init error (redirectUri not match)");
    XCTAssertNil(yconnect.nonce, @"init error (nonce not match)");
    XCTAssertNil(yconnect.state, @"init error (state not match)");
}

- (void)testInitWithRedirectUri {
    NSString *altRedirectUri = @"bar://bar";
    yconnect = [[YConnectManager sharedInstance] initWithRedirectUri:altRedirectUri];
    XCTAssertEqualObjects(yconnect.responseType, responseType, @"init error (responseType not match)");
    XCTAssertEqualObjects(yconnect.display, display, @"init error (display not match)");
    XCTAssertEqualObjects(yconnect.scopes, scopeArray, @"init error (scope not match)");
    XCTAssertEqualObjects(yconnect.clientId, clientId, @"init error (clientId not match)");
    XCTAssertEqualObjects(yconnect.redirectUri, altRedirectUri, @"init error (redirectUri not match)");
    XCTAssertNil(yconnect.nonce, @"init error (nonce not match)");
    XCTAssertNil(yconnect.state, @"init error (state not match)");
}

- (void)testInitWithScopes {
    NSArray *altScopeArray = [NSArray arrayWithObjects:YConnectConfigScopeOpenid, nil];
    yconnect = [[YConnectManager sharedInstance] initWithScopes:altScopeArray];
    XCTAssertEqualObjects(yconnect.responseType, responseType, @"init error (responseType not match)");
    XCTAssertEqualObjects(yconnect.display, display, @"init error (display not match)");
    XCTAssertEqualObjects(yconnect.scopes, altScopeArray, @"init error (scope not match)");
    XCTAssertEqualObjects(yconnect.clientId, clientId, @"init error (clientId not match)");
    XCTAssertEqualObjects(yconnect.redirectUri, redirectUri, @"init error (redirectUri not match)");
    XCTAssertNil(yconnect.nonce, @"init error (nonce not match)");
    XCTAssertNil(yconnect.state, @"init error (state not match)");
    
}

- (void)testInitWithRedirectUriAndScopes {
    NSString *altRedirectUri = @"bar://bar";
    NSArray *altScopeArray = [NSArray arrayWithObjects:YConnectConfigScopeOpenid, nil];
    yconnect = [[YConnectManager sharedInstance] initWithRedirectUri:altRedirectUri scopes:altScopeArray];
    XCTAssertEqualObjects(yconnect.responseType, responseType, @"init error (responseType not match)");
    XCTAssertEqualObjects(yconnect.display, display, @"init error (display not match)");
    XCTAssertEqualObjects(yconnect.scopes, altScopeArray, @"init error (scope not match)");
    XCTAssertEqualObjects(yconnect.clientId, clientId, @"init error (clientId not match)");
    XCTAssertEqualObjects(yconnect.redirectUri, altRedirectUri, @"init error (redirectUri not match)");
    XCTAssertNil(yconnect.nonce, @"init error (nonce not match)");
    XCTAssertNil(yconnect.state, @"init error (state not match)");
}
 */

- (void)testInitWithClientId
{
    NSString *altClientId = @"ghijk";
    NSString *altRedirectUri = @"bar://bar";
    NSString *altResponseType = YConnectConfigResponseTypeToken;
    NSArray *altScopeArray = [NSArray arrayWithObjects:YConnectConfigScopeOpenid, nil];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:altClientId redirectUri:altRedirectUri responseType:altResponseType scopes:altScopeArray];
    XCTAssertEqualObjects(yconnect.responseType, altResponseType, @"init error (responseType not match)");
    XCTAssertEqualObjects(yconnect.display, display, @"init error (display not match)");
    XCTAssertEqualObjects(yconnect.scopes, altScopeArray, @"init error (scope not match)");
    XCTAssertEqualObjects(yconnect.clientId, altClientId, @"init error (clientId not match)");
    XCTAssertEqualObjects(yconnect.redirectUri, altRedirectUri, @"init error (redirectUri not match)");
    XCTAssertNil(yconnect.nonce, @"init error (nonce not match)");
    XCTAssertNil(yconnect.state, @"init error (state not match)");
}

- (void)testSharedInstance
{
    XCTAssertNoThrow(yconnect = [YConnectManager sharedInstance], @"Throw exception");
}

- (void)testSharedInstanceSingleton
{
    XCTAssertEqual([YConnectManager sharedInstance], [YConnectManager sharedInstance], @"not singleton instance");
}

- (void)testGenerateAuthorizationUri
{
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUri];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUri not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithState
{
    NSString *altState = @"ghijk";
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithState:altState];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, redirectUri, responseType, scope, altState];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithState not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithStateNoState
{
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithState:nil];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithState not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithPrompt
{
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithPrompt:prompt];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&prompt=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, prompt, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithPrompt not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithPromptNoPrompt
{
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithPrompt:nil];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithPrompt not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithStateAndPromptAndNonce
{
    NSString *altState = @"ghijk";
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithState:altState prompt:prompt nonce:nonce];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&prompt=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, nonce, prompt, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithStateAndPromptAndNonce not match expectedUrl");
}

- (void)testGenerateAuthorizationUriWithStateAndPromptAndNonceButAllParameterIsNil
{
    //    yconnect = [YConnectManager sharedInstance];
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    NSURL *authUrl = [yconnect generateAuthorizationUriWithState:nil prompt:nil nonce:nil];
    NSString *url = [[NSString alloc] initWithFormat:@"https://auth.login.yahoo.co.jp/yconnect/v1/authorization?client_id=%@&display=%@&nonce=%@&redirect_uri=%@&response_type=%@&scope=%@&state=%@", clientId, display, yconnect.nonce, redirectUri, responseType, scope, yconnect.state];
    NSURL *expectedUrl = [[NSURL alloc] initWithString:url];
    XCTAssertEqualObjects(authUrl, expectedUrl, @"generateAuthorizationUriWithStateAndPromptAndNonce not match expectedUrl");
}

//- (void)testRequestAuthorization;
//- (void)testRequestAuthorizationWithState;
//- (void)testRequestAuthorizationWithPrompt;
//- (void)testRequestAuthorizationWithStatePromptNonce;

- (void)testParseAuthorizationResponseWithCodeIdToken;
{
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    yconnect.state = state;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?code=%@&state=%@", redirectUri, authzCode, state]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(yconnect.authorizationCode, authzCode, @"authorization code is not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testParseAuthorizationResponseErrorWithCodeIdToken;
{
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    yconnect.state = state;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?code=%@&state=%@", redirectUri, authzCode, @"hoge"]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"Not match state", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testParseAuthorizationResponseWithToken
{
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeToken scopes:scopeArray];
    yconnect.state = state;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@#access_token=%@&token_type=bearer&expires_in=%@&id_token=%lu&state=%@", redirectUri, accessTokenString, idToken, 3600L, state]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(yconnect.accessTokenString, accessTokenString, @"access token is not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testParseAuthorizationResponseErrorWithToken
{
    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeToken scopes:scopeArray];
    yconnect.state = state;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@#access_token=%@&token_type=bearer&expires_in=%@&id_token=%lu&state=%@", redirectUri, accessTokenString, idToken, 3600L, @"hoge"]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"Not match state", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testParseAuthorizationResponseWithTokenIdToken
{
    NSString *responseIdToken = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"user_id\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%ld, \"iat\":%ld}", YConnectConfigIdTokenIssuer, @"hoge", clientId, nonce, (long)idTokenExp, (long)idTokenIat];
    NSData *checkIdEndpintResponse = [responseIdToken dataUsingEncoding:NSUTF8StringEncoding];

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

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeTokenIdToken scopes:scopeArray];
    yconnect.state = state;
    yconnect.nonce = nonce;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@#access_token=%@&token_type=bearer&expires_in=%lu&id_token=%@&state=%@", redirectUri, accessTokenString, 3600L, idToken, state]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(yconnect.accessTokenString, accessTokenString, @"access token is not match");
      XCTAssertEqualObjects(yconnect.idToken, idToken, @"id_token is not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testParseAuthorizationResponseErrorWithTokenIdToken
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:403
                                                     headers:nil];
        }];

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeTokenIdToken scopes:scopeArray];
    yconnect.state = state;
    NSURL *authzResponse = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@#access_token=%@&token_type=bearer&expires_in=%@&id_token=%lu&state=%@", redirectUri, accessTokenString, idToken, 3600L, state]];

    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect parseAuthorizationResponse:authzResponse handler:^(NSError *error) {
      err = error;
      XCTAssertEqualObjects(yconnect.accessTokenString, accessTokenString, @"access token is not match");
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchAccesTokenWithCode
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

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeCode scopes:scopeArray];
    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchAccessToken:authzCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      actualAccessToken = retAccessToken;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(accessTokenString, actualAccessToken.accessToken, @"accessTokenString not match");
      XCTAssertEqual(expiration, actualAccessToken.expiration, @"expiration not match");
      XCTAssertEqualObjects(refreshToken, actualAccessToken.refreshToken, @"refreshToken not match");
      XCTAssertNil(actualAccessToken.scope, @"scope not nil");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchAccesTokenErrorWithCode
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeCode scopes:scopeArray];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchAccessToken:authzCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchAccesTokenWithCodeIdToken
{
    NSString *responseIdToken = [NSString stringWithFormat:@"{\"iss\":\"%@\", \"user_id\":\"%@\", \"aud\":\"%@\", \"nonce\":\"%@\", \"exp\":%ld, \"iat\":%ld}", YConnectConfigIdTokenIssuer, @"hoge", clientId, nonce, (long)idTokenExp, (long)idTokenIat];
    NSData *checkIdEndpintResponse = [responseIdToken dataUsingEncoding:NSUTF8StringEncoding];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *dateHeader = [dateFormatter stringFromDate:[NSDate date]];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          if ([request.URL.absoluteString hasPrefix:YConnectConfigTokenEndpoint]) {
              return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_success.json", self.class)
                                                      statusCode:200
                                                         headers:@{ @"Content-Type" : @"application/json" }];
          }
          return [OHHTTPStubsResponse responseWithData:checkIdEndpintResponse
                                            statusCode:200
                                               headers:@{ @"Content-Type" : @"application/json",
                                                          @"Date" : dateHeader }];
        }];

    expiration = 3600L + (long)floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - 60L;

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeCodeIdToken scopes:scopeArray];
    yconnect.nonce = nonce;
    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchAccessToken:authzCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      actualAccessToken = retAccessToken;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(accessTokenString, actualAccessToken.accessToken, @"accessTokenString not match");
      XCTAssertEqual(expiration, actualAccessToken.expiration, @"expiration not match");
      XCTAssertEqualObjects(refreshToken, actualAccessToken.refreshToken, @"refreshToken not match");
      XCTAssertNil(actualAccessToken.scope, @"scope not nil");
      XCTAssertEqualObjects(idToken, yconnect.idToken, @"id_token not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchAccesTokenErrorWithCodeIdToken
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          if ([request.URL.absoluteString hasPrefix:YConnectConfigTokenEndpoint]) {
              return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_success.json", self.class)
                                                      statusCode:200
                                                         headers:@{ @"Content-Type" : @"application/json" }];
          }
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.json", self.class)
                                                  statusCode:403
                                                     headers:nil];
        }];

    expiration = 3600L + (long)floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - 60L;

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:YConnectConfigResponseTypeCodeIdToken scopes:scopeArray];
    yconnect.idToken = nil;
    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchAccessToken:authzCode handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      actualAccessToken = retAccessToken;
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertNil(actualAccessToken, @"access_token is not nil");
      XCTAssertNil(yconnect.idToken, @"id_token is not nil");
      XCTAssertNotNil(err, @"error is not nil");
      XCTAssertEqual(err.code, YConnectErrorUnexpectedError, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"An unexpected error has occurred", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testRefreshAccessToken
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

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    __block NSError *err = nil;
    __block YConnectBearerToken *actualAccessToken = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect refreshAccessToken:refreshToken handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
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

- (void)testRefreshAccessTokenError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"token_endpoint_error.json", self.class)
                                                  statusCode:400
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect refreshAccessToken:refreshToken handler:^(YConnectBearerToken *retAccessToken, NSError *error) {
      err = error;
      XCTAssertEqual(err.code, YConnectErrorInvalidRequest, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"required+parameter+is+empty.+%5B%22response_type%22%5D&state=xyz", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchUserInfo
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
      return YES;
    }
        withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
          return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"userinfo_endpoint_success.json", self.class)
                                                  statusCode:200
                                                     headers:@{ @"Content-Type" : @"application/json" }];
        }];

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    __block YConnectUserInfoObject *actualUserInfoObj = nil;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchUserInfo:accessTokenString handler:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
      err = error;
      actualUserInfoObj = userInfoObject;
      XCTAssertNil(err, @"error is not nil");
      XCTAssertEqualObjects(userId, actualUserInfoObj.userId, @"userid is not match");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testFetchUserInfoError
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

    yconnect = [[YConnectManager sharedInstance] initWithClientId:clientId redirectUri:redirectUri responseType:responseType scopes:scopeArray];
    __block YConnectUserInfoObject *actualUserInfoObj = nil;
    __block NSError *err = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"UIDocument is opened."];
    [yconnect fetchUserInfo:accessTokenString handler:^(YConnectUserInfoObject *userInfoObject, NSError *error) {
      err = error;
      actualUserInfoObj = userInfoObject;
      XCTAssertNotNil(err, @"error is nil");
      XCTAssertEqual(err.code, YConnectErrorInvalidToken, @"Not match error code");
      XCTAssertEqualObjects([err localizedDescription], @"invalid token format", @"Not match description");
      [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testAccessTokenString
{
    yconnect = [YConnectManager sharedInstance];
    yconnect.accessToken = accessToken;
    XCTAssertEqualObjects(yconnect.accessTokenString, accessTokenString, @"not match accessToken");
}

- (void)testAccessTokenExpiration
{
    yconnect = [YConnectManager sharedInstance];
    yconnect.accessToken = accessToken;
    XCTAssertEqual(yconnect.accessTokenExpiration, expiration, @"not match accessTokenExpiration");
}
- (void)testRefreshTokenString
{
    yconnect = [YConnectManager sharedInstance];
    yconnect.accessToken = accessToken;
    XCTAssertEqualObjects(yconnect.refreshTokenString, refreshToken, @"not match refreshTokenString");
}

@end