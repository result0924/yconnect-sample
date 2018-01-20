//
//  OAuth2ResponseTypeTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOAuth2ResponseTypeTest.h"

@implementation YConnectOAuth2ResponseTypeTest
- (void)setUp
{
    [super setUp];    
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (NSString *)CODE
 * @test レスポンス形式のCodeを表す定数値と一致するか(正常系)
 **/
- (void)testCODE {
    XCTAssertEqualObjects([YConnectOAuth2ResponseType CODE], @"code", @"Not match 'CODE'");
}
/**
 * (NSString *)TOKEN
 * @test レスポンス形式のTOKENを表す定数値と一致するか(正常系)
 **/
- (void)testTOKEN {
    XCTAssertEqualObjects([YConnectOAuth2ResponseType TOKEN], @"token", @"Not match 'TOKEN'");
}
/**
 * (NSString *)IDTOKEN
 * @test レスポンス形式のIDTOKENを表す定数値と一致するか(正常系)
 **/
- (void)testIDTOKEN {
    XCTAssertEqualObjects([YConnectOAuth2ResponseType IDTOKEN], @"id_token", @"Not match 'IDTOKEN'");
}
/**
 * (NSString *)CODE_IDTOKEN
 * @test レスポンス形式のCODEとIDTOKENを表す定数値と一致するか(正常系)
 **/
- (void)testCODE_IDTOKEN {
    XCTAssertEqualObjects([YConnectOAuth2ResponseType CODE_IDTOKEN], @"code%20id_token", @"Not match 'CODE_IDTOKEN'");
}
/**
 * (NSString *)TOKEN_IDTOKEN
 * @test レスポンス形式のTOKENとIDTOKENを表す定数値と一致するか(正常系)
 **/
- (void)testTOKEN_IDTOKEN {
    XCTAssertEqualObjects([YConnectOAuth2ResponseType TOKEN_IDTOKEN], @"token%20id_token", @"Not match 'TOKEN_IDTOKEN'");
}

@end
