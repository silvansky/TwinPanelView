//
//  TwinPanelView.h
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//
//  Original code stored at https://github.com/silvansky/TwinPanelView
//  Distributed under MIT License
//

#import <Cocoa/Cocoa.h>

@interface TwinPanelView : NSView

@property (retain, readonly) NSView *leftView;
@property (retain, readonly) NSView *rightView;

@property (retain) NSColor *handleColor;
@property (retain) NSImage *handleBackgroundImage;
@property (retain) NSImage *handleImage;
@property (assign) CGFloat handleWidth;
@property (assign) BOOL doubleClickSetDefaultWidth;

- (void)setLeftView:(NSView *)leftView rightView:(NSView *)rightView;

- (void)setLeftViewMinimumWidth:(CGFloat)width;
- (void)setLeftViewMaximumWidth:(CGFloat)width;

- (void)setRightViewMinimumWidth:(CGFloat)width;
- (void)setRightViewMaximumWidth:(CGFloat)width;

- (void)setMinimumHeight:(CGFloat)height;
- (void)setMaximumHeight:(CGFloat)height;

- (void)setHandleOuterWidth:(CGFloat)width;
- (void)setDefaultLeftViewWidth:(CGFloat)width;

- (NSDictionary *)saveHandlePosition;
- (void)restoreHandlePositionWithDictionary:(NSDictionary *)dictionary;

@end
