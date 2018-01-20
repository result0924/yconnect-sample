//
//  BearerToken.m
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectBearerToken.h"
#import "YConnectLog.h"
#import "NSNull+isNull.h"

static NSInteger const YConnectBearerTokenExpirationMargin = 60L;

@implementation YConnectBearerToken

/**
 * 初期化
 * @param NSString *accessToken
 * @param long expiration
 * @return id
 **/
- (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _expiration = expiration;
    }
    return self;
}
/**
 * 初期化
 * @param NSString *accessToken
 * @param long expiration
 * @param NSString *refreshToken
 * @return id
 **/
- (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration refreshToken:(NSString *)refreshToken
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _expiration = expiration;
        _refreshToken = refreshToken;
    }
    return self;
}
/**
 * 初期化
 * @param NSString *accessToken
 * @param long expiration
 * @param NSString *refreshToken
 * @param NSString *scope
 * @return id
 **/
- (id)initWithAccessToken:(NSString *)accessToken expiration:(long)expiration refreshToken:(NSString *)refreshToken scope:(NSString *)scope
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _expiration = expiration;
        _refreshToken = refreshToken;
        _scope = scope;
    }
    return self;
}
/**
 * Authリクエスト用のヘッダ文字列取得
 * @return NSString *
 **/
- (NSString *)toAuthorizationHeader
{
    return self.accessToken;
}
/**
 * リクエスト用のクエリ文字列取得
 * @return NSString *
 **/
- (NSString *)toQueryString
{
    return [NSString stringWithFormat:@"access_token=%@", self.accessToken];
}
/**
 * トークンの文字列化(JSON文字列)
 * @return NSString *
 **/
- (NSString *)toString
{
    NSString *result = [NSString stringWithFormat:@"{access_token: %@, expiration: %ld", self.accessToken, self.expiration];
    if (![NSNull isNull:self.refreshToken]) {
        result = [result stringByAppendingFormat:@", refresh_token: %@", self.refreshToken];
    }
    if (![NSNull isNull:self.scope]) {
        result = [result stringByAppendingFormat:@", scope: %@", self.scope];
    }
    result = [result stringByAppendingString:@"}"];
    return result;
}

/**
 * NSCodingプロトコル
 * NSUserDefaultsへの対応
 * @param NSCoder *aDecoder
 * @return id
 **/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        _expiration = [aDecoder decodeInt64ForKey:@"expiration"];
        _refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
        _scope = [aDecoder decodeObjectForKey:@"scope"];
    }
    return self;
}
/**
 * NSCodingプロトコル
 * NSUserDefaultsへの対応
 * @param NSCoder *aCoder
 **/
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeInt64:self.expiration forKey:@"expiration"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [aCoder encodeObject:self.scope forKey:@"scope"];
}

+ (NSInteger)expirationWithExpiresIn:(NSInteger)expiresIn
{
    return expiresIn + floor(CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) - YConnectBearerTokenExpirationMargin;
}

@end
