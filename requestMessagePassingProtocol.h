//
//  requestMessagePassingProtocol.h
//  DreamJournal
//
//  Created by Gulnara Fayzulina on 12/7/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "requestMessage.h"

@protocol requestMessagePassing <NSObject>

- (void)sendRequest:(requestMessage *)request;

@end

@interface requestMessagePassingProtocol : NSObject

@end
