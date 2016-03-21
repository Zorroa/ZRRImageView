//
//  AppDelegate.m
//  ZRRImageViewApp
//
//  Created by Daniel Wexler on 3/20/16.
//  Copyright © 2016 Zorroa. All rights reserved.
//

#import "AppDelegate.h"
#import "ZRRImageView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet ZRRImageView *view;

@property (strong) ZRRImageView *imageView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // FIXME: This shouldn't be needed. Instead we should simply assign
    // ZRRImageView to the class in interface builder, but, for some reason,
    // that doesn't actually populate the IBOutlets when instantiated.
    self.imageView = [[ZRRImageView alloc] initWithFrame:self.window.frame];
    self.imageView.frame = self.view.frame;
    [self.view addSubview:self.imageView];

    [self.imageView setImage:[NSImage imageNamed:@"sunset"]];
}

@end
