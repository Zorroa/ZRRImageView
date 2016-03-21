//
//  ZRRImageView.h
//  Dashboard
//
//  Created by Daniel Wexler on 3/18/16.
//  Copyright © 2016 Zorroa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZRRImageView : NSView

@property (assign, nonatomic) BOOL showControls;

- (void)setImage:(NSImage *)image;

@end
