//
//  TwinPanelView.m
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//
//  Original code stored at https://github.com/silvansky/TwinPanelView
//  Distributed under MIT License
//

#import "TwinPanelView.h"

#pragma mark - TwinPanelViewHandle interface

@interface TwinPanelViewHandle : NSView

@property (assign) TwinPanelView *twinPanelView;
@property (retain) NSTrackingArea *trackingArea;

@end

#pragma mark - TwinPanelView private interface

@interface TwinPanelView ()
{
	NSColor *_handleColor;
	NSImage *_handleBackgroundImage;
	NSImage *_handleImage;
	CGFloat _handleWidth;
}

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
		_handleWidth = 10.f;
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
	self.handleWidthConstraint = nil;
	self.leftViewMinimumWidthConstraint = nil;
	self.leftViewMaximumWidthConstraint = nil;
	self.leftViewWidthConstraint = nil;
	self.rightViewMinimumWidthConstraint = nil;
	self.rightViewMaximumWidthConstraint = nil;
	self.handleColor = nil;
	self.handleBackgroundImage = nil;
	self.handleImage = nil;
	[super dealloc];
}

#pragma mark - Public

- (void)setLeftView:(NSView *)leftView rightView:(NSView *)rightView
{
	[self removeConstraints:[self constraints]];
	self.mainConstraints = nil;
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

- (NSDictionary *)saveHandlePosition
{
	if (self.leftView)
	{
		// left view width is enough
		return @{ @"leftViewWidth" : @(self.leftView.frame.size.width) };
	}
	return @{};
}

- (void)restoreHandlePositionWithDictionary:(NSDictionary *)dictionary
{
	if (dictionary)
	{
		NSNumber *n = dictionary[@"leftViewWidth"];
		if (n)
		{
			CGFloat width = [n floatValue];
			if (!self.leftViewWidthConstraint)
			{
				self.leftViewWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView(width)]" options:0 metrics:@{ @"width" : @(width) } views:[self viewsDictionary]] lastObject];
				[self.leftViewWidthConstraint setPriority:NSLayoutPriorityDefaultHigh];
				[self addConstraint:self.leftViewWidthConstraint];
			}
			else
			{
				self.leftViewWidthConstraint.constant = width;
			}
		}
	}
}

#pragma mark - Properties

- (NSColor *)handleColor
{
	@synchronized(self)
	{
		return _handleColor;
	}
}

- (void)setHandleColor:(NSColor *)handleColor
{
	@synchronized(self)
	{
		[handleColor retain];
		[_handleColor release];
		_handleColor = handleColor;
		[self.handle setNeedsDisplay:YES];
	}
}

- (NSImage *)handleBackgroundImage
{
	@synchronized(self)
	{
		return _handleBackgroundImage;
	}
}

- (void)setHandleBackgroundImage:(NSImage *)handleBackgroundImage
{
	@synchronized(self)
	{
		[handleBackgroundImage retain];
		[_handleBackgroundImage release];
		_handleBackgroundImage = handleBackgroundImage;
		[self.handle setNeedsDisplay:YES];
	}
}

- (NSImage *)handleImage
{
	@synchronized(self)
	{
		return _handleImage;
	}
}

- (void)setHandleImage:(NSImage *)handleImage
{
	@synchronized(self)
	{
		[handleImage retain];
		[_handleImage release];
		_handleImage = handleImage;
		[self.handle setNeedsDisplay:YES];
	}
}

- (CGFloat)handleWidth
{
	@synchronized(self)
	{
		return _handleWidth;
	}
}

- (void)setHandleWidth:(CGFloat)handleWidth
{
	@synchronized(self)
	{
		_handleWidth = handleWidth;
		self.handleWidthConstraint.constant = _handleWidth;
	}
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
	self.handleWidthConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:@"H:[handle(width)]" options:0 metrics:@{ @"width" : @(self.handleWidth) } views:[self viewsDictionary]] lastObject];
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
	[[NSColor clearColor] set];
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
	[[NSColor clearColor] set];
	NSRectFill(self.bounds);
	if (self.twinPanelView.handleColor)
	{
		[self.twinPanelView.handleColor set];
		NSRectFill(dirtyRect);
	}
	if (self.twinPanelView.handleBackgroundImage)
	{
		[self.twinPanelView.handleBackgroundImage drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.f respectFlipped:YES hints:nil];
	}
	if (self.twinPanelView.handleImage)
	{
		NSRect centeredRect;
		centeredRect.origin.x = self.bounds.origin.x + (self.bounds.size.width - [self.twinPanelView.handleImage size].width) / 2.f;
		centeredRect.origin.y = self.bounds.origin.y + (self.bounds.size.height - [self.twinPanelView.handleImage size].height) / 2.f;
		centeredRect.size = self.twinPanelView.handleImage.size;
		[self.twinPanelView.handleImage drawInRect:centeredRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.f respectFlipped:YES hints:nil];
	}
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
