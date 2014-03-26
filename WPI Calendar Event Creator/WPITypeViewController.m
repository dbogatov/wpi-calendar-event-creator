//
//  WPITypeViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPITypeViewController.h"


@interface WPITypeViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;

@property (strong, nonatomic) NSArray *typePickerItems;

@end

@implementation WPITypeViewController

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
    self.typePickerItems = @[@"Appointment with Professor", @"Organization / Friend Meeting", @"Custom..."];
    [self.typePicker selectRow:0 inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.typePickerItems objectAtIndex:row];
}

#pragma mark Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Selected type: %ld", (long)[self.typePicker selectedRowInComponent:0]);
}


- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    NSString *segueIdentifier;
    switch ([self.typePicker selectedRowInComponent:0]) {
        case 0:
            segueIdentifier = [NSString stringWithFormat:@"TypeToProfessorSegue"];
            break;
        case 1:
            segueIdentifier = [NSString stringWithFormat:@"TypeToFriendSegue"];
            break;
        case 2:
            segueIdentifier = [NSString stringWithFormat:@"TypeToCustomSegue"];
            break;
        default:
            NSLog(@"ERROR");
            break;
    }
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}
@end
