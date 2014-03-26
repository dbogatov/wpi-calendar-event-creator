//
//  WPINotesViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/8/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPINotesViewController.h"
#import "WPIModel.h"

@interface WPINotesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *notesTextField;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPINotesViewController

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
    [model.data setValue:self.notesTextField.text forKey:@"Notes"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
