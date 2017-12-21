//
//  MyEntriesDisplayController.h
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 10/9/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedFunctionalities.h"
#import "MyEntryDisplayView.h"
#import "EntryOptionsView.h"
#import "requestMessage.h"

//delegate protocol to communicate with parent
@protocol entriesChildViewControllerDelegate <NSObject>

- (void)heightChangedTo:(float)height; //to parent
- (void)sendRequest:(requestMessage *)request;

@end

@interface MyEntriesDisplayController : UIViewController <entryOptionsScreen>
{
}
@property (assign) id <entriesChildViewControllerDelegate> delegate;

@property (nonatomic) NSInteger entryHeight;
@property (nonatomic) NSInteger maxDisplayHeight;
@property (nonatomic) NSInteger entryMargins;
@property (strong, nonatomic) NSMutableArray *displayedEntriesArray;
@property (strong, nonatomic) EntryOptionsView *currentOptionsView;
@property (strong, nonatomic) UIImage *moreOptionsImage;
@property (nonatomic) float optionsImageWidth;

//iAds properties

@property (nonatomic) NSInteger iAdBannerHeight;
@property (nonatomic) NSInteger removeAdButtonHeight;
@property (nonatomic) NSInteger modFrequency; //how often to show ads

//methods

- (void)showAllEntries;
- (void)clearDisplayedEntries;
- (void)showEntries:(NSArray *)entries atHeight:(float)originY;
- (void)displayViewWithManagedObject:(NSManagedObject *)object;
- (void)updateEntry:(NSInteger)index;
- (void)deleteEntry:(NSInteger)entry;

//delegate methods

- (void)beginDeletingEntry:(MyEntryDisplayView *)entryDisplay;
- (void)editEntry:(MyEntryDisplayView *)entryDisplay;
- (void)removeOptionScreen;

@end
