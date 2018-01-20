//
//  OAuth2GrantTypeTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectOAuth2GrantTypeTest.h"
@implementation YConnectOAuth2GrantTypeTest
- (void)setUp
{
    [super setUp];    
}

- (void)tearDown
{   
    [super tearDown];
}

/**
 * (NSString *)AUTHORIZATION_CODE
 * @test リクエストの形式であるAuthorization Codeを表す定数値と一致するか(正常系)
 **/
- (void)testAUTHORIZATION_CODE {
    XCTAssertEqualObjects([YConnectOAuth2GrantType AUTHORIZATION_CODE], @"authorization_code", @"Not match 'AUTHORIZATION_CODE'");
}
/**
 * (NSString *)REFRESH_TOKEN
 * @test リクエストの形式であるRefresh Tokenを表す定数値と一致するか(正常系)
 **/
- (void)testREFRESH_TOKEN {
    XCTAssertEqualObjects([YConnectOAuth2GrantType REFRESH_TOKEN], @"refresh_token", @"Not match 'REFRESH_TOKEN'");
}

@end
