//
//  WPIMissingProfessorViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIMissingProfessorViewController.h"
#import "WPIModel.h"

@interface WPIMissingProfessorViewController ()

- (IBAction)writeEmail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *professorName;

@end

@implementation WPIMissingProfessorViewController

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

-(void) viewWillDisappear:(BOOL)animated {
    WPIModel *model = [WPIModel sharedDataModel];
    [model.data setValue:self.textField.text forKey:@"Custom Professor"];
    [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Custom Professor"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)writeEmail:(UIButton *)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:@[@"dbogatov@wpi.edu"]];
        [mailViewController setSubject:@"Missing Professor"];
        NSString *message = [NSString stringWithFormat:@"It would be great, if you added\n %@ \n to your list of professors.", self.professorName.text];
        [mailViewController setMessageBody:message isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
        //[self presentModalViewController:mailViewController animated:YES completion:nil];
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't do that :(" message:@"Device is unable to send email in its current state." delegate:self cancelButtonTitle:@"Okey" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
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
