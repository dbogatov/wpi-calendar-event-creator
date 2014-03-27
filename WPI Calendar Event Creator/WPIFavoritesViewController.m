//
//  WPIFavoritesControllerViewController.m
//  WPI Calendar Event Creator
//
//  Created by Dmytro Bogatov on 3/20/14.
//  Copyright (c) 2014 Dima4ka. All rights reserved.
//

#import "WPIFavoritesViewController.h"
#import "WPIModel.h"
#import "WPIProfessorCell.h"

@interface WPIFavoritesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation WPIFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WPIModel sharedDataModel].favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *favorite = [[WPIModel sharedDataModel].favorites objectAtIndex:indexPath.row];
    NSDictionary* dict = [[WPIModel sharedDataModel].professors objectAtIndex:[favorite integerValue]];
    WPIProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"professorsCell"];
        
    cell.professorDepartment.text = [dict objectForKey:@"Department"];
    cell.professorName.text = [dict objectForKey:@"Name"];
    cell.professorOffice.text = [dict objectForKey:@"Office"];
    cell.index = (int)indexPath.row;
        
    NSString *imageName = [dict objectForKey:@"Photo"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    [cell setProfPicture:[UIImage imageWithContentsOfFile:imagePath]];


    return cell;
    
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"Number of rows before deletion: %lu", (unsigned long)[[WPIModel sharedDataModel].favorites count]);
    [[WPIModel sharedDataModel] removeFavorite:(int)indexPath.row];
    NSLog(@"Number of rows after deletion: %lu", (unsigned long)[[WPIModel sharedDataModel].favorites count]);
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    }
}
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [WPIModel sharedDataModel].inFavorites = NO;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
