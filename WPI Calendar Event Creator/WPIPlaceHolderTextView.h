//
//  WPIPlaceHolderTextView.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/10/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
