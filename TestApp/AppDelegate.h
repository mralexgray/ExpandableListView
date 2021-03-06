//
//  AppDelegate.h
//  ExpandableCellsTestApp
//
//  Created by Anton Dukhovnikov on 18/02/12.
//  Copyright (c) 2012 Anton Dukhovnikov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <SNRHUDKit/SNRHUDKit.h>
#import <AtoZ/AtoZ.h>

#import "ExpandableListView.h"


@interface AZNodeView : NSObject <ExpandableListDataSource>
+ (instancetype) nodeViewInView:(NSV*)host withFrame:(NSRect)frame usingNode:(AZNode*)node;
@property (strong, nonatomic) AZNode *node;
@property (strong, nonatomic) ExpandableListView *view;
@end

//@class ExpandableTableView;

@interface AppDelegate : NSObject <NSApplicationDelegate, ExpandableListDataSource>

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet NSView *cell1;
@property (nonatomic, strong) IBOutlet NSView *cell2;
@property (nonatomic, strong) IBOutlet NSView *cell3;
@property (nonatomic, strong) IBOutlet ExpandableListView *listView;
@property (nonatomic, strong) IBOutlet ExpandableListView *listView2;

@property (strong) DefinitionController *d;
@property (strong) AZNodeView *nv;
@end
