# TwinPanelView - an autolayout based NSSplitView replacement

TwinPanelView custom view requires autolayout enabled in a xib it is added to. Note that autolayout is available since OS X 10.7 and not supported on 10.6 or older.

NSSplitView is a buggy thing when it comes to autolayout, so I've decided to write my own split view based on autolayout features. This repo contains also a demo project, which shows a typical TwinPanelView use cases.

If you are looking for multi-handle split view, you may be interesten in my [ALSplitView](https://github.com/silvansky/ALSplitView) project.

The source code of TwinPanelView is distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License). See file LICENSE for more information.

## Main features:

- only two subviews can be added (leftView and rightView)
- horizontal orientation only
- styling handles with background color, background image and handle image
- minimum and maximum size limits support for subviews
- leftView always preserves its width (on any resize)

## Usage example:

``` obj-c
// assuming twinPanelView, leftView and rightView are IBOutlets
self.twinPanelView.handleWidth = 5.f;
self.twinPanelView.handleColor = [NSColor grayColor];
self.twinPanelView.handleImage = [NSimage imageNamed:@"handle_circle"];
[self.twinPanelView setLeftView:self.leftView rightView:self.rightView];
[self.twinPanelView setLeftViewMinimumWidth:200.f];
[self.twinPanelView setLeftViewMaximumWidth:300.f];
[self.twinPanelView setRightViewMinimumWidth:500.f];
```
