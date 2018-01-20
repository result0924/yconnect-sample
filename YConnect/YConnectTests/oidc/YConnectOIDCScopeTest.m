//
//  OIDCScopeTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOIDCScopeTest.h"

@implementation YConnectOIDCScopeTest
- (void)setUp
{
    [super setUp];    
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (NSString *) OPENID
 * @test OpenID Connect scopeの定数値が一致するか(正常系)
 **/
- (void)testOPENID {
    XCTAssertEqualObjects([YConnectOIDCScope OPENID], @"openid", @"Not match 'OPENID'");
}
/**
 * (NSString *) PROFILE
 * @test ユーザ属性情報scopeの定数値が一致するか(正常系)
 **/
- (void)testPROFILE {
    XCTAssertEqualObjects([YConnectOIDCScope PROFILE], @"profile", @"Not match 'PROFILE'");
}
/**
 * (NSString *) EMAIL
 * @test ユーザー登録メアドscopeの定数値が一致するか(正常系)
 **/
- (void)testEMAIL {
    XCTAssertEqualObjects([YConnectOIDCScope EMAIL], @"email", @"Not match 'EMAIL'");
}
/**
 * (NSString *) address
 * @test ユーザ登録住所scopeの定数値が一致するか(正常系)
 **/
- (void)testADDRESS {
    XCTAssertEqualObjects([YConnectOIDCScope ADDRESS], @"address", @"Not match 'ADDRESS'");
}

@end
