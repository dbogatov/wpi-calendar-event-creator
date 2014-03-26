//
//  NSString+Screening.m
//  WPI Calendar Event Creator
//
//  Created by Dima4ka on 12/10/13.
//  Copyright (c) 2013 Dima4ka. All rights reserved.
//

#import "NSString+Screening.h"

@implementation NSString (Screening)
-(NSString*)screen {
    return [[[self stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"] stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"] stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
}
@end
