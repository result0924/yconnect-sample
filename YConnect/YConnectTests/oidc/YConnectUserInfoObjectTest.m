//
//  UserInfoObjectTest.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectUserInfoObjectTest.h"

@implementation YConnectUserInfoObjectTest

- (void)setUp
{
    [super setUp];
    //デフォルト値
    userId = @"chkminiyj_yconnect_ios_test1";
    locale = @"ja_JP";
    name = @"矢風太郎";
    givenName = @"太郎";
    givenNameJaKanaJp = @"タロウ";
    givenNameJaHaniJp = @"太郎";
    familyName = @"矢風";
    familyNameJaKanaJp = @"ヤフウ";
    familyNameJaHaniJp = @"矢風";
    email = @"yahootaro@example.com";
    emailVerified = @"true";
    gender = @"male";
    birthday = @"01/01/1970";
    addressCountry = @"jp";
    addressPostalCode = @"1076211";
    addressRegion = @"東京都";
    addressLocality = @"港区";
    addressStreetAddress = @"赤坂９丁目７-1";
    phoneNumber = @"0364406000";
    urnYahooJpUserinfoGuid = @"HZENZMNCYNUWXGSZIRXZRLETFM ";
    urnYahooJpUserinfoCategoryIndastory = @"1";
    urnYahooJpUserinfoCategoryJob = @"1";

    json = [NSString stringWithFormat:@"{"
                                       "\"user_id\":\"%@\","
                                       "\"locale\":\"%@\","
                                       "\"name\":\"%@\","
                                       "\"given_name\":\"%@\","
                                       "\"given_name#ja-Kana-JP\":\"%@\","
                                       "\"given_name#ja-Hani-JP\":\"%@\","
                                       "\"family_name\":\"%@\","
                                       "\"family_name#ja-Kana-JP\":\"%@\","
                                       "\"family_name#ja-Hani-JP\":\"%@\","
                                       "\"email\":\"%@\","
                                       "\"email_verified\":\"%@\","
                                       "\"gender\":\"%@\","
                                       "\"birthday\":\"%@\","
                                       "\"address\":{"
                                       "\"country\":\"%@\","
                                       "\"postal_code\":\"%@\","
                                       "\"region\":\"%@\","
                                       "\"locality\":\"%@\","
                                       "\"street_address\":\"%@\""
                                       "},"
                                       "\"phone_number\":\"%@\","
                                       "\"urn:yahoo:jp:userinfo:guid\":\"%@\","
                                       "\"urn:yahoo:jp:userinfo:category\":{"
                                       "\"industry\":\"%@\","
                                       "\"job\":\"%@\""
                                       "}"
                                       "}",
                                      userId,
                                      locale,
                                      name,
                                      givenName,
                                      givenNameJaKanaJp,
                                      givenNameJaHaniJp,
                                      familyName,
                                      familyNameJaKanaJp,
                                      familyNameJaHaniJp,
                                      email,
                                      emailVerified,
                                      gender,
                                      birthday,
                                      addressCountry,
                                      addressPostalCode,
                                      addressRegion,
                                      addressLocality,
                                      addressStreetAddress,
                                      phoneNumber,
                                      urnYahooJpUserinfoGuid,
                                      urnYahooJpUserinfoCategoryIndastory,
                                      urnYahooJpUserinfoCategoryJob];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (id)initWithUserId:(NSString *)userId
 * @test 各パラメータを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithUserId
{
    userInfoObject = [[YConnectUserInfoObject alloc] initWithUserId:userId];
    XCTAssertEqualObjects(userId, userInfoObject.userId, @"userId not match");
}

/**
 * (id)initWithJson:(NSString *)json
 * @test 各パラメータを入力して初期化を行い、保持できているか(正常系)
 **/
- (void)testInitWithJson
{
    userInfoObject = [[YConnectUserInfoObject alloc] initWithJson:json];

    XCTAssertEqualObjects(userId, userInfoObject.userId, @"userId not match");
    XCTAssertEqualObjects(locale, userInfoObject.locale, @"locale not match");
    XCTAssertEqualObjects(name, userInfoObject.name, @"name not match");
    XCTAssertEqualObjects(givenName, userInfoObject.givenName, @"givenName not match");
    XCTAssertEqualObjects(givenNameJaKanaJp, userInfoObject.givenNameJaKanaJp, @"givenNameJaKanaJp not match");
    XCTAssertEqualObjects(givenNameJaHaniJp, userInfoObject.givenNameJaHaniJp, @"givenNameJaHaniJp not match");
    XCTAssertEqualObjects(familyName, userInfoObject.familyName, @"familyName not match");
    XCTAssertEqualObjects(familyNameJaKanaJp, userInfoObject.familyNameJaKanaJp, @"familyNameJaKanaJp not match");
    XCTAssertEqualObjects(familyNameJaHaniJp, userInfoObject.familyNameJaHaniJp, @"familyNameJaHaniJp not match");
    XCTAssertEqualObjects(email, userInfoObject.email, @"email not match");
    XCTAssertEqualObjects(emailVerified, userInfoObject.emailVerified, @"emailVerified not match");
    XCTAssertEqualObjects(gender, userInfoObject.gender, @"gender not match");
    XCTAssertEqualObjects(birthday, userInfoObject.birthday, @"birthday not match");
    XCTAssertEqualObjects(addressCountry, userInfoObject.addressCountry, @"addressCountry not match");
    XCTAssertEqualObjects(addressPostalCode, userInfoObject.addressPostalCode, @"addressPostalCode not match");
    XCTAssertEqualObjects(addressRegion, userInfoObject.addressRegion, @"addressRegion not match");
    XCTAssertEqualObjects(addressLocality, userInfoObject.addressLocality, @"addressLocality not match");
    XCTAssertEqualObjects(addressStreetAddress, userInfoObject.addressStreetAddress, @"addressStreetAddress not match");
    XCTAssertEqualObjects(phoneNumber, userInfoObject.phoneNumber, @"phoneNumber not match");
    XCTAssertEqualObjects(urnYahooJpUserinfoGuid, [userInfoObject.additionalClaims objectForKey:@"urn:yahoo:jp:userinfo:guid"], @"urnYahooJpUserinfoGuid not match");
}

/**
 * (NSString *)toString
 * @test 期待した通り(JSON形式)に文字列化できているか(正常系)
 **/
- (void)testToString
{
    userInfoObject = [[YConnectUserInfoObject alloc] initWithUserId:userId];
    userInfoObject.locale = locale;
    userInfoObject.name = name;
    userInfoObject.givenName = givenName;
    userInfoObject.givenNameJaKanaJp = givenNameJaKanaJp;
    userInfoObject.givenNameJaHaniJp = givenNameJaHaniJp;
    userInfoObject.familyName = familyName;
    userInfoObject.familyNameJaKanaJp = familyNameJaKanaJp;
    userInfoObject.familyNameJaHaniJp = familyNameJaHaniJp;
    userInfoObject.email = email;
    userInfoObject.emailVerified = emailVerified;
    userInfoObject.birthday = birthday;
    userInfoObject.gender = gender;
    userInfoObject.addressCountry = addressCountry;
    userInfoObject.addressPostalCode = addressPostalCode;
    userInfoObject.addressRegion = addressRegion;
    userInfoObject.addressLocality = addressLocality;
    userInfoObject.addressStreetAddress = addressStreetAddress;
    userInfoObject.phoneNumber = phoneNumber;
    userInfoObject.additionalClaims = [NSDictionary dictionaryWithObjectsAndKeys:urnYahooJpUserinfoGuid, @"urn:yahoo:jp:userinfo:guid", nil];

// workaround for 64bit
#if __LP64__
    NSString *expect = @"{"
                        "  \"family_name#ja-Hani-JP\" : \"矢風\","
                        "  \"family_name#ja-Kana-JP\" : \"ヤフウ\","
                        "  \"email\" : \"yahootaro@example.com\","
                        "  \"gender\" : \"male\","
                        "  \"phone_number\" : \"0364406000\","
                        "  \"user_id\" : \"chkminiyj_yconnect_ios_test1\","
                        "  \"locale\" : \"ja_JP\","
                        "  \"email_verified\" : \"true\","
                        "  \"birthday\" : \"01\\/01\\/1970\","
                        "  \"address\" : {"
                        "    \"locality\" : \"港区\","
                        "    \"country\" : \"jp\","
                        "    \"region\" : \"東京都\","
                        "    \"street_address\" : \"赤坂９丁目７-1\","
                        "    \"postal_code\" : \"1076211\""
                        "  },"
                        "  \"urn:yahoo:jp:userinfo:guid\" : \"HZENZMNCYNUWXGSZIRXZRLETFM \","
                        "  \"family_name\" : \"矢風\","
                        "  \"given_name#ja-Kana-JP\" : \"タロウ\","
                        "  \"given_name\" : \"太郎\","
                        "  \"name\" : \"矢風太郎\","
                        "  \"given_name#ja-Hani-JP\" : \"太郎\""
                        "}";
#else
    NSString *expect = @"{"
                        "  \"family_name\" : \"矢風\","
                        "  \"locale\" : \"ja_JP\","
                        "  \"given_name\" : \"太郎\","
                        "  \"family_name#ja-Kana-JP\" : \"ヤフウ\","
                        "  \"email_verified\" : \"true\","
                        "  \"given_name#ja-Kana-JP\" : \"タロウ\","
                        "  \"address\" : {"
                        "    \"country\" : \"jp\","
                        "    \"street_address\" : \"赤坂９丁目７-1\","
                        "    \"region\" : \"東京都\","
                        "    \"locality\" : \"港区\","
                        "    \"postal_code\" : \"1076211\""
                        "  },"
                        "  \"family_name#ja-Hani-JP\" : \"矢風\","
                        "  \"email\" : \"yahootaro@example.com\","
                        "  \"birthday\" : \"01\\/01\\/1970\","
                        "  \"given_name#ja-Hani-JP\" : \"太郎\","
                        "  \"urn:yahoo:jp:userinfo:guid\" : \"HZENZMNCYNUWXGSZIRXZRLETFM \","
                        "  \"user_id\" : \"chkminiyj_yconnect_ios_test1\","
                        "  \"gender\" : \"male\","
                        "  \"name\" : \"矢風太郎\","
                        "  \"phone_number\" : \"0364406000\""
                        "}";
#endif

    XCTAssertEqualObjects(expect, [userInfoObject toString], @"toString not match");
}

/**
 * (NSString *)getAdditionalValueWithKey:(NSString *)key;
 * @test 期待した通り(JSON形式)に文字列化できているか(正常系)
 **/
- (void)testGetAdditionalValueWithKey
{
    userInfoObject = [[YConnectUserInfoObject alloc] initWithJson:json];
    XCTAssertEqualObjects(urnYahooJpUserinfoGuid, [userInfoObject getAdditionalValueWithKey:@"urn:yahoo:jp:userinfo:guid"], @"urn:yahoo:jp:userinfo:guid not match");
}

@end
