//
//  OAuth2ResponseTypeTest.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectOAuth2ResponseType.h"
@interface YConnectOAuth2ResponseTypeTest : XCTestCase

- (void)testCODE;
- (void)testTOKEN;
- (void)testIDTOKEN;
- (void)testCODE_IDTOKEN;
- (void)testTOKEN_IDTOKEN;
@end
