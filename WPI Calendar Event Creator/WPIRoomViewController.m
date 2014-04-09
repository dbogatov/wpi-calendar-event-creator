//
//  WPIRoomViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/7/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIRoomViewController.h"
#import "WPIModel.h"

@interface WPIRoomViewController ()
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomLetterTextField;
@property (weak, nonatomic) IBOutlet UITextField *specificPlaceTextField;

@end

@implementation WPIRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {
    WPIModel *model = [WPIModel sharedDataModel];
    if (self.specificPlaceTextField.text.length != 0) {
        [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Specific Place"];
    } else {
        [model.data setObject:[NSNumber numberWithBool:NO] forKey:@"Use Specific Place"];
    }
    [model.data setObject:[NSNumber numberWithBool:NO] forKey:@"Use Professors Office"];
    [model.data setValue:self.roomNumberTextField.text forKey:@"Room Number"];
    [model.data setValue:self.roomLetterTextField.text forKey:@"Room Letter"];
    [model.data setValue:self.specificPlaceTextField.text forKey:@"Specific Place"];
}

-(void)viewDidAppear:(BOOL)animated {
 [self.roomNumberTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.roomNumberTextField.inputAccessoryView = numberToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneWithNumberPad{
    [self.roomNumberTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
