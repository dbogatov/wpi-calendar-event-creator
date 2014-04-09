//
//  WPIFriendViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/3/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIFriendViewController.h"
#import "WPIModel.h"

@interface WPIFriendViewController ()
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPIFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated {
    if ([(NSNumber*)[[WPIModel sharedDataModel].data valueForKey:@"Type"] integerValue] == 1) {
        [self.textField becomeFirstResponder];
    } else {
        [self.textView becomeFirstResponder];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    WPIModel *model = [WPIModel sharedDataModel];
    if ([(NSNumber*)[[WPIModel sharedDataModel].data valueForKey:@"Type"] integerValue] == 1) {
        [model.data setValue:self.textField.text forKey:@"Details Friend"];
    } else {
        [model.data setValue:self.textView.text forKey:@"Details Custom"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
