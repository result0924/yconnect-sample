//
//  OAuth2ScopeTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOAuth2ScopeTest.h"

@implementation YConnectOAuth2ScopeTest
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
 * @test Scope値の識別子を表す定数値と一致するか(正常系)
 **/
- (void)testOPENID {
    XCTAssertEqualObjects([YConnectOAuth2Scope OPENID], @"openid", @"Not match 'OPENID'");
}
/**
 * (NSString *) OPENID_PROFILE
 * @test Scope値の識別子とユーザの基本情報を表す定数値と一致するか(正常系)
 **/
- (void)testOPENID_PROFILE {
    XCTAssertEqualObjects([YConnectOAuth2Scope OPENID_PROFILE], @"openid%20profile", @"Not match 'OPENID_PROFILE'");
}
/**
 * (NSString *) OPENID_EMAIL_ADDRESS
 * @test Scope値の識別子とユーザの基本情報、メールアドレスを表す定数値と一致するか(正常系)
 **/
- (void)testOPENID_EMAIL_ADDRESS {
    XCTAssertEqualObjects([YConnectOAuth2Scope OPENID_EMAIL_ADDRESS], @"openid%20email%20address", @"Not match 'OPENID_EMAIL_ADDRESS'");
}

@end
