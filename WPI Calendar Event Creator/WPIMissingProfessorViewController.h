//
//  WPIMissingProfessorViewController.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WPIMissingProfessorViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end
