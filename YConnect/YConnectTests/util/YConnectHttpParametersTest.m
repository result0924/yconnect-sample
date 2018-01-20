//
//  HttpParametersTest.m
//  Http
//
//  Copyright (c) 2012年 Yahoo Japan Corporation. All rights reserved.
//

#import "YConnectHttpParametersTest.h"

@implementation YConnectHttpParametersTest
- (void)setUp
{
    [super setUp];

    parameters = [[YConnectHttpParameters alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * (id)init
 * @test例外を投げずに初期化できるか(正常系)
 **/
- (void)testInit
{
    XCTAssertNoThrow(parameters = [[YConnectHttpParameters alloc] init], @"");
}

/**
 * (NSString *)toQueryString
 * @test Httpクエリーパラメータ用に文字列化して取得できているか(正常系)
 **/
- (void)testToQueryString
{
    NSString *expected = @"name=value";
    [parameters setValue:@"value" forKey:@"name"];
    XCTAssertEqualObjects([parameters toQueryString], expected, @"not match toQueryString");
}

/**
 * (NSString *)toQueryString
 * @test Httpクエリーパラメータ用に複数のパラメータを文字列化して取得できているか(正常系)
 **/
- (void)testToQueryStringMulti
{
    NSString *expected = @"name1=value1&name2=value2&name3=value3";
    [parameters setValue:@"value1" forKey:@"name1"];
    [parameters setValue:@"value2" forKey:@"name2"];
    [parameters setValue:@"value3" forKey:@"name3"];
    XCTAssertEqualObjects([parameters toQueryString], expected, @"not match toQueryString (multi)");
}

/**
 * (void)setValue:(id)value forKey:(NSString *)key
 * @test 例外を投げずにキーと値をセットできるか(正常系)
 **/
- (void)testSetValue
{
    XCTAssertNoThrow([parameters setValue:@"value" forKey:@"name"], @"Throw exception");
}

/**
 * (id)objectForKey:(id)aKey
 * @test キーを指定して値を取得でき、一致するか(正常系)
 **/
- (void)testObjectForKey
{
    [parameters setValue:@"value" forKey:@"name"];
    XCTAssertEqualObjects([parameters objectForKey:@"name"], @"value", @"not match value");
}

/**
 * (NSArray *)allKeys
 * @test 複数のキーを取得し、一致するか(正常系)
 **/
- (void)testAllKeys
{
    [parameters setValue:@"value" forKey:@"name1"];
    [parameters setValue:@"value" forKey:@"name2"];
    [parameters setValue:@"value" forKey:@"name3"];
    XCTAssertTrue([[parameters allKeys] containsObject:@"name1"], @"not include name1");
    XCTAssertTrue([[parameters allKeys] containsObject:@"name2"], @"not include name2");
    XCTAssertTrue([[parameters allKeys] containsObject:@"name3"], @"not include name3");
    XCTAssertTrue([[parameters allKeys] count] == 3, @"not match array_size");
}

/**
 * (NSUInteger)count
 * @test 格納されているサイズを取得し、一致するか(正常系)
 **/
- (void)testCount
{
    [parameters setValue:@"value" forKey:@"name1"];
    [parameters setValue:@"value" forKey:@"name2"];
    [parameters setValue:@"value" forKey:@"name3"];
    XCTAssertTrue([parameters count] == 3, @"not match parameters_count");
}
@end
