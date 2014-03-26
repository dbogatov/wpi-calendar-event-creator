//
//  WPIProfessorCell.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPIProfessorCell : UITableViewCell

@property (nonatomic) int index;
@property (weak, nonatomic) IBOutlet UIImageView *professorPicture;
@property (weak, nonatomic) IBOutlet UILabel *professorDepartment;
@property (weak, nonatomic) IBOutlet UILabel *professorName;
@property (weak, nonatomic) IBOutlet UILabel *professorOffice;

-(void)setProfPicture:(UIImage *)professorPicture;

@end
