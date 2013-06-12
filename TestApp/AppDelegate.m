//
//  AppDelegate.m
//  ExpandableCellsTestApp
//
//  Created by Anton Dukhovnikov on 18/02/12.
//  Copyright (c) 2012 Anton Dukhovnikov. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window = _window, cell1, cell2, cell3, listView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_d = DefinitionController.new;
	_nv = [AZNodeView nodeViewInView:_window.contentView withFrame:_window.contentRect usingNode:_d.root];

		//	[listView reloadData];
		//    [_nv.view reloadData];
}


@end

@implementation AZNodeView

+ (instancetype) nodeViewInView:(NSV*)host withFrame:(NSRect)frame usingNode:(AZNode*)node;
{
	AZNodeView *nv = self.new;
	[host addSubview:nv.view = [ExpandableListView.alloc initWithFrame:frame]];
	nv.view.dataSource = nv;
	nv.view.node = node;
		//	[[node children] log];
	[nv.view reloadData];
	return nv;
}
	//- (void) setNode:(AZNode *)node { _node = node; [self setNode:node];  [_view reloadData]; }

	//- (void) setNode:(AZNode*)node forView:(ExpandableListView*)v {
	//
	//	objc_setAssociatedObject(v, (__bridge const void *)@"viewNode", node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	//}
	//- (AZNode*) nodeForView:(ExpandableListView*)v {
	//
	//	return (AZNode*)objc_getAssociatedObject(v, (__bridge const void *)@"viewNode");
	//}

- (NSInteger) numberOfViewsInExpandableList:(ExpandableListView*)v	{

	NSUInteger number = [v.node numberOfChildren];//[[self nodeForView:v]children].count;
	NSLog(@"claiming to have %ld views in view:%@ for node: %@ ", number, v, v.node);// [self nodeForView:v]);
	return number;
}

- (NSString*)expandableList:(ExpandableListView *)v titleAtIndex:(NSInteger)idx	{

	return [v.node.children[idx] key];// [self nodeForView:v].children[idx] key];

		//    switch (index){case 0:return @"First view"; case 1:return @"Second view";default: return @"Third view"; }
}

- (NSView *)expandableList:(ExpandableListView*)lv viewAtIndex:(NSInteger)idx {

		//	static NSMA* views; views = views ?: NSMA.new;

	AZNode* n = lv.node.children[idx];
	NSLog(@"NODE:%@", n);
	BLKVIEW* vvv = nil;
	vvv = objc_getAssociatedObject(n, @"valueView");
	if (!vvv) {
		NSRect rr = lv.bounds;
		rr.size.height  = 200;///= n.of.floatValue;
		NSColor *c = RANDOMCOLOR;
		vvv = [BLKVIEW viewWithFrame:rr opaque:YES drawnUsingBlock:^(BNRBlockView *v, NSRect r) {
			NSRectFillWithColor(r, c);
		}];
		objc_setAssociatedObject(n,(__bridge  const void *)@"valueView", vvv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return vvv;
}

	//	if (lv == _listView2) {
	//	switch (index) {
	//	     case 0:  return cell1;
	//        case 1:  return cell2;
	//        default: return cell3;
	//	}
	//	}
	//	else {
	//	switch (index)
	//    {
	//        case 0:  return _listView2;
	//        case 1:  return cell2;
	//        default: return cell3;
	//    }
	//	 }


@end
