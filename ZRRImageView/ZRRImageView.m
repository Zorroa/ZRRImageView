//
//  ZRRImageView.m
//  Dashboard
//
//  Created by Daniel Wexler on 3/18/16.
//  Copyright © 2016 Zorroa. All rights reserved.
//

#import "ZRRImageView.h"
#import "ZRRImageClipView.h"
#import <Quartz/Quartz.h>
#import <CoreGraphics/CGImage.h>

@interface ZRRImageView ()

@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet ZRRImageClipView *clipView;
@property (weak) IBOutlet NSImageView *imageView;

@property (assign) NSPoint mouseDownLocationInWindow;   // Track delta movements
@property (assign) NSPoint mouseDownOrigin;             // Apply delta scroll

@end

@implementation ZRRImageView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];

    // Instantiate ourselves using a temporary controller
    NSViewController *viewController = [[NSViewController alloc] init];
    NSArray *topLevelObjects;
    [[NSBundle mainBundle] loadNibNamed:@"ZRRImageView" owner:viewController topLevelObjects:&topLevelObjects];

    // Find the view in the object and reset the self pointer
    for (id obj in topLevelObjects) {
        if ([obj isKindOfClass:[ZRRImageView class]]) {
            self = (ZRRImageView *)obj;     // TRICKY: Resetting self pointer
            self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
            self.scrollView.documentCursor = [NSCursor openHandCursor];
            return self;
        }
    }

    return nil;
}

- (void)awakeFromNib {
    self.scrollView.backgroundColor = [NSColor colorWithWhite:0.5 alpha:1];
    self.clipView.backgroundColor = [NSColor colorWithWhite:0.5 alpha:1];
}

- (void)setImage:(NSImage *)image {
    self.imageView.image = image;
    [self.scrollView magnifyToFitRect:self.bounds];
}

- (void)setShowControls:(BOOL)showControls {
    _showControls = showControls;
    for (NSView *subview in self.subviews) {
        if ([subview isKindOfClass:[NSButton class]]) {
            NSButton *button = (NSButton *)subview;
            button.hidden = !showControls;
        }
    }
}

#pragma mark - Mouse Events

// Intercept events to the clip or image view for pan & zoom, but allow other
// events to be handled normally. We'll pass through the mouse events.
- (NSView *)hitTest:(NSPoint)aPoint {
    NSView *view = [super hitTest:aPoint];
    if (view == self.clipView || view == self.imageView) {
        return self;
    }
    return view;
}

- (void)scrollWheel:(NSEvent *)theEvent {
    CGFloat scale = theEvent.scrollingDeltaY > 0 ? 1 / (1 + theEvent.scrollingDeltaY) : 1 - theEvent.scrollingDeltaY;
    CGPoint contentLocation = [self.imageView convertPoint:theEvent.locationInWindow fromView:nil];
    [self.scrollView setMagnification:scale * self.scrollView.magnification centeredAtPoint:contentLocation];
    [self snapToCenter];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [[self window] disableCursorRects];
    [[NSCursor openHandCursor] push];
    self.mouseDownLocationInWindow = theEvent.locationInWindow;
    self.mouseDownOrigin = self.scrollView.documentVisibleRect.origin;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    [[NSCursor openHandCursor] set];
    CGFloat dx = theEvent.locationInWindow.x - self.mouseDownLocationInWindow.x;
    CGFloat dy = theEvent.locationInWindow.y - self.mouseDownLocationInWindow.y;
    dx /= self.scrollView.magnification;
    dy /= self.scrollView.magnification;
    [self.scrollView.contentView scrollToPoint:NSMakePoint(self.mouseDownOrigin.x - dx, self.mouseDownOrigin.y - dy)];
    [self.scrollView reflectScrolledClipView:self.scrollView.contentView];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self.window enableCursorRects];
    [self.window resetCursorRects];
    [self snapToCenter];
}

- (void)snapToCenter {
    NSRect bounds = [self.clipView constrainBoundsRect:self.clipView.bounds];
    if (bounds.origin.x != self.clipView.bounds.origin.x ||
        bounds.origin.y != self.clipView.bounds.origin.y) {
        [NSAnimationContext beginGrouping];
        [self.clipView.animator setBoundsOrigin:bounds.origin];
        [NSAnimationContext endGrouping];
    }
}

#pragma mark - Actions

- (IBAction)fitToScreenAction:(id)sender {
    [self.scrollView magnifyToFitRect:self.scrollView.bounds];
}

- (IBAction)actualSizeAction:(id)sender {
    const float frameAspect = self.bounds.size.width / self.bounds.size.height;
    const float imageAspect = self.imageView.image.size.width / self.imageView.image.size.height;
    const float frameToImageRatio = frameAspect / imageAspect;

    float scale;
    float mViewportMinScalePad = 0;
    if (frameToImageRatio < 1)                  // Frame narrower than image
        scale = (self.bounds.size.width - 2 * mViewportMinScalePad) / self.imageView.image.size.width;
    else                                        // Image narrower than frame
        scale = (self.bounds.size.height - 2 * mViewportMinScalePad) / self.imageView.image.size.height;

    self.scrollView.magnification = 1/scale;
}

- (IBAction)zoomOutAction:(id)sender {
    static const CGFloat kZoomOutFactor = 0.7071068;
    [self.scrollView setMagnification:self.scrollView.magnification * kZoomOutFactor];
}

- (IBAction)zoomInAction:(id)sender {
    static const CGFloat kZoomInFactor = 1.414214;
    [self.scrollView setMagnification:self.scrollView.magnification * kZoomInFactor];
}

@end
