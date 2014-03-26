//
//  WPITableViewController.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/30/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPISegmentedCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WPITableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet WPISegmentedCell *segmentedCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *detailsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *buildingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *alertCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender;
- (void)configureView;
- (void)sendEmail:(MFMailComposeViewController *)mailViewController;

@end
