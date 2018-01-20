//
//  UserInfoObject.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConnectUserInfoObject : NSObject
@property (nonatomic, retain) NSString *sub;
@property (nonatomic, retain) NSString *locale;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *givenName;
@property (nonatomic, retain) NSString *givenNameJaKanaJp;
@property (nonatomic, retain) NSString *givenNameJaHaniJp;
@property (nonatomic, retain) NSString *familyName;
@property (nonatomic, retain) NSString *familyNameJaKanaJp;
@property (nonatomic, retain) NSString *familyNameJaHaniJp;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *emailVerified;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *zoneinfo;
@property (nonatomic, retain) NSString *birthdate;
@property (nonatomic, retain) NSString *addressCountry;
@property (nonatomic, retain) NSString *addressPostalCode;
@property (nonatomic, retain) NSString *addressRegion;
@property (nonatomic, retain) NSString *addressLocality;
@property (nonatomic, retain) NSString *addressStreetAddress;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSDictionary *additionalClaims;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *nickname;

// v1のみのパラメーター
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *birthday;

- (id)initWithUserId:(NSString *)userId;
- (id)initWithJson:(NSString *)json;
- (NSString *)toString;
- (NSString *)getAdditionalValueWithKey:(NSString *)key;

@end
