//
//  requestMessage.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 12/6/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//
/*
 
 The child controller displaying entries creates a request message when it needs to
 communicate with the root view controller.
 
 It passes the message to the parents, and in turn parent passes it up the chain until it reaches to root.
 Once it reaches the root, the root reads the message and acts accordingly. 
 Once the root finishes the request, it passes the requestMessage back to the
 child controller displaying entries notifying it if the child needs to execute any 
 other actions
 
 As it passes through the chain, each view controller places itself as the first object of 
 addressOfSender mutable array.
 When the message is sent back to the sender, as it passes through the chain, 
 each view controller removes first object. You can see if the message arrived 
 back to its sender if the addressOfSender array has 0 objects in it. 
 
 This is basically a struct at the moment
 
 */

#import <Foundation/Foundation.h>

@interface requestMessage : NSObject

//sender properties (message to root)
@property (nonatomic) BOOL shouldDelete;
@property (nonatomic) BOOL shouldEdit;
@property (nonatomic) NSInteger entryIndex;
@property (strong, nonatomic) NSArray *date;
@property (strong, nonatomic) NSManagedObject *entryManagedObject;
@property (strong, nonatomic) NSMutableArray *addressOfSender;
@property (nonatomic) BOOL destinationIsRoot;

//properties for the response
@property (nonatomic) BOOL entryWasSaved;
@property (nonatomic) BOOL requestReturning;

@end
