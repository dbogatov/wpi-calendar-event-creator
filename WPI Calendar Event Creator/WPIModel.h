//
//  WPIModel.h
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WPITableViewController.h"

@interface WPIModel : NSObject

@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) WPITableViewController *mainTable;

@property (nonatomic) BOOL inFavorites;

@property (strong, nonatomic) NSMutableArray *professors;
@property (strong, nonatomic) NSMutableArray *profsByDepts;
@property (strong, nonatomic) NSMutableArray *favorites;

@property (strong, nonatomic) NSArray *buildings;
@property (strong, nonatomic) NSArray *departments;

@property (strong, nonatomic) EKEvent *event;
@property (strong, nonatomic) EKCalendar *defaultCalendar;
@property (strong, nonatomic) EKEventStore *eventStore;

+ (WPIModel *) sharedDataModel;

- (NSMutableArray *)fetchEventsForDate: (NSDate*)startDate duration:(NSInteger)duration;

-(NSString*)getTitleForPurpose:(int)purpose;
-(NSString*)getLocation;
-(id)getDateForPurpose:(int)purpose;
-(id)getAlertForPurpose:(int)purpose;
-(NSString*)getNotes;

-(void)createEvent;

-(void)addFavorite:(int)favorite;
-(void)removeFavorite:(int)favorite;

@end
