//
//  WPIBuildingViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIBuildingViewController.h"
#import "WPIModel.h"
#import "WPIBuildingCell.h"

@interface WPIBuildingViewController ()

@property (nonatomic) BOOL useProfessorsOffice;

@end

@implementation WPIBuildingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.useProfessorsOffice = (![(NSNumber*)[[WPIModel sharedDataModel].data valueForKey:@"Use Custom Professor"] boolValue] && [[[WPIModel sharedDataModel].data valueForKey:@"Type"] integerValue] == 0);
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

#pragma mark UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.useProfessorsOffice ? [WPIModel sharedDataModel].buildings.count+1 : [WPIModel sharedDataModel].buildings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    long row = indexPath.row;
    
    if (indexPath.row == 0 && self.useProfessorsOffice) {
        return [tableView dequeueReusableCellWithIdentifier:@"useProfessorOfficeCell"];
    } else {
        
        if (self.useProfessorsOffice) {
            row--;
        }
        
        WPIBuildingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buildingCell"];
        
        WPIModel *model = [WPIModel sharedDataModel];
        NSArray *buildings = model.buildings;
        
        cell.buildingName.text = [[buildings objectAtIndex:row] objectForKey:@"Name"];
        cell.buildingShortName.text = [[buildings objectAtIndex:row] objectForKey:@"Short Name"];
        
        NSString *imageName = [[buildings objectAtIndex:row] objectForKey:@"Photo"];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        [cell.buildingPhoto setImage:[UIImage imageWithContentsOfFile:imagePath]];
        
        return cell;
    }
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WPIModel *model = [WPIModel sharedDataModel];
    if (indexPath.row == 0 && self.useProfessorsOffice) {
        
        
        NSDictionary *prof = (NSDictionary*)[model.professors objectAtIndex:[(NSNumber*)[model.data valueForKey:@"Professor's Index"] integerValue]];
        
        
        [model.data setObject:(NSString*)[prof valueForKey:@"Office"] forKey:@"Custom Building"];
        [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Custom Building"];
        [model.data setObject:[NSNumber numberWithBool:YES] forKey:@"Use Professors Office"];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [model.data setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"Building's Index"];
        [model.data setObject:[NSNumber numberWithBool:NO] forKey:@"Use Custom Building"];
        //NSLog(@"Here");
    }
}


@end
