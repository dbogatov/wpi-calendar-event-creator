//
//  WPILoadingCell.m
//  WPI Calendar Event Creator
//
//  Created by Dmytro Bogatov on 3/19/14.
//  Copyright (c) 2014 Dima4ka. All rights reserved.
//

#import "WPILoadingCell.h"

@implementation WPILoadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
