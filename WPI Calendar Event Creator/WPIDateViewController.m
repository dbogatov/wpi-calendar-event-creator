//
//  WPIDateViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIDateViewController.h"
#import "WPIModel.h"

@interface WPIDateViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSArray *durationPickerItems;

@end

@implementation WPIDateViewController

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

    self.durationPickerItems = @[@"5 minutes", @"10 minutes", @"15 minutes", @"30 minutes", @"45 minutes", @"1 hour", @"1.5 hours", @"2 hours"];
    
    WPIModel *model = [WPIModel sharedDataModel];
    
    [self.datePicker setDate:[model.data valueForKey:@"Date"]];
    [self.durationPicker selectRow:[(NSNumber*)[model.data valueForKey:@"Duration Picker Index"] integerValue] inComponent:0 animated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        NSDate *date = self.datePicker.date;
        NSInteger duration = 0;
        switch ([self.durationPicker selectedRowInComponent:0]) {
            case 0:
                duration = 5;
                break;
            case 1:
                duration = 10;
                break;
            case 2:
                duration = 15;
                break;
            case 3:
                duration = 30;
                break;
            case 4:
                duration = 45;
                break;
            case 5:
                duration = 60;
                break;
            case 6:
                duration = 90;
                break;
            case 7:
                duration = 120;
                break;
            default:
                break;
        }
        
        WPIModel *model = [WPIModel sharedDataModel];
        NSMutableArray *events = [model fetchEventsForDate:date duration:duration];
        NSLog(@"evets: %@", events);
        if (events.count) {
            [model.data setValue:@"Time Conflict!" forKey:@"Conflict"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date Conflict Warning" message:@"There are some events in your default calendar at the time you picked. You are still allowed to add event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            [model.data setValue:@"" forKey:@"Conflict"];
        }
        
        [model.data setValue:self.datePicker.date forKey:@"Date"];
        [model.data setValue:[NSNumber numberWithInteger:duration] forKey:@"Duration"];
        [model.data setValue:[NSNumber numberWithInteger:[self.durationPicker selectedRowInComponent:0]] forKey:@"Duration Picker Index"];
        
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 8;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.durationPickerItems objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:228.0/255.0 blue:181.0/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    //label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [self.durationPickerItems objectAtIndex:row];
    return label;    
}

#pragma mark - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Selected date: %@, selected duration: %ld", self.datePicker.date, (long)[self.durationPicker selectedRowInComponent:0]);
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
