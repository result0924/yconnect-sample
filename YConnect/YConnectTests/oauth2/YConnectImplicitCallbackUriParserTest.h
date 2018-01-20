//
//  ImplicitCallbackUriParserTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectImplicitCallbackUriParser.h"

@interface YConnectImplicitCallbackUriParserTest : XCTestCase {
    NSURL *redirectUri;
    NSString *callBackUri;
    
    NSString *state;
    NSString *accessToken;
    long expiresIn;
    long expiration;
    NSString *idToken;
    
    NSString *uriFragment;
    
    YConnectImplicitCallbackUriParser *parser;
    
}

- (void)testInitWithParametersNoThrows;
- (void)testInitWithParametersNoRedirectUriNoThrows;
- (void)testInitWithParametersCallbackErrorNoThrows;
- (void)testInitWithParametersNoParamersErrorNoThrows;
- (void)testInitWithParametersIncludeErrorNoThrows;
- (void)testInitWithParametersNotIncludeAccessTokenNoThrows;
- (void)testInitWithParametersNotIncludeExpiresInNoThrows;
- (void)testInitWithParametersNotMatchStateNoThrows;
- (void)testInitWithParametersNotIncludeStateNoThrows;
- (void)testInitWithParametersNotIncludeIdTokenNoThrows;
@end
