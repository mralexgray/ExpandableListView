//
//  ExpandableTableView.h
//  ExpandableCellsTestApp
//
//  Created by Anton Dukhovnikov on 18/02/12.
//  Copyright (c) 2012 Anton Dukhovnikov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

@class ExpandableListView;
// @brief Data source for expandable list view. Data source should implement three mandatory methods returning number of views, view for given index, title of view at given index.
@protocol ExpandableListDataSource <NSObject>
/* Method returning number of views to show in expandable list.
	@param listView list view requesting information
	@return number of views */
-  (NSI) numberOfViewsInExpandableList:(ExpandableListView*)lv;
/* Method returning title of view to show in expandable list an given index.
	@param listView list view requesting information
	@param index index of requested view */
- (NSS*) expandableList:(ExpandableListView*)lv titleAtIndex:(NSI)idx;
/* Method returning view to show in expandable list an given index.
	@param listView list view requesting information
	@param index index of requested view */
- (NSV*) expandableList:(ExpandableListView*)lv viewAtIndex:(NSI)idx;
- (BOOL) expandableList:(ExpandableListView*)lv shouldExpandViewAtIndex:(NSI)idx;
@end

// @brief ExpandableListView is a visual component displaying list of views which can be expanded/collapsed by user clicking on view's header. Example of such behavior is the Inspector in XCode.
@interface ExpandableListView : NSView
//+ (instancetype) expandableViewInView:(NSV*)v withNode:(AZNode*)node;
@property (weak) AZNode *node;

// Data source for expandable list. This property is declared as IBOutlet so it can be set in Interface Builder.
@property (nonatomic, unsafe_unretained) IBOutlet id <ExpandableListDataSource> dataSource;
// Method to refresh list content if some data in data source was changed.
- (void)reloadData;
@end
