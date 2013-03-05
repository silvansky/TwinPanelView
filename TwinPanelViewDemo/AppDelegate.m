//
//  AppDelegate.m
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//

#import "AppDelegate.h"
#import "TwinPanelView.h"

#import <WebKit/WebKit.h>

@interface AppDelegate ()

@property (retain) WebView *webView;
@property (retain) NSMutableArray *outlineViewData;

@end

@implementation AppDelegate

- (void)dealloc
{
	self.outlineView = nil;
	self.webView = nil;
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
	self.outlineViewData = [NSMutableArray arrayWithCapacity:10000];
	for (NSInteger i = 0; i < 10000; i++)
	{
		[self.outlineViewData addObject:[NSString stringWithFormat:@"Element %ld", i]];
	}
	self.webView = [[[WebView alloc] init] autorelease];
	[self.webView setMainFrameURL:@"http://news.google.com"];
	[self.twinPanelView setLeftView:self.outlineViewScrollView rightView:self.webView];
	[self.twinPanelView setMinumumHeight:500.f];
	[self.twinPanelView setLeftViewMinimumWidth:200.f];
	[self.twinPanelView setLeftViewMaximumWidth:300.f];
	[self.twinPanelView setRightViewMinimumWidth:500.f];
}

#pragma mark - NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (!item)
	{
		return [self.outlineViewData count];
	}
	else
	{
		return 0;
	}
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	if (!item)
	{
		return self.outlineViewData[index];
	}
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return NO;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSTableCellView *view;
	view = [outlineView makeViewWithIdentifier:@"cell" owner:self];
	NSString *s = item;
	view.textField.stringValue = s;
	view.imageView.image = [NSImage imageNamed:@"img"];
	return view;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
	return 63.f;
}


@end
