//
//  SharedFunctionalities.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/11/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAppDelegate.h"


@interface SharedFunctionalities : NSObject

+ (NSString *)monthStringForInt: (NSInteger)monthInt entireWord:(BOOL)boolean;
+ (NSDateComponents *)dateToComponents:(NSDate *)date;

+ (NSArray *)retrieveEntriesForYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day;
+ (NSArray *)retrieveEntriesForYear:(NSInteger)year andMonth:(NSInteger)month;
+ (NSArray *)retrieveAllEntries;
+ (void)deleteEntry:(NSManagedObject *)object;

@end
