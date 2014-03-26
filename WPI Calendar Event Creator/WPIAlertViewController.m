//
//  WPIAlertViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIAlertViewController.h"
#import "WPIModel.h"

@interface WPIAlertViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *alertPicker;
@property (strong, nonatomic) NSArray *alertPickerItems;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPIAlertViewController

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
    [model.data setValue:[self.alertPickerItems objectAtIndex:[self.alertPicker selectedRowInComponent:0]]  forKey:@"Alert Time"];
    [model.data setValue:[NSNumber numberWithInteger:[self.alertPicker selectedRowInComponent:0]]  forKey:@"Alert Picker Index"];
    int time = 0;
    switch ([self.alertPicker selectedRowInComponent:0]) {
        case 0:
            time=-1;
            break;
        case 1:
            time=0;
            break;
        case 2:
            time=5;
            break;
        case 3:
            time=10;
            break;
        case 4:
            time=15;
            break;
        case 5:
            time=30;
            break;
        case 6:
            time=60;
            break;
        case 7:
            time=120;
            break;
        default:
            NSLog(@"ERROR in alert");
            break;
    }
    [model.data setValue:[NSNumber numberWithInt:time] forKey:@"Alert Number"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.alertPickerItems = @[@"No alert", @"At the time of event", @"5 minutes before", @"10 minutes before", @"15 minutes before", @"30 minutes before", @"1 hour before", @"2 hours before"];
    [self.alertPicker selectRow:[(NSNumber*)[[WPIModel sharedDataModel].data valueForKey:@"Alert Picker Index"] integerValue] inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 8;
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.alertPickerItems objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self.alertPickerItems objectAtIndex:row];
    return label;
}


- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
