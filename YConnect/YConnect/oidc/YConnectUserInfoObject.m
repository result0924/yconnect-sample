//
//  UserInfoObject.m
//  YConnect
//
//  Copyright (c) 2013年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectUserInfoObject.h"
#import "YConnectLog.h"
#import "NSNull+isNull.h"

@implementation YConnectUserInfoObject

/**
 * 初期化
 * @param NSString *userId
 * @return id
 **/
- (id)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

/**
 * 初期化
 * @param NSString *json
 * @return id
 **/
- (id)initWithJson:(NSString *)json
{
    self = [super init];

    if (self) {
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization
            JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                       options:NSJSONReadingAllowFragments
                         error:&error];

        self.userId = [jsonObject objectForKey:@"user_id"];
        self.sub = [jsonObject objectForKey:@"sub"];
        self.locale = [jsonObject objectForKey:@"locale"];
        self.name = [jsonObject objectForKey:@"name"];
        self.givenName = [jsonObject objectForKey:@"given_name"];
        self.givenNameJaKanaJp = [jsonObject objectForKey:@"given_name#ja-Kana-JP"];
        self.givenNameJaHaniJp = [jsonObject objectForKey:@"given_name#ja-Hani-JP"];
        self.familyName = [jsonObject objectForKey:@"family_name"];
        self.familyNameJaKanaJp = [jsonObject objectForKey:@"family_name#ja-Kana-JP"];
        self.familyNameJaHaniJp = [jsonObject objectForKey:@"family_name#ja-Hani-JP"];
        self.email = [jsonObject objectForKey:@"email"];
        self.emailVerified = [jsonObject objectForKey:@"email_verified"];
        self.gender = [jsonObject objectForKey:@"gender"];
        self.zoneinfo = [jsonObject objectForKey:@"zoneinfo"];
        self.birthdate = [jsonObject objectForKey:@"birthdate"];
        self.birthday = [jsonObject objectForKey:@"birthday"];
        self.phoneNumber = [jsonObject objectForKey:@"phone_number"];
        self.picture = [jsonObject objectForKey:@"picture"];
        self.nickname = [jsonObject objectForKey:@"nickname"];

        if (![NSNull isNull:[jsonObject objectForKey:@"address"]]) {
            self.addressCountry = [jsonObject valueForKeyPath:@"address.country"];
            self.addressPostalCode = [jsonObject valueForKeyPath:@"address.postal_code"];
            self.addressRegion = [jsonObject valueForKeyPath:@"address.region"];
            self.addressLocality = [jsonObject valueForKeyPath:@"address.locality"];
            self.addressStreetAddress = [jsonObject valueForKeyPath:@"address.street_address"];
        }
        NSMutableArray *additionalKeys = [NSMutableArray array];
        NSMutableArray *additionalValues = [NSMutableArray array];
        for (id key in [jsonObject keyEnumerator]) {
            if ([key hasPrefix:@"urn:"]) {
                [additionalKeys addObject:key];
                [additionalValues addObject:[jsonObject valueForKey:key]];
            }
        }
        self.additionalClaims = [NSDictionary dictionaryWithObjects:additionalValues forKeys:additionalKeys];
    }
    return self;
}

- (NSString *)toString
{
    NSDictionary *addressClaims = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    self.addressCountry, @"country",
                                                    self.addressPostalCode, @"postal_code",
                                                    self.addressRegion, @"region",
                                                    self.addressLocality, @"locality",
                                                    self.addressStreetAddress, @"street_address", nil];

    NSMutableDictionary *claimsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                               self.userId, @"user_id",
                                                               self.sub, @"sub",
                                                               self.locale, @"locale",
                                                               self.name, @"name",
                                                               self.givenName, @"given_name",
                                                               self.givenNameJaKanaJp, @"given_name#ja-Kana-JP",
                                                               self.givenNameJaHaniJp, @"given_name#ja-Hani-JP",
                                                               self.familyName, @"family_name",
                                                               self.familyNameJaKanaJp, @"family_name#ja-Kana-JP",
                                                               self.familyNameJaHaniJp, @"family_name#ja-Hani-JP",
                                                               self.email, @"email",
                                                               self.emailVerified, @"email_verified",
                                                               self.gender, @"gender",
                                                               self.zoneinfo, @"zoneinfo",
                                                               self.birthdate, @"birthdate",
                                                               self.birthday, @"birthday",
                                                               self.phoneNumber, @"phone_number",
                                                               addressClaims, @"address",
                                                               self.picture, @"picture",
                                                               self.nickname, @"nickname" ,nil];

    if ([self.additionalClaims count] > 0) {
        for (id key in [self.additionalClaims keyEnumerator]) {
            [claimsDict setObject:[self.additionalClaims valueForKey:key] forKey:key];
        }
    }

    if ([NSJSONSerialization isValidJSONObject:claimsDict]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:claimsDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return json;
    }

    return nil;
}

- (NSString *)getAdditionalValueWithKey:(NSString *)key
{
    if (![NSNull isNull:[self.additionalClaims objectForKey:key]]) {
        return [self.additionalClaims objectForKey:key];
    }
    return nil;
}

@end
