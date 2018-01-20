//
//  BearerTokenTest.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectBearerTokenTest.h"

@implementation YConnectBearerTokenTest
- (void)setUp
{
    [super setUp];
    accessToken = @"qwertyuiop";
    expiresIn = 3600L;
    expiration = expiresIn + (long)floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - 60L;
    refreshToken = @"asdfghjkl";
    scope = @"hoge";
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration
 * @test アクセストークンと有効期限を入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithParameters
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration];
    XCTAssertEqualObjects(accessToken, bearerToken.accessToken, @"accessToken not match");
    XCTAssertEqual(expiration, bearerToken.expiration, @"expiration not match");
    XCTAssertNil(bearerToken.refreshToken, @"refreshToken not nil");
    XCTAssertNil(bearerToken.scope, @"scope not nil");
}
/**
 * (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration refreshToken:(NSString *)refreshToken
 * @test アクセストークンと有効期限、リフレッシュトークンを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithParametersIncludeRefreshToken
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration refreshToken:refreshToken];
    XCTAssertEqualObjects(accessToken, bearerToken.accessToken, @"accessToken not match");
    XCTAssertEqual(expiration, bearerToken.expiration, @"expiration not match");
    XCTAssertEqualObjects(accessToken, bearerToken.accessToken, @"refreshToken not match");
    XCTAssertNil(bearerToken.scope, @"scope not nil");
}

/**
 * (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration refreshToken:(NSString *)refreshToken scope:(NSString *)scope
 * @test アクセストークンと有効期限、リフレッシュトークン、Scope値を入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithParametersIncludeScope
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration refreshToken:refreshToken scope:scope];
    XCTAssertEqualObjects(accessToken, bearerToken.accessToken, @"accessToken not match");
    XCTAssertEqual(expiration, bearerToken.expiration, @"expiration not match");
    XCTAssertEqualObjects(accessToken, bearerToken.accessToken, @"refreshToken not match");
    XCTAssertEqualObjects(scope, bearerToken.scope, @"scope not match");
}
/**
 * (NSString *)toAuthorizationHeader
 * @test リクエスト用ヘッダの文字列であるアクセストークンを取得できるか(正常系)
 **/
- (void)testToAuthorizationHeader
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration];
    XCTAssertEqualObjects([bearerToken toAuthorizationHeader], accessToken, @"toAuhtoizationHeader not match");
}
/**
 * (NSString *)toQueryString
 * @test クエリ文字列用にアクセストークンを取得できるか(正常系)
 **/
- (void)testToQueryString
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration];
    NSString *query = [[NSString alloc] initWithFormat:@"access_token=%@", accessToken];
    XCTAssertEqualObjects([bearerToken toQueryString], query, @"toQueryString not match");
}
/**
 * (NSString *)toString
 * @test トークンを文字列化して取得できるか(正常系)
 **/
- (void)testToString
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration];
    NSString *query = [[NSString alloc] initWithFormat:@"{access_token: %@, expiration: %ld}", accessToken, (long)expiration];
    XCTAssertEqualObjects([bearerToken toString], query, @"toString not match");
}
/**
 * (NSString *)toString
 * @test リフレッシュトークンを含むトークンを文字列化して取得できるか(正常系)
 **/
- (void)testToStringIncludeRefreshToken
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration refreshToken:refreshToken];
    NSString *query = [[NSString alloc] initWithFormat:@"{access_token: %@, expiration: %ld, refresh_token: %@}", accessToken, (long)expiration, refreshToken];
    XCTAssertEqualObjects([bearerToken toString], query, @"toString(include refreshToken) not match");
}
/**
 * (NSString *)toString
 * @test Scopeを含むトークンを文字列化して取得できるか(正常系)
 **/
- (void)testToStringIncludeScope
{
    bearerToken = [[YConnectBearerToken alloc] initWithAccessToken:accessToken expiration:expiration refreshToken:refreshToken scope:scope];
    NSString *query = [[NSString alloc] initWithFormat:@"{access_token: %@, expiration: %ld, refresh_token: %@, scope: %@}", accessToken, (long)expiration, refreshToken, scope];
    XCTAssertEqualObjects([bearerToken toString], query, @"toString(include scope) not match");
}
/**
 * (NSInterger)expirationWithExpiresIn:(NSInteger)expiresIn
 * @test expirationを取得できるか(正常系)
 **/
- (void)testExpirationWithExpiresIn
{
    XCTAssertEqual([YConnectBearerToken expirationWithExpiresIn:expiresIn], expiration, @"expirationWithExpiresIn not match");
}
@end
