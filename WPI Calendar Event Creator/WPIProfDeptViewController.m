//
//  WPIProfDeptViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dmytro Bogatov on 1/29/14.
//  Copyright (c) 2014 Dima4ka. All rights reserved.
//

#import "WPIProfDeptViewController.h"
#import "WPIModel.h"
#import "WPIProfessorCell.h"

@interface WPIProfDeptViewController ()
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation WPIProfDeptViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary* dict = [((NSMutableArray *)[[WPIModel sharedDataModel].profsByDepts objectAtIndex:self.departmentIndex]) firstObject];
    
    
    self.navigationItem.title = [dict valueForKey:@"Department"];
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
    return ((NSMutableArray *)[[WPIModel sharedDataModel].profsByDepts objectAtIndex:self.departmentIndex]).count;
}


#pragma mark - UITableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    unsigned long result;
    
    WPIProfessorCell *cell = (WPIProfessorCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    result =  cell.index; //[self.iProfessors indexOfObject:[self.fProfessors objectAtIndex:indexPath.row]];
    
    
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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [((NSMutableArray *)[[WPIModel sharedDataModel].profsByDepts objectAtIndex:self.departmentIndex]) objectAtIndex:indexPath.row];
    WPIProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"professorsCell"];
    
    cell.professorDepartment.text = [dict objectForKey:@"Department"];
    cell.professorName.text = [dict objectForKey:@"Name"];
    cell.professorOffice.text = [dict objectForKey:@"Office"];
    cell.index = [(NSNumber *)[dict valueForKey:@"ID"] intValue];
    
    NSString *imageName = [dict objectForKey:@"Photo"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    [cell.professorPicture setImage:[UIImage imageWithContentsOfFile:imagePath]];
    
    return cell;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
