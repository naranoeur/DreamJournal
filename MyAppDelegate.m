//
//  MyAppDelegate.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 9/8/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyAppDelegate.h"

@implementation MyAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeWillChange)
                                                 name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                               object:self.managedObjectContext.persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storesDidChange:)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:self.managedObjectContext.persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeContent:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:self.managedObjectContext.persistentStoreCoordinator];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey:@"DreamJournalCloud"};
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (!store) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"fuck");
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - StoreKit Observer

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                
                NSLog(@"transaction purcahsed");
                // user has purchased
                [self saveTransactionReceipt:transaction];
                [self unlockFullVersion];
                
                // download content here if necessary
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"back to game" object:nil];
                
                // let App Store know we're done
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStateFailed: {
                // transaction didn't work
                //exited the app store
                NSLog(@"transaction failed");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"failed" object:nil];
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStateRestored: {
                // purchase has been restored
                NSLog(@"transaction restored");
                [self unlockFullVersion];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"back to game" object:nil];
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
                
                
            case SKPaymentTransactionStatePurchasing: {
                // currently purchasing
                //good point to call my controllers and tell them to disable user interactions
                NSLog(@"transaction purchasing");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"purchasing" object:nil];
                break;
            }
                
            case SKPaymentTransactionStateDeferred: {
                NSLog(@"transaction deferred");
                break;
            }
                
            default:
                break;
        }
    }
}


- (void)saveTransactionReceipt:(SKPaymentTransaction *)transaction {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *receiptID = transaction.transactionIdentifier;
    NSArray *storedReceipts = [defaults arrayForKey:@"receipts"];
    
    if (!storedReceipts) {
        // store the first receipt
        [defaults setObject:@[receiptID] forKey:@"receipts"];
    } else {
        // add a receipt to the array
        NSArray *updatedReceipts = [storedReceipts arrayByAddingObject:receiptID];
        [defaults setObject:updatedReceipts forKey:@"receipts"];
    }
    
    [defaults synchronize];
}

- (void)unlockFullVersion {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"adsFree"];
    [defaults synchronize];
}

#pragma mark - iCloud Methods

//method will be called multiple times
- (void)storeWillChange
{
    NSLog(@"\n store will change \n");
    //disable UI
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //save and reset our context
    MyAppDelegate *delegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.managedObjectContext.hasChanges){
        [delegate.managedObjectContext save:nil];
    } else {
        [delegate.managedObjectContext reset];
    }
}

- (void)storesDidChange:(NSNotification *)notification
{
    NSLog(@"\n stores did change \n");
    
    // why did my stores change?
    NSNumber *transitionType = [notification.userInfo objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    int theReason = [transitionType intValue];
    
    switch (theReason) {
        case NSPersistentStoreUbiquitousTransitionTypeAccountAdded: {
            
            // an iCloud account was added
            NSLog(@"iCloud account was added");
        }
            break;
        case NSPersistentStoreUbiquitousTransitionTypeAccountRemoved: {
            
            // an iCloud account was removed
            NSLog(@"iCloud account was removed");
        }
        case NSPersistentStoreUbiquitousTransitionTypeContentRemoved: {
            
            // content was removed
            NSLog(@"content was removed");
        }
        case NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted: {
            
            // initial import completed
            NSLog(@"initial import completed");
        }
            
        default:
            break;
    }
    
    //enable UI
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    //update UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"iCloud update" object:nil];

}

- (void)mergeContent:(NSNotification *)notification
{
    NSLog(@"merge content here");
    MyAppDelegate *delegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}


@end
