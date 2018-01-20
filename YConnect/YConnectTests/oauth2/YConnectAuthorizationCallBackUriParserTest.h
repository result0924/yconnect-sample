//
//  AuthorizationCallBackUriParserTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectAuthorizationCallBackUriParser.h"

@interface YConnectAuthorizationCallBackUriParserTest : XCTestCase {
    NSURL *redirectUri;
    NSURL *callBackUri;
    NSString *uriScheme;

    NSString *state;
    NSString *code;
    NSString *accessTokenString;
    NSString *idTokenString;
    long expiresIn;
    long expiration;

    NSString *uriFragment;
    NSString *queryParameter;

    YConnectAuthorizationCallBackUriParser *parser;
}

- (void)testParseExplicitCallbackUri;
- (void)testParseExplicitCallbackUriNoCallbackUri;
- (void)testParseExplicitCallbackUriNoRedirectUri;
- (void)testParseExplicitCallbackUriCallbackError;
- (void)testParseExplicitCallbackUriNoParamersError;
- (void)testParseExplicitCallbackUriIncludeError;
- (void)testParseExplicitCallbackUriIncludeInvalidState;
- (void)testParseExplicitCallbackUriNotIncludeState;
- (void)testParseExplicitCallbackUriNotIncludeAuthorizationCode;

- (void)testParseImplicitCallbackUri;
- (void)testParseImplicitCallbackUriNoRedirectUri;
- (void)testParseImplicitCallbackUriCallbackError;
- (void)testParseImplicitCallbackUriNoParamersError;
- (void)testParseImplicitCallbackUriIncludeError;
- (void)testParseImplicitCallbackUriNotIncludeAccessToken;
- (void)testParseImplicitCallbackUriNotIncludeExpiresIn;
- (void)testParseImplicitCallbackUriNotMatchState;
- (void)testParseImplicitCallbackUriNotIncludeState;
- (void)testParseImplicitCallbackUriNotIncludeIdToken;
@end
