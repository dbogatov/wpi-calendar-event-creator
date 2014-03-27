//
//  WPIPageContentViewController.h
//  WPI Calendar Event Creator
//
//  Created by Dmytro Bogatov on 3/26/14.
//  Copyright (c) 2014 Dima4ka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPIPageContentViewController : UIViewController

@property (nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *imageFile;

@end
