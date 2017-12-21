//
//  SharedFunctionalities.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/11/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "SharedFunctionalities.h"

@implementation SharedFunctionalities

#pragma mark - Core Date Functions

#pragma mark - Calendar Related Functions

+ (NSString *)monthStringForInt: (NSInteger)monthInt entireWord:(BOOL)boolean
{
    NSString *monthString = @"";
    if(boolean){
        if(monthInt == 1) monthString = @"January";
        else if(monthInt == 2) monthString = @"February";
        else if(monthInt == 3) monthString = @"March";
        else if(monthInt == 4) monthString = @"April";
        else if(monthInt == 5) monthString = @"May";
        else if(monthInt == 6) monthString = @"June";
        else if(monthInt == 7) monthString = @"July";
        else if(monthInt == 8) monthString = @"August";
        else if(monthInt == 9) monthString = @"September";
        else if(monthInt == 10) monthString = @"October";
        else if(monthInt == 11) monthString = @"November";
        else if(monthInt == 12) monthString = @"December";
    } else
    {
        if(monthInt == 1) monthString = @"Jan";
        else if(monthInt == 2) monthString = @"Feb";
        else if(monthInt == 3) monthString = @"Mar";
        else if(monthInt == 4) monthString = @"Apr";
        else if(monthInt == 5) monthString = @"May";
        else if(monthInt == 6) monthString = @"Jun";
        else if(monthInt == 7) monthString = @"Jul";
        else if(monthInt == 8) monthString = @"Aug";
        else if(monthInt == 9) monthString = @"Sep";
        else if(monthInt == 10) monthString = @"Oct";
        else if(monthInt == 11) monthString = @"Nov";
        else if(monthInt == 12) monthString = @"Dec";
    }
    
    return  monthString;
}

+ (NSDateComponents *)dateToComponents:(NSDate *)date
{
    NSCalendar *localCalendar = [NSCalendar currentCalendar];
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[localCalendar timeZone]];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    return components;
}

+ (NSArray *)retrieveEntriesForYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day
{
    MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day == %d) AND (month == %d) AND (year == %d)", day, month, year];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                    initWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         initWithKey:@"editDate" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                          error:&error];
    return objects;
}

+ (NSArray *)retrieveEntriesForYear:(NSInteger)year andMonth:(NSInteger)month
{
    MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(month == %d) AND (year == %d)", month, year];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    return objects;
}

+ (NSArray *)retrieveAllEntries
{
    MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    return [context executeFetchRequest:request error:&error];
}

+ (void)deleteEntry:(NSManagedObject *)object
{
    MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:object];
    NSError *error;
    [context save:&error];
}

@end
