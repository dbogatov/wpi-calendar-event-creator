//
//  WPIFavProfsViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dmytro Bogatov on 3/25/14.
//  Copyright (c) 2014 Dima4ka. All rights reserved.
//

#import "WPIFavProfsViewController.h"
#import "WPIModel.h"
#import "WPIProfessorCell.h"
#import "WPIViewProfessorsCell.h"

@interface WPIFavProfsViewController ()

@end

@implementation WPIFavProfsViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WPIModel sharedDataModel].favorites count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toProfsCell"];
        return cell;
    } else {
        
        NSUInteger indexRow = indexPath.row-1;
        
        NSNumber *favorite = [[WPIModel sharedDataModel].favorites objectAtIndex:indexRow];
        NSDictionary* dict = [[WPIModel sharedDataModel].professors objectAtIndex:[favorite integerValue]];
        WPIProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"professorsCell"];
        
        cell.professorDepartment.text = [dict objectForKey:@"Department"];
        cell.professorName.text = [dict objectForKey:@"Name"];
        cell.professorOffice.text = [dict objectForKey:@"Office"];
        cell.index = (int)indexRow;
        
        NSString *imageName = [dict objectForKey:@"Photo"];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        [cell setProfPicture:[UIImage imageWithContentsOfFile:imagePath]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        NSUInteger indexRow = indexPath.row - 1;
        
        WPIModel *model = [WPIModel sharedDataModel];
        
        NSNumber *result = [[WPIModel sharedDataModel].favorites objectAtIndex:indexRow];
        
        [model.data setObject:result forKey:@"Professor's Index"];
        [model.data setObject:[NSNumber numberWithBool:NO] forKey:@"Use Custom Professor"];
        
        NSDictionary *prof = (NSDictionary*)[model.professors objectAtIndex:[(NSNumber*)[model.data valueForKey:@"Professor's Index"] integerValue]];
        [model.data setObject:(NSString*)[prof valueForKey:@"Office"] forKey:@"Custom Building"];
        [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Custom Building"];
        [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Professors Office"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 0) ? 54 : 90;
}

@end
