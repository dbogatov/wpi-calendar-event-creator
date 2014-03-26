	//
//  WPIProfessorViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIProfessorViewController.h"
#import "WPIModel.h"
#import "WPIProfDeptViewController.h"
#import "WPIProfessorCell.h"
#import "WPIDepartmentCell.h"
#import "WPILoadingCell.h"

@interface WPIProfessorViewController ()
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPIProfessorViewController

-(NSMutableArray*)iProfessors {
    if (!_iProfessors) {
        _iProfessors = [[NSMutableArray alloc] init];
    }
    return _iProfessors;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isSearching = NO;
        
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"View will appear");
    
    if ([self.iProfessors count] == 0) {
        self.loading = YES;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    if ([self.iProfessors count] == 0) {
        
        self.initTime = YES;
        NSLog(@"Loading...");
        for (int i=0; i<[WPIModel sharedDataModel].professors.count; i++) {
            [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        NSLog(@"Loading comlete.");
        self.loading = NO;
        self.initTime = NO;
        
        [self.tableView reloadData];
    }
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

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.loading) {
        return 1;
    } else if (self.isSearching) {
        return self.fProfessors.count;
    } else {
        return [WPIModel sharedDataModel].profsByDepts.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (self.loading) {
    
    //}
    
    if (self.initTime) {
        NSDictionary* dict = [[WPIModel sharedDataModel].professors objectAtIndex:indexPath.row];
        WPIProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"professorsCell"];
        
        cell.professorDepartment.text = [dict objectForKey:@"Department"];
        cell.professorName.text = [dict objectForKey:@"Name"];
        cell.professorOffice.text = [dict objectForKey:@"Office"];
        cell.index = (int)indexPath.row;
        
        NSString *imageName = [dict objectForKey:@"Photo"];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        [cell setProfPicture:[UIImage imageWithContentsOfFile:imagePath]];
        //[cell.professorPicture setImage:[UIImage imageWithContentsOfFile:imagePath]];
        
        if (![self.iProfessors containsObject:cell]) {
            //NSLog(@"Name - %@", cell.professorName.text);
            [self.iProfessors addObject:cell];
        }
        
        return cell;
    } else if (self.isSearching) {
        return [self.fProfessors objectAtIndex:indexPath.row];
    } else if (self.loading) {
        WPILoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        return cell;
    } else {
        NSMutableArray *deptArray = [[WPIModel sharedDataModel].profsByDepts objectAtIndex:indexPath.row];
        WPIDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departmentCell"];
        
        cell.mainLabel.text = [[deptArray firstObject] valueForKey:@"Department"];
        
        return cell;
    }
}


#pragma mark - UITableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.isSearching) ? 90 : 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    unsigned long result;
    
    if (self.isSearching) {
        result = [self.iProfessors indexOfObject:[self.fProfessors objectAtIndex:indexPath.row]];
        
        WPIModel *model = [WPIModel sharedDataModel];
        
        if (model.inFavorites) {
            [model addFavorite:(int)result];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
        
            [model.data setObject:[NSNumber numberWithUnsignedLong:result] forKey:@"Professor's Index"];
            [model.data setObject:[NSNumber numberWithBool:NO] forKey:@"Use Custom Professor"];
            
            NSDictionary *prof = (NSDictionary*)[model.professors objectAtIndex:[(NSNumber*)[model.data valueForKey:@"Professor's Index"] integerValue]];
            [model.data setObject:(NSString*)[prof valueForKey:@"Office"] forKey:@"Custom Building"];
            [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Custom Building"];
            [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Professors Office"];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        self.departmentIndex = (int)indexPath.row;
        [self performSegueWithIdentifier:@"ProfDeptToProfs" sender:self];
    }
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText length]) {
        self.isSearching = NO;
    } else {
        self.isSearching = YES;
        
        self.fProfessors = [[NSMutableArray alloc] init];
        
        for (WPIProfessorCell* cell in self.iProfessors) {
            NSRange cellNameRange = [cell.professorName.text rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (cellNameRange.location != NSNotFound) {
                //NSLog(@"NameSearch - %@", cell.professorName.text);
                [self.fProfessors addObject:cell];
            }
        }
    }
    
    [self.tableView reloadData];
    
}
    
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1;
{
    [self.searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ProfDeptToProfs"])
    {
        WPIProfDeptViewController *vc = [segue destinationViewController];
        [vc setDepartmentIndex:self.departmentIndex];
    }
}


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
