	//
	//  ExpandableTableView.m
	//  ExpandableCellsTestApp
	//
	//  Created by Anton Dukhovnikov on 18/02/12.
	//  Copyright (c) 2012 Anton Dukhovnikov. All rights reserved.
	//

#define BUTTON_HEIGHT 23.0f

#import "ExpandableListView.h"
	// Internal class. Simple NSView with flipped geometry. (0,0) is top left corner.
@interface FlippedView:NSView@end@implementation FlippedView -(BOOL)isFlipped{return YES;}@end
	// Internal class. The container for list element.
@interface ExpandableItemView : FlippedView
@property (assign) BOOL expanded;
@property (strong) NSView *contentView;
@property (strong) NSButton *disclosureButton;
@property (strong) NSTextField *label;
- (void) toggle;
- (void) toggleAll;
@end

// Main class implementation.
@interface ListContainerView : FlippedView
@end

@implementation ExpandableItemView
- (id)initWithContentView:(NSView *)view	{

		// | NSViewMinXMargin | NSViewMaxXMargin;

   NSRect frame = AZRectExceptHigh(AZRectFromSize(view.size), view.height + BUTTON_HEIGHT);
   if (!(self = [super initWithFrame:frame])) return nil;
	self.arMASK 	    = NSViewWidthSizable;
   frame.origin.y    += BUTTON_HEIGHT;
   frame.size.height -= BUTTON_HEIGHT;
		// expanded = YES;
	[self addSubview:_contentView = view];
	_contentView.arMASK 	= NSViewWidthSizable;
	_contentView.frame 	= frame;
	frame.origin.y 		= 0.0f;
   frame.size.height = BUTTON_HEIGHT;
	[self addSubview: _disclosureButton = [NSButton.alloc initWithFrame:frame]];
	_disclosureButton.bezelStyle = NSSmallSquareBezelStyle;
	_disclosureButton.arMASK = NSViewWidthSizable;
	__block id blockself = self;
	[_disclosureButton setActionBlock:^(id sender) {
	   if (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) != 0)
   		[blockself toggleAll];	    // do special action
    	else
			[(ExpandableItemView*)blockself toggle];  // do normal action
	}];
		//	[_disclosureButton setAction:@selector(toggle) withTarget:self];
	return self;
}
- (void) toggleAll {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext]setDuration:5];
	[[self.superview subviewsOfClass:ExpandableItemView.class]makeObjectsPerformSelector:@selector(toggle)];
	[NSAnimationContext endGrouping];

}

- (void)toggle	{

	_expanded = !_expanded;
	NSRect frame = self.frame;
	frame.size.height = BUTTON_HEIGHT;
	if (_expanded)  frame.size.height += _contentView.frame.size.height;
	self.frame = frame;
	[_contentView setHidden:!_expanded];
	[self.superview setNeedsLayout:YES];
	[self.superview layoutSubtreeIfNeeded];
}

- (void)setTitle:(NSString *)title	{  _disclosureButton.title = title;	}

@end
@implementation ListContainerView
- (void)layout	{
	__block NSRect frame = self.frame;
	__block CGF 	height = 0.0f;
	[self.subviews each:^(NSV* view) {
		frame.origin.y = height;
		frame.size.height = view.frame.size.height;
		view.frame = frame;
		height += frame.size.height;
	}];
	frame.origin.y 	= 0.0f;
	frame.size.height = height;
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext]setDuration:.5];
	if (frame.size.height != _window.height) {

			//		[_window setFrame:AZRectExceptHigh(_window.frame, MIN(frame.size.height,AZScreenHeight())) display:YES animate:YES];
		[_window.animator resizeToWidth:_window.width height:MIN(frame.size.height,AZScreenHeight()) origin:NSWindowResizeTopLeftCorner];
			//		 extendVerticallyBy:self.window.height - frame.size.height];
	}
		//	else if (frame.size.height < _window.height) {
		//		NSPoint p = AZPointOffsetY(_window.frame.origin, _window.height);
		//		[_window setFrame:frame display:NO];
		//		p.y = MAX (p.y, 100);
		//		[_window setFrameTopLeftPoint:p];
		//		[_window display];
		//	}
	[self.animator setFrame:frame];
	[NSAnimationContext endGrouping];
	[super layout];
}
@end
@implementation ExpandableListView 	{ 	NSScrollView *scrollView; NSView *containerView; }
- (id)initWithFrame:(NSRect)frame	{
	if (!(self = [super initWithFrame:frame])) return nil;
	self.subviews 							= @[scrollView 	= [NSScrollView.alloc      initWithFrame:self.bounds]];
	scrollView.documentView 			= containerView 	= [ListContainerView.alloc initWithFrame:self.bounds];
	containerView.arMASK 				= NSViewWidthSizable;
	scrollView.hasVerticalScroller 	= YES;
	scrollView.hasHorizontalScroller = scrollView.drawsBackground = NO;
	scrollView.arMASK 					= NSSIZEABLE;
	return self;
}

- (void)reloadData
{
   while (containerView.subviews.count)
		[containerView.subviews.lastObject removeFromSuperviewWithoutNeedingDisplay];
	NSInteger count = _node.children.count;//[_dataSource numberOfViewsInExpandableList:self];
	NSLog(@"nodechildrenct: %ld", count);
	for (NSUInteger index = 0; index < count; index++)
	{
		ExpandableItemView *view1;
		[containerView addSubview:view1 =
		 [ExpandableItemView.alloc initWithContentView:[_dataSource expandableList:self viewAtIndex:index]]];
		[view1 setTitle:[self.node.children[index] key]];//[_dataSource expandableList:self titleAtIndex:index]];
		[view1 toggle];
	}
	[containerView setNeedsLayout:YES];
	[containerView layoutSubtreeIfNeeded];
}

@end

/*
- (id)initWithContentView:(NSView *)view
{
	NSUInteger autoresizingMask = NSViewWidthSizable;// | NSViewMinXMargin | NSViewMaxXMargin;

	NSRect frame = view.frame;
	frame.origin.x = 0.0f;
	frame.origin.y = 0.0f;
	frame.size.height += BUTTON_HEIGHT;

   if ( self != [super initWithFrame:frame] ) return nil;
	[self setAutoresizingMask:autoresizingMask];

	frame.origin.y += BUTTON_HEIGHT;
	frame.size.height -= BUTTON_HEIGHT;

	expanded = YES;
	contentView = view;
	[contentView setAutoresizingMask:autoresizingMask];
	[contentView setFrame:frame];
	[self addSubview:contentView];

	frame.origin.y = 0.0f;
	frame.size.height = BUTTON_HEIGHT;
	disclosureButton = [[NSButton alloc] initWithFrame:frame];
	[disclosureButton setBezelStyle:NSSmallSquareBezelStyle];
	[disclosureButton setAutoresizingMask:autoresizingMask];
	[disclosureButton setTarget:self];
	[disclosureButton setAction:@selector(toggle)];
	[self addSubview:disclosureButton];
	return self;
}

- (void)toggle
{
	expanded = !expanded;

	NSRect frame = self.frame;
	frame.size.height = BUTTON_HEIGHT;

	if (expanded)
	{
		frame.size.height += contentView.frame.size.height;
	}

	self.frame = frame;
	[contentView setHidden:!expanded];
	[self.superview setNeedsLayout:YES];
	[self.superview layoutSubtreeIfNeeded];
}

- (void)setTitle:(NSString *)title
{
	[disclosureButton setTitle:title];
}
@end

	// Main class implementation.
@interface ListContainerView : FlippedView
@end

@implementation ListContainerView

- (void)layout
{
	NSRect frame = self.frame;
	float height = 0.0f;

	for (NSView *view in self.subviews)
	{
		frame.origin.y = height;
		frame.size.height = view.frame.size.height;
		view.frame = frame;

		height += frame.size.height;
	}

	frame.origin.y = 0.0f;
	frame.size.height = height;
	self.frame = frame;

	[super layout];
}
@end

@interface ExpandableListView ()
{
@private
	NSView *containerView;
}
@end

@implementation ExpandableListView
@synthesize dataSource;

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		containerView = [[ListContainerView alloc] initWithFrame:self.bounds];
		[containerView setAutoresizingMask:NSViewWidthSizable];

		NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
		[scrollView setDocumentView:containerView];
		[scrollView setHasVerticalScroller:YES];
		[scrollView setHasHorizontalScroller:NO];
		[scrollView setDrawsBackground:NO];
		[scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable ];

		[self addSubview:scrollView];
		[scrollView release];
	}

	return self;
}

- (void)reloadData
{
	while ([[containerView subviews] count])
		[[[containerView subviews] lastObject] removeFromSuperviewWithoutNeedingDisplay];

	NSInteger count = [dataSource numberOfViewsInExpandableList:self];
	for (NSInteger index = 0; index < count; index++)
	{
		NSView *view = [dataSource expandableList:self viewAtIndex:index];

		ExpandableItemView *view1 = [[ExpandableItemView alloc] initWithContentView:view];

		[view1 setTitle:[dataSource expandableList:self titleAtIndex:index]];
		[containerView addSubview:view1];
		[view1 release];
	}

	[containerView setNeedsLayout:YES];
	[containerView layoutSubtreeIfNeeded];
}

@end
*/