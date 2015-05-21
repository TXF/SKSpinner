//
//  SKSpinnerTests.m
//  SKSpinnerTests
//
//  Created by David on 05/15/2015.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SKSpinner.h>

@interface Tests : XCTestCase
@property (nonatomic, strong) SKSpinner *spinner;
@property (nonatomic, strong) UIView *view;
@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.view = [[UIView alloc] init];
    self.view.bounds = [[UIScreen mainScreen] bounds];
    self.spinner = [[SKSpinner alloc]initWithView:self.view];
    [self.spinner showAnimated:YES];
}

- (void)tearDown
{
    self.spinner = nil;
    self.view = nil;
    [super tearDown];
}

- (void)testExample
{
    XCTAssertNotNil(self.spinner, @"Should be able to create a new Spinner instance");
}

@end
