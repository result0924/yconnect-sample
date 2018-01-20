//
//  BearerToken.h
//  YConnect
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectBearerToken : NSObject <NSCoding>
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic) long expiration;
@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *scope;
- (id)initWithAccessToken:(NSString *)accessToken
               expiration:(long)expiration;
- (id)initWithAccessToken:(NSString *)accessToken
               expiration:(long)expiration
             refreshToken:(NSString *)refreshToken;
- (id)initWithAccessToken:(NSString *)accessToken
               expiration:(long)expiration
             refreshToken:(NSString *)refreshToken
                    scope:(NSString *)scope;
- (NSString *)toAuthorizationHeader;
- (NSString *)toQueryString;
- (NSString *)toString;
+ (NSInteger)expirationWithExpiresIn:(NSInteger)expiresIn;
@end
