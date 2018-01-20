//
//  ResultViewController.h
//  YConnectDemo_ClientSideFlow
//
//  Copyright (c) 2014年 Yahoo Japan Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userid;
@property (weak, nonatomic) IBOutlet UILabel *error;

- (IBAction)fetchUserinfo:(id)sender;

@end
