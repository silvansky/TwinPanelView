//
//  TwinPanelView.h
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwinPanelView : NSView

@property (retain, readonly) NSView *leftView;
@property (retain, readonly) NSView *rightView;

- (void)setLeftView:(NSView *)leftView rightView:(NSView *)rightView;

- (void)setLeftViewMinimumWidth:(CGFloat)width;
- (void)setLeftViewMaximumWidth:(CGFloat)width;

- (void)setRightViewMinimumWidth:(CGFloat)width;
- (void)setRightViewMaximumWidth:(CGFloat)width;

- (void)setMinumumHeight:(CGFloat)height;
- (void)setMaxumumHeight:(CGFloat)height;

@end
