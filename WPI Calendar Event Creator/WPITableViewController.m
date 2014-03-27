//
//  WPITableViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/30/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPITableViewController.h"
#import "WPISegmentedCell.h"
#import "WPIModel.h"

@interface WPITableViewController ()
    
@property (weak, nonatomic) IBOutlet UILabel *dateCellDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsCellMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsCellSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingCellSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertCellSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesCellSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCellConflictLabel;
- (IBAction)favoritesButtonPressed:(id)sender;

@end

@implementation WPITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([WPIModel sharedDataModel].firstLaunch) {
        [self performSegueWithIdentifier:@"setToTut" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    WPIModel *model = [WPIModel sharedDataModel];
    
    [model setMainTable:self];
    
    [self configureView];
    
    model.inFavorites = NO;
}

-(void)configureView {
    WPIModel *model = [WPIModel sharedDataModel];
    
    self.dateCellDetailsLabel.text = [model getDateForPurpose:0];
    self.dateCellConflictLabel.text = [model.data valueForKey:@"Conflict"];
    [self configureDetailsCell];
    self.buildingCellSubtitleLabel.text = [model getLocation];
    self.alertCellSubtitleLabel.text = [model getAlertForPurpose:0];//[model.data valueForKey:@"Alert Time"];
    self.notesCellSubtitleLabel.text = [model getNotes];//[model.data valueForKey:@"Notes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[cell reuseIdentifier]  isEqual: @"WPIDetailsCell"]) {
        
        NSString *segueIdentifier;
        switch ([(NSNumber*)[[WPIModel sharedDataModel].data valueForKey:@"Type"] integerValue]) {
            case 0:
                segueIdentifier = [NSString stringWithFormat:@"TypeToProfessorSegue"]; //TypeToProfessorSegue // TypeToProfDeptSegue
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
    } else if ([[cell reuseIdentifier]  isEqual: @"WPIConfirmCell"]) {
        [[WPIModel sharedDataModel] createEvent];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    WPIModel *model = [WPIModel sharedDataModel];
    [model.data setValue:[NSNumber numberWithLong:sender.selectedSegmentIndex] forKey:@"Type"];
    [self configureDetailsCell];
}

-(void)configureDetailsCell {
    WPIModel *model = [WPIModel sharedDataModel];
    
    switch ([(NSNumber*)[model.data valueForKey:@"Type"] integerValue]) {
        case 0:
            self.detailsCellMainLabel.text = @"Professor...";
            break;
        case 1:
            self.detailsCellMainLabel.text = @"Friend or Organization...";
            break;
        case 2:
            self.detailsCellMainLabel.text = @"Custom...";
            break;
        default:
            break;
    }
    self.detailsCellSubtitleLabel.text = [model getTitleForPurpose:0];
}

-(void)sendEmail:(MFMailComposeViewController *)mailViewController {
    [self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)favoritesButtonPressed:(id)sender {
    [WPIModel sharedDataModel].inFavorites = YES;
    [self performSegueWithIdentifier:@"setToFav" sender:self];
}
@end
