//
//  MyEntriesDisplayController.m
//  Dream Journal 2
//
//  Created by Gulnara Fayzulina on 10/9/14.
//  Copyright (c) 2014 Nara. All rights reserved.
//

#import "MyEntriesDisplayController.h"

@interface MyEntriesDisplayController ()

@end

@implementation MyEntriesDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maxDisplayHeight = 200;
    self.entryMargins = 15;
    self.entryHeight = 0;
    self.view.backgroundColor = [UIColor clearColor];
    self.currentOptionsView = nil;
    self.optionsImageWidth = 20;
    self.moreOptionsImage = [UIImage imageNamed:@"moreOptions.png"];
    
    float scale = self.optionsImageWidth / self.moreOptionsImage.size.width;
    CGRect frame = CGRectMake(scale * self.moreOptionsImage.size.width / 4.0, scale * self.moreOptionsImage.size.height / 4.0, scale * self.moreOptionsImage.size.width, scale * self.moreOptionsImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2 * frame.size.width, 2 * frame.size.height), NO, 0.0);
    [self.moreOptionsImage drawInRect:frame];
    self.moreOptionsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (NSMutableArray *)displayedEntriesArray
{
    if(!_displayedEntriesArray){
        _displayedEntriesArray = [[NSMutableArray alloc] init];
    }
    return _displayedEntriesArray;
}


//looks like to update I just remove old entry and create new one in place,
// then I see the height change between old entry and new entry and move
//all other entries accordingly
- (void)updateEntry:(NSInteger)index
{
    MyEntryDisplayView *entryDisplay = [self.displayedEntriesArray objectAtIndex:index];
    float originY = entryDisplay.frame.origin.y;
    float initialHeight = entryDisplay.frame.size.height;
    NSManagedObject *object = entryDisplay.contextObject;
    
    NSString *title = [object valueForKey:@"title"];
    NSString *content = [object valueForKey:@"content"];
    NSArray *date =[[NSArray alloc] initWithObjects:[object valueForKey:@"year"], [object valueForKey:@"month"], [object valueForKey:@"day"], nil];
    
    [entryDisplay removeFromSuperview];
    
    CGRect frame = CGRectMake(self.entryMargins, originY, self.view.frame.size.width - 2 * self.entryMargins, self.maxDisplayHeight);
    entryDisplay = [[MyEntryDisplayView alloc] initWithFrame:frame Title:title Content:content andDate:date andManagedObject: object];
    [self.view addSubview:entryDisplay];
    
    [self.displayedEntriesArray replaceObjectAtIndex:index withObject:entryDisplay];
    
    if(entryDisplay.textWithMarginsHeight > self.maxDisplayHeight){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(expandView:)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"expand"];
        NSLog(@"image %@", image);
        NSLog(@"image size = (%f,%f)", image.size.width, image.size.height);
        button.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
        button.frame = CGRectMake(entryDisplay.frame.size.width - image.size.width - entryDisplay.margins / 2.0, entryDisplay.frame.size.height - image.size.height - entryDisplay.margins / 2.0, image.size.width, image.size.height);
        [entryDisplay addSubview:button];
    }
    
    //edit button initing
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(showMoreOptions:)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [[UIColor alloc] initWithPatternImage:self.moreOptionsImage];
    button.frame = CGRectMake(entryDisplay.frame.size.width - self.moreOptionsImage.size.width,  entryDisplay.margins, self.moreOptionsImage.size.width, self.moreOptionsImage.size.height);
    [entryDisplay addSubview:button];
    
    //other book keeping
    float difference = entryDisplay.frame.size.height - initialHeight;
    NSInteger displayArrayCount = [self.displayedEntriesArray count];
    
    for(int i = ((int)index + 1); i < displayArrayCount; i ++){
        MyEntryDisplayView *displayToMove = [self.displayedEntriesArray objectAtIndex: i];
        displayToMove.center = CGPointMake(displayToMove.center.x, displayToMove.center.y + difference);
    }
    self.entryHeight = self.entryHeight + difference;
    [self.delegate heightChangedTo:self.entryHeight];
    CGRect newFrame = self.view.frame;
    newFrame.size.height = self.entryHeight;
    self.view.frame = newFrame;
}

- (void)showAllEntries
{
    
    NSArray *objects = [SharedFunctionalities retrieveAllEntries];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (int i = 0; i < [objects count]; i++)
        {
            [self displayViewWithManagedObject:objects[i]];
        }
    }
}

- (void)showEntries:(NSArray *)entries atHeight:(float)originY
{
    self.entryHeight = 0;
    self.view.frame = CGRectMake(0, originY, self.view.frame.size.width, 10);
    
    for (int i = 0; i < [entries count]; i++)
    {
        [self displayViewWithManagedObject:entries[i]];
    }
}

//note that the date is an array of NSNumbers
- (void)displayViewWithManagedObject:(NSManagedObject *)object
{
    NSString *title = [object valueForKey:@"title"];
    NSString *content = [object valueForKey:@"content"];
    NSArray *date =[[NSArray alloc] initWithObjects:[object valueForKey:@"year"], [object valueForKey:@"month"], [object valueForKey:@"day"], nil];
    
    CGRect frame = CGRectMake(self.entryMargins, self.entryHeight, self.view.frame.size.width - 2 * self.entryMargins, self.maxDisplayHeight);
    MyEntryDisplayView *display = [[MyEntryDisplayView alloc] initWithFrame:frame Title:title Content:content andDate:date andManagedObject: object];
    [self.view addSubview:display];
    self.entryHeight += display.frame.size.height + self.entryMargins;
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height = self.entryHeight;
    self.view.frame = newFrame;
    
    [self.delegate heightChangedTo:self.entryHeight];
    [self.displayedEntriesArray addObject: display];
    
    //expand button initing if the entry is too large
    if(display.textWithMarginsHeight > self.maxDisplayHeight){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(expandView:)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"expand"];
        button.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
        button.frame = CGRectMake(display.frame.size.width - image.size.width - display.margins / 2.0, display.frame.size.height - image.size.height - display.margins / 2.0, image.size.width, image.size.height);
        [display addSubview:button];
    }
    
    //button asking for more options
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(showMoreOptions:)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [[UIColor alloc] initWithPatternImage:self.moreOptionsImage];
    button.frame = CGRectMake(display.frame.size.width - self.moreOptionsImage.size.width,  display.margins, self.moreOptionsImage.size.width, self.moreOptionsImage.size.height);
    [display addSubview:button];
    
    //delete button initing
/*    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteButton addTarget:self
                     action:@selector(delete:)
           forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor yellowColor];
    deleteButton.frame = CGRectMake(0, 0, 50, 30);
    [display addSubview:deleteButton];*/
}

- (void)clearDisplayedEntries
{
    for(MyEntryDisplayView *display in self.displayedEntriesArray){
        [display removeFromSuperview];
    }
    if(self.currentOptionsView){
        [self.currentOptionsView removeFromSuperview];
        self.currentOptionsView = nil;
    }
    self.displayedEntriesArray = nil;
    [self.delegate heightChangedTo: 0];
    self.entryHeight = 0;
}

- (void)sendRequest:(requestMessage *)request
{
    if(request.requestReturning){
        //the request that was sent of by this instance has arrived back
        //the object must read and execute the request
        [request.addressOfSender removeObjectAtIndex:0];
        if([request.addressOfSender count] == 0){
            if(request.shouldDelete){
                //should delete an object
                [self deleteEntry:request.entryIndex];
            } else if (request.shouldEdit) {
                //should edit an entry
                [self updateEntry:request.entryIndex];
            }
        }
        
    }
}

- (void)deleteEntry:(NSInteger)entry
{
    MyEntryDisplayView *display = [self.displayedEntriesArray objectAtIndex:entry];
    [SharedFunctionalities deleteEntry:display.contextObject];
    
    float translationDistance = display.frame.size.height + self.entryMargins;
    [display removeFromSuperview];
    [self.displayedEntriesArray removeObjectAtIndex:entry];
    NSInteger arrayCount = [self.displayedEntriesArray count];
    for(int i = (int)entry; i < arrayCount; i ++){
        MyEntryDisplayView *displayToMove = [self.displayedEntriesArray objectAtIndex: i];
        displayToMove.center = CGPointMake(displayToMove.center.x, displayToMove.center.y - translationDistance);
    }
    self.entryHeight -= translationDistance;
    [self.delegate heightChangedTo:self.entryHeight];
}

#pragma mark - User Interactions

//when user interacts and requests to delete or edit an entry
//there should be a request created that is passed onto its delegate

- (void)showMoreOptions:(UIButton *)sender
{
    if(!self.currentOptionsView){
        NSLog(@"user asked for more options");
        MyEntryDisplayView *display = (MyEntryDisplayView *) sender.superview;
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        CGPoint arrowPoint = CGPointMake(display.frame.origin.x + display.frame.size.width - self.moreOptionsImage.size.width / 2.0, display.frame.origin.y + self.moreOptionsImage.size.height);
        self.currentOptionsView = [[EntryOptionsView alloc] initWithFrame:frame andEntryView:display withArrowPoint:arrowPoint];
        self.currentOptionsView.delegate = self;
        [self.view addSubview:self.currentOptionsView];
        [self.view bringSubviewToFront:self.currentOptionsView];

    }
}

- (void)removeOptionScreen
{
    NSLog(@"remove options screen");
    if(self.currentOptionsView){
        [self.currentOptionsView removeFromSuperview];
        self.currentOptionsView = nil;
    }
}

- (void)editEntry:(MyEntryDisplayView *)entryDisplay
{
    requestMessage *request = [[requestMessage alloc] init];
    request.shouldEdit = YES;
    request.entryIndex = [self.displayedEntriesArray indexOfObject:entryDisplay];
    request.entryManagedObject = entryDisplay.contextObject;
    request.addressOfSender = [[NSMutableArray alloc] initWithObjects:self, nil];
    request.destinationIsRoot = YES;
    [self.delegate sendRequest:request];
    [self.currentOptionsView removeFromSuperview];
    self.currentOptionsView = nil;
}

- (void)beginDeletingEntry:(MyEntryDisplayView *)entryDisplay
{
    requestMessage *request = [[requestMessage alloc] init];
    request.shouldDelete = YES;
    request.entryIndex = [self.displayedEntriesArray indexOfObject:entryDisplay];
    request.destinationIsRoot = YES;
    request.addressOfSender = [[NSMutableArray alloc] initWithObjects:self, nil];
    [self.delegate sendRequest:request];
    [self.currentOptionsView removeFromSuperview];
    self.currentOptionsView = nil;
}

- (void)expandView:(UIButton *)expandButton
{
    NSInteger indexOfDisplay = [self.displayedEntriesArray indexOfObject: expandButton.superview];
    MyEntryDisplayView *displayView = [self.displayedEntriesArray objectAtIndex:indexOfDisplay];
    NSInteger displayArrayCount = [self.displayedEntriesArray count];
    NSInteger translationDistance = displayView.textWithMarginsHeight - self.maxDisplayHeight;
    
    if(displayView.viewIsExpanded){
        [displayView contractView];
        for(int i = ((int)indexOfDisplay + 1); i < displayArrayCount; i ++){
            MyEntryDisplayView *displayToMove = [self.displayedEntriesArray objectAtIndex: i];
            displayToMove.center = CGPointMake(displayToMove.center.x, displayToMove.center.y - translationDistance);
        }
        expandButton.center = CGPointMake(expandButton.center.x, expandButton.center.y - translationDistance);
        self.entryHeight -= translationDistance;
        [self.delegate heightChangedTo:self.entryHeight];
        CGRect newFrame = self.view.frame;
        newFrame.size.height = self.entryHeight;
        self.view.frame = newFrame;
    } else {
        [displayView expandView];
        for(int i = ((int)indexOfDisplay + 1); i < displayArrayCount; i ++){
            MyEntryDisplayView *displayToMove = [self.displayedEntriesArray objectAtIndex: i];
            displayToMove.center = CGPointMake(displayToMove.center.x, displayToMove.center.y + translationDistance);
        }
        expandButton.center = CGPointMake(expandButton.center.x, expandButton.center.y + translationDistance);
        self.entryHeight += translationDistance;
        [self.delegate heightChangedTo:self.entryHeight];
        CGRect newFrame = self.view.frame;
        newFrame.size.height = self.entryHeight;
        self.view.frame = newFrame;
    }
}

@end
