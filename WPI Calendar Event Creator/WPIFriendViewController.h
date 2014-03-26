//
//  WPIFriendViewController.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/3/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPIFriendViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
