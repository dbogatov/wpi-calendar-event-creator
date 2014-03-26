//
//  WPIProfessorViewController.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPIProfessorViewController : UITableViewController

@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL initTime;
@property (strong, nonatomic) NSMutableArray *iProfessors;
@property (strong, nonatomic) NSMutableArray *fProfessors;
@property (nonatomic) int departmentIndex;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL loading;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
