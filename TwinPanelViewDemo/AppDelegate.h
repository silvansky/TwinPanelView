//
//  AppDelegate.h
//  TwinPanelViewDemo
//
//  Created by Valentine Silvansky on 05.03.13.
//  Copyright (c) 2013 silvansky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TwinPanelView;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSOutlineView *outlineView;
@property (assign) IBOutlet NSScrollView *outlineViewScrollView;
@property (assign) IBOutlet TwinPanelView *twinPanelView;

@end
