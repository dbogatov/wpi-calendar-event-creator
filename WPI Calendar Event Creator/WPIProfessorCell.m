//
//  WPIProfessorCell.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIProfessorCell.h"

@implementation WPIProfessorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setProfPicture:(UIImage *)professorPicture {
    /*
    UIImageView *imageView = self.professorPicture;
    
    float widthRatio = imageView.bounds.size.width / professorPicture.size.width;
    float heightRatio = imageView.bounds.size.height / professorPicture.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageWidth = scale * professorPicture.size.width;
    float imageHeight = scale * professorPicture.size.height;
    
    imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    imageView.center = imageView.superview.center;
    */
    [self.professorPicture setImage:professorPicture];
}
    
@end
