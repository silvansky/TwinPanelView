//
//  TwinPanelView.m
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//
//  Original code stored at https://github.com/silvansky/TwinPanelView
//

#import "TwinPanelView.h"

#pragma mark - TwinPanelViewHandle interface

@interface TwinPanelViewHandle : NSView

@property (assign) TwinPanelView *twinPanelView;
@property (retain) NSTrackingArea *trackingArea;

@end

#pragma mark - TwinPanelView private interface

@interface TwinPanelView ()

@property (retain, readwrite) NSView *leftView;
@property (retain, readwrite) NSView *rightView;

@property (retain) TwinPanelViewHandle *handle;

@property (retain) NSArray *mainConstraints;
@property (retain) NSArray *sizingConstraints;
@property (retain) NSLayoutConstraint *draggingConstraint;
@property (retain) NSLayoutConstraint *handleWidthConstraint;

@property (retain) NSLayoutConstraint *leftViewMinimumWidthConstraint;
@property (retain) NSLayoutConstraint *leftViewMaximumWidthConstraint;
@property (retain) NSLayoutConstraint *rightViewMinimumWidthConstraint;
@property (retain) NSLayoutConstraint *rightViewMaximumWidthConstraint;

@property (retain) NSLayoutConstraint *minimumHeightConstraint;
@property (retain) NSLayoutConstraint *maximumHeightConstraint;

@property (retain) NSLayoutConstraint *leftViewWidthConstraint;

- (NSDictionary *)viewsDictionary;

- (void)updateMainConstraints;
- (void)updateSizingConstraints;

@end

#pragma mark - TwinPanelView implementation

@implementation TwinPanelView

#pragma mark - Alloc/dealloc

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.handle = [[[TwinPanelViewHandle alloc] init] autorelease];
		self.handle.twinPanelView = self;
		[self addSubview:self.handle];
	}
	return self;
}

- (void)dealloc
{
	self.leftView = nil;
	self.rightView = nil;
	self.handle = nil;
	self.mainConstraints = nil;
	self.sizingConstraints = nil;
	self.draggingConstraint = nil;
	[super dealloc];
}

#pragma mark - Public

- (void)setLeftView:(NSView *)leftView rightView:(NSView *)rightView
{
	[self removeConstraints:[self constraints]];
	if (self.leftView)
	{
		[self.leftView removeFromSuperview];
	}
	if (self.rightView)
	{
		[self.rightView removeFromSuperview];
	}
	self.leftView = leftView;
	self.rightView = rightView;
	[self addSubview:self.leftView];
	[self addSubview:self.rightView];
	[self setNeedsUpdateConstraints:YES];
}

- (void)setLeftViewMinimumWidth:(CGFloat)width
{
	if (!self.leftView)
	{
		return;
	}

	if (self.leftViewMinimumWidthConstraint)
	{
		[self removeConstraint:self.leftViewMinimumWidthConstraint];
		self.leftViewMinimumWidthConstraint = nil;
	}

	self.leftViewMinimumWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(>=width)]" options:0 metrics:@{ @"width" : @(width) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.leftViewMinimumWidthConstraint];
}

- (void)setLeftViewMaximumWidth:(CGFloat)width
{
	if (!self.leftView)
	{
		return;
	}

	if (self.leftViewMaximumWidthConstraint)
	{
		[self removeConstraint:self.leftViewMaximumWidthConstraint];
		self.leftViewMaximumWidthConstraint = nil;
	}

	self.leftViewMaximumWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(<=width)]" options:0 metrics:@{ @"width" : @(width) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.leftViewMaximumWidthConstraint];
}

- (void)setRightViewMinimumWidth:(CGFloat)width
{
	if (!self.rightView)
	{
		return;
	}

	if (self.rightViewMinimumWidthConstraint)
	{
		[self removeConstraint:self.rightViewMinimumWidthConstraint];
		self.rightViewMinimumWidthConstraint = nil;
	}

	self.rightViewMinimumWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightView(>=width)]" options:0 metrics:@{ @"width" : @(width) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.rightViewMinimumWidthConstraint];
}

- (void)setRightViewMaximumWidth:(CGFloat)width
{
	if (!self.rightView)
	{
		return;
	}

	if (self.rightViewMaximumWidthConstraint)
	{
		[self removeConstraint:self.rightViewMaximumWidthConstraint];
		self.rightViewMaximumWidthConstraint = nil;
	}

	self.rightViewMaximumWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightView(<=width)]" options:0 metrics:@{ @"width" : @(width) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.rightViewMaximumWidthConstraint];
}

- (void)setMinumumHeight:(CGFloat)height
{
	if (self.minimumHeightConstraint)
	{
		[self removeConstraint:self.minimumHeightConstraint];
		self.minimumHeightConstraint = nil;
	}

	self.minimumHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(>=height)]" options:0 metrics:@{ @"height" : @(height) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.minimumHeightConstraint];
}

- (void)setMaxumumHeight:(CGFloat)height
{
	if (self.maximumHeightConstraint)
	{
		[self removeConstraint:self.maximumHeightConstraint];
		self.maximumHeightConstraint = nil;
	}

	self.maximumHeightConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(<=height)]" options:0 metrics:@{ @"height" : @(height) } views:[self viewsDictionary]] lastObject];
	[self addConstraint:self.maximumHeightConstraint];
}

#pragma mark - Private

- (NSDictionary *)viewsDictionary
{
	if (self.leftView && self.rightView)
	{
		return @{ @"leftView" : self.leftView, @"rightView" : self.rightView, @"handle" : self.handle, @"self" : self };
	}
	else
	{
		return @{ @"handle" : self.handle, @"self" : self };
	}
}

- (void)updateMainConstraints
{
	if (!(self.leftView && self.rightView))
	{
		return;
	}
	NSMutableArray *constraints = [NSMutableArray array];

	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftView][handle][rightView]|" options:0 metrics:nil views:[self viewsDictionary]]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftView]|" options:0 metrics:nil views:[self viewsDictionary]]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[handle]|" options:0 metrics:nil views:[self viewsDictionary]]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightView]|" options:0 metrics:nil views:[self viewsDictionary]]];
	self.handleWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[handle(5)]" options:0 metrics:nil views:[self viewsDictionary]] lastObject];
	[constraints addObject:self.handleWidthConstraint];

	if (self.mainConstraints)
	{
		[self removeConstraints:self.mainConstraints];
	}
	self.mainConstraints = constraints;
	[self addConstraints:self.mainConstraints];
}

- (void)updateSizingConstraints
{

}

#pragma mark - Overrides

+ (BOOL)requiresConstraintBasedLayout
{
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];
	NSRectFill(self.bounds);
}

- (void)updateConstraints
{
	if (!self.mainConstraints)
	{
		[self updateMainConstraints];
	}
	[super updateConstraints];
}

- (void)addSubview:(NSView *)aView
{
	[aView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[super addSubview:aView];
}

@end

#pragma mark - TwinPanelViewHandle

@implementation TwinPanelViewHandle

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor redColor] set];
	NSRectFill(self.bounds);
}

- (void)updateTrackingAreas
{
	[self removeTrackingArea:self.trackingArea];
	self.trackingArea = [[[NSTrackingArea alloc] initWithRect:self.bounds options:(NSTrackingCursorUpdate | NSTrackingActiveAlways | NSTrackingInVisibleRect) owner:self userInfo:nil] autorelease];
	[self addTrackingArea:self.trackingArea];
	[super updateTrackingAreas];
}

#pragma mark - Mouse events

- (void)cursorUpdate:(NSEvent *)event
{
	[super resetCursorRects];
	NSCursor *newCursor;
	newCursor = [NSCursor resizeLeftRightCursor];
	[self addCursorRect:[self bounds] cursor:newCursor];
	[newCursor set];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	// location in superview
	NSPoint location = [self.twinPanelView convertPoint:[theEvent locationInWindow] fromView:nil];
	[self.twinPanelView removeConstraint:self.twinPanelView.draggingConstraint];
	if (self.twinPanelView.leftViewWidthConstraint)
	{
		[self.twinPanelView removeConstraint:self.twinPanelView.leftViewWidthConstraint];
		self.twinPanelView.leftViewWidthConstraint = nil;
	}
	self.twinPanelView.draggingConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.twinPanelView attribute:NSLayoutAttributeLeft multiplier:0.f constant:location.x];
	[self.twinPanelView.draggingConstraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow];
	[self.twinPanelView addConstraint:self.twinPanelView.draggingConstraint];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	// location in superview
	NSPoint location = [self.twinPanelView convertPoint:[theEvent locationInWindow] fromView:nil];
	[self.twinPanelView removeConstraint:self.twinPanelView.draggingConstraint];
	self.twinPanelView.draggingConstraint.constant = location.x;
	[self.twinPanelView addConstraint:self.twinPanelView.draggingConstraint];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[self.twinPanelView removeConstraint:self.twinPanelView.draggingConstraint];
	self.twinPanelView.draggingConstraint = nil;
	self.twinPanelView.leftViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(width)]" options:0 metrics:@{ @"width" : @(self.twinPanelView.leftView.frame.size.width) } views:[self.twinPanelView viewsDictionary]] lastObject];
	[self.twinPanelView.leftViewWidthConstraint setPriority:NSLayoutPriorityDefaultHigh];
	[self.twinPanelView addConstraint:self.twinPanelView.leftViewWidthConstraint];
}

@end
