//
//  WPIModel.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 11/27/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "WPIModel.h"

@implementation WPIModel

static WPIModel *sharedDataModel = nil;

+ (WPIModel *) sharedDataModel
{
    @synchronized(self)
    {
        if (sharedDataModel == nil)
        {
            sharedDataModel = [[WPIModel alloc] init];
        }
    }
    return sharedDataModel;
}

-(id)init {
    if (self = [super init]) {
        NSLog(@"Model - init");
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"professors" ofType:@"plist"];
        NSMutableArray *tmp_data = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        self.professors = tmp_data;
        
        for (int i=0; i<self.professors.count; i++) {
            [[self.professors objectAtIndex:i] setValue:[NSNumber numberWithInt:i] forKey:@"ID"];
        }
        
        //NSLog(@"Key - %@", [[self.professors objectAtIndex:4] valueForKey:@"ID"]);
        
        [self sortByDepartments];
        
        filePath = [[NSBundle mainBundle] pathForResource:@"departments" ofType:@"plist"];
        tmp_data = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        self.departments = tmp_data;
        
        filePath = [[NSBundle mainBundle] pathForResource:@"tutorial" ofType:@"plist"];
        NSArray *tmp_data_static = [[NSArray alloc] initWithContentsOfFile:filePath];
        self.tutorials = tmp_data_static;
        
        NSLog(@"T[0]: %@", NSStringFromClass([self.tutorials[0] class]));
        
        filePath = [[NSBundle mainBundle] pathForResource:@"buildings" ofType:@"plist"];
        tmp_data = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        self.buildings = tmp_data;

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *favoritesPath = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
        tmp_data = [[NSMutableArray alloc] initWithContentsOfFile:favoritesPath];
        self.favorites = tmp_data;
        
        [self configureData];
        
        self.eventStore = [[EKEventStore alloc] init];
        
        [self checkEventStoreAccessForCalendar];
    }
    
    return self;
}

-(void)sortByDepartments {
    self.profsByDepts = nil;
    self.profsByDepts = [[NSMutableArray alloc] init];
    BOOL deptFound;
    
    for (NSDictionary *professor in self.professors) {
        deptFound = NO;
        if (!self.profsByDepts) {
            [self.profsByDepts addObject:[NSMutableArray arrayWithObject:professor]];
        } else {
            for (NSMutableArray *tempArray in self.profsByDepts) {
                if ([[tempArray firstObject] valueForKey:@"Department"] == [professor valueForKey:@"Department"]) {
                    [tempArray addObject:professor];
                    deptFound = YES;
                    break;
                }
            }
            if (!deptFound) {
                [self.profsByDepts addObject:[NSMutableArray arrayWithObject:professor]];
            }
        }
    }

    /*
     for (NSMutableArray *dept in self.profsByDepts) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
        [dept sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }*/
    
    self.profsByDepts = [NSMutableArray arrayWithArray:[[self.profsByDepts reverseObjectEnumerator] allObjects]];
    
}

-(void)configureData {
    self.data = nil;
    //self.mainTable = nil;
    
    self.data = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    
    NSDate *now = [NSDate date];

    self.inFavorites = NO;
    
    NSLog(@"NowDate - %@",now);
    
    [self.data setValue:now forKey:@"Date"];
    
    [self.mainTable configureView];
}

#pragma mark - Access Calendar

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    NSLog(@"Model - checkEventStoreAccessForCalendar");
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted) {
             WPIModel * __weak weakSelf = self;
             // Let's ensure that this code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar;
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with this event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
}

#pragma mark - Fetch events

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEventsForDate: (NSDate*)startDate duration:(NSInteger)duration
{
    //Create the end date components
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    endDateComponents.minute = duration;
	
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponents toDate:startDate options:0];
	// We will only search the default calendar for our events
	NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
    
    // Create the predicate
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray];
	
	// Fetch all events that match the predicate
	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
	return events;
}

-(NSString*)getTitleForPurpose:(int)purpose {
    
    switch ([(NSNumber*)[self.data valueForKey:@"Type"] integerValue]) {
        case 0:
            if ([(NSNumber*)[self.data valueForKey:@"Use Custom Professor"] boolValue]) {
                return (purpose == 0) ? [self.data valueForKey:@"Custom Professor"] :
                [NSString stringWithFormat:@"Appointment with professor %@", [self.data valueForKey:@"Custom Professor"]];
            } else {
                NSDictionary *prof = (NSDictionary*)[self.professors objectAtIndex:[(NSNumber*)[self.data valueForKey:@"Professor's Index"] integerValue]];
                return (purpose == 0) ? [prof objectForKey:@"Name"] :
                [NSString stringWithFormat:@"Appointment with professor %@", [prof objectForKey:@"Name"]];
            }
            break;
        case 1:
            return (purpose == 0) ? [self.data valueForKey:@"Details Friend"] : [NSString stringWithFormat:@"Meeting with %@", [self.data valueForKey:@"Details Friend"]];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@", [self.data valueForKey:@"Details Custom"]];
            break;
        default:
            return @"ERROR: type is not valid";
            break;
    }
}

-(NSString*)getLocation {
    NSString *building;
    NSString *place;
    
    if ([(NSNumber*)[self.data valueForKey:@"Use Professors Office"] boolValue]) {
        return [self.data valueForKey:@"Custom Building"];
    } else {
        if ([(NSNumber*)[self.data valueForKey:@"Use Custom Building"] boolValue]) {
            building = [self.data valueForKey:@"Custom Building"];
        } else {
            NSDictionary *builds = (NSDictionary*)[self.buildings objectAtIndex:[(NSNumber*)[self.data valueForKey:@"Building's Index"] integerValue]];
            building = [builds objectForKey:@"Name"];
        }
        if ([(NSNumber*)[self.data valueForKey:@"Use Specific Place"] boolValue]) {
            place = [self.data valueForKey:@"Specific Place"];
        } else {
            place = [(NSString*)[self.data valueForKey:@"Room Number"] stringByAppendingString:(NSString*)[self.data valueForKey:@"Room Letter"]];
        }
        return [NSString stringWithFormat:@"%@, %@", building, place];
    }
}
// 0 - for cell, 1 - for preview, 2 - startDate, 3 - endDate
-(id)getDateForPurpose:(int)purpose {
    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d H m" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    NSString* fromDate = [formatter stringFromDate:[self.data valueForKey:@"Date"]];
    
    NSDate *to = [NSDate dateWithTimeInterval:[(NSNumber*)[self.data valueForKey:@"Duration"] integerValue]*60 sinceDate:[self.data valueForKey:@"Date"]];
    NSString *toDate = [formatter stringFromDate:to];
    
    switch (purpose) {
        case 0:
            return [NSString stringWithFormat:@"%@ / %@ minutes", fromDate, [self.data valueForKey:@"Duration"]];
            break;
        case 1:
            return [NSString stringWithFormat:@"From: %@ <br>To: %@", fromDate, toDate];
            break;
        case 2:
            return [self.data valueForKey:@"Date"];
            break;
        case 3:
            return to;
            break;
        case 4:
            return fromDate;
            break;
        default:
            NSLog(@"ERROR in getDate");
            break;
    }
    
    return (purpose == 0) ? [NSString stringWithFormat:@"%@ / %@ minutes", fromDate, [self.data valueForKey:@"Duration"]] :
     [NSString stringWithFormat:@"From: %@ <br>To: %@", fromDate, toDate];
}

// 0 - for cell, 1 - for event
-(id)getAlertForPurpose:(int)purpose {
    if (!purpose) {
        return [self.data valueForKey:@"Alert Time"];
    } else {
        return [NSDate dateWithTimeInterval:[(NSNumber*)[self.data valueForKey:@"Alert Number"] doubleValue] sinceDate:[self.data valueForKey:@"Date"]];
    }
}

-(NSString*)getNotes {
    return ([(NSString*)[self.data valueForKey:@"Notes"] isEqualToString:@"empty"] || [(NSString*)[self.data valueForKey:@"Notes"] isEqualToString:@""]) ? @"No notes" : [self.data valueForKey:@"Notes"];
}

-(void)createEvent {
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = [self getTitleForPurpose:1];
    event.startDate = [self getDateForPurpose:2];
    event.endDate = [self getDateForPurpose:3];
    event.calendar = self.defaultCalendar;
    event.location = [self getLocation];
    event.notes = [self getNotes];
    if ([(NSNumber*)[self.data valueForKey:@"Alert Number"] doubleValue] != -1) {
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:(-1.0f)*60*[(NSNumber*)[self.data valueForKey:@"Alert Number"] doubleValue]]];
    }
    
    NSError* error;
    
    //[self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    
    
    
    UIAlertView* alert;
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Your event" message:@"There was some error adding this event... Please, report it to developer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self configureData];
    } else {
        if ([(NSNumber*)[self.data valueForKey:@"Use Custom Professor"] boolValue]) {
            alert = [[UIAlertView alloc] initWithTitle:@"Your event" message:@"Your event is successfully added to your default calendar." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [self configureData];
        } else {
            NSDictionary *prof = (NSDictionary*)[self.professors objectAtIndex:[(NSNumber*)[self.data valueForKey:@"Professor's Index"] integerValue]];
            NSString *message = [NSString stringWithFormat:@"Your event is successfully added to your default calendar. Would you like to send an email to professor %@ with a reminder? You will confirm it.", [prof objectForKey:@"Name"]];
            alert = [[UIAlertView alloc] initWithTitle:@"Your event" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
        }
    }
    [alert show];
}

-(NSString*)getICSFile {
    NSString *title = [self getTitleForPurpose:1];
    NSDate *sDate = [self getDateForPurpose:2];
    NSDate *eDate = [self getDateForPurpose:3];
    NSString *location = [self getLocation];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:sDate];
    NSString *startDate = [NSString stringWithFormat:@"%4ld%2ld%2ldT%2ld%2ld00", (long)components.year, (long)components.month , (long)components.day, (long)components.hour, (long)components.minute];
    startDate = [startDate stringByReplacingOccurrencesOfString:@" " withString:@"0"];
    components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:eDate];
    NSString *endDate = [NSString stringWithFormat:@"%4ld%2ld%2ldT%2ld%2ld00", (long)components.year, (long)components.month, (long)components.day, (long)components.hour, (long)components.minute];
    endDate = [endDate stringByReplacingOccurrencesOfString:@" " withString:@"0"];
    
    NSLog(@"Date start: %@", startDate);
    
    title = [title stringByReplacingOccurrencesOfString:@"," withString:@"\\,"];
    location = [location stringByReplacingOccurrencesOfString:@"," withString:@"\\,"];
    
    NSString *result = [NSString stringWithFormat:@"BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:WPIEventCreatorApp\nBEGIN:VEVENT\nSUMMARY:%@\nLOCATION:%@\nDTSTART;TZID=America/New_York:%@\nDTEND;TZID=America/New_York:%@\nEND:VEVENT\nEND:VCALENDAR", title, location, startDate, endDate];
    
    return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self.mainTable;
            
            NSDictionary *prof = (NSDictionary*)[self.professors objectAtIndex:[(NSNumber*)[self.data valueForKey:@"Professor's Index"] integerValue]];
            NSString *email = [prof valueForKey:@"Email"];
            
            [mailViewController setToRecipients:@[email]];
            [mailViewController setSubject:@"Appointment reminder"];
            NSString *message = [NSString stringWithFormat:@"Dear Professor %@:\n\n I am just writing you a reminder about an appointment we set on %@. \n\n Thank you!\n\n(This is an automated email from WPI Calendar Events Creator app)\n", [prof valueForKey:@"Name"], [self getDateForPurpose:4]];
            [mailViewController setMessageBody:message isHTML:NO];
            
            
            [mailViewController addAttachmentData:[[self getICSFile] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/calendar" fileName:@"AppointmentFile"];
            
            [self.mainTable sendEmail:mailViewController];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't do that :(" message:@"Device is unable to send email in its current state." delegate:self cancelButtonTitle:@"Okey" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    [self configureData];
}

-(void)addFavorite:(int)favorite {
    NSLog(@"Professor %d is added", favorite);
    
    if (![self.favorites containsObject:[NSNumber numberWithInt:favorite]]) {
        [self.favorites addObject:[NSNumber numberWithInt:favorite]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *favoritesPath = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
        
        [self.favorites writeToFile:favoritesPath atomically:YES];
    }
    
}

-(void)removeFavorite:(int)favorite {
    NSLog(@"index %d is removed", favorite);
    
    [self.favorites removeObjectAtIndex:favorite];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *favoritesPath = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
    
    [self.favorites writeToFile:favoritesPath atomically:YES];
}

@end