//
//  ExplicitCallbackUriParserTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectExplicitCallbackUriParser.h"

@interface YConnectExplicitCallbackUriParserTest : XCTestCase {
    NSURL *redirectUri;
    NSString *callBackUri;
    
    NSString *state;
    NSString *code;
    
    NSString *queryParameter;
    
    YConnectExplicitCallbackUriParser *parser;
    
}

- (void)testInitWithParameters;
- (void)testInitWithParametersNoRedirectUri;
- (void)testInitWithParametersCallbackError;
- (void)testInitWithParametersNoParamersError;
- (void)testInitWithParametersIncludeError;
- (void)testInitWithParametersIncludeInvalidState;
- (void)testInitWithParametersNotIncludeState;
- (void)testInitWithParametersNotIncludeAuthorizationCode;
@end
