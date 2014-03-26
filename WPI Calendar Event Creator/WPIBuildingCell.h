//
//  WPIBuildingCell.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPIBuildingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buildingName;
@property (weak, nonatomic) IBOutlet UILabel *buildingShortName;
@property (weak, nonatomic) IBOutlet UIImageView *buildingPhoto;

@end
