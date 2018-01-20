//
//  UserInfoObjectTest.h
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YConnectUserInfoObject.h"

@interface YConnectUserInfoObjectTest : XCTestCase {
    NSString *userId;
    NSString *locale;
    NSString *name;
    NSString *givenName;
    NSString *givenNameJaKanaJp;
    NSString *givenNameJaHaniJp;
    NSString *familyName;
    NSString *familyNameJaKanaJp;
    NSString *familyNameJaHaniJp;
    NSString *email;
    NSString *emailVerified;
    NSString *gender;
    NSString *birthday;
    NSString *addressCountry;
    NSString *addressPostalCode;
    NSString *addressRegion;
    NSString *addressLocality;
    NSString *addressStreetAddress;
    NSString *phoneNumber;
    NSString *urnYahooJpUserinfoGuid;
    NSString *urnYahooJpUserinfoCategoryIndastory;
    NSString *urnYahooJpUserinfoCategoryJob;

    NSString *json;

    YConnectUserInfoObject *userInfoObject;
}

- (void)testInitWithUserId;
- (void)testInitWithJson;
- (void)testToString;
- (void)testGetAdditionalValueWithKey;
@end
