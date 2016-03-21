# Basic Image View

Displays an NSImage in an NSImageView within a NSScrollView with support for
pan, zoom, fit to window and fit to image. Left mouse pans, mouse wheel zooms.


## To Do

Bugs:

* Fix XIB instantiation. IBOutlet fields not initialized when ZRRImageView assigned as custom type in IB.
* Fit to window and fit to screen have the wrong bounds? These work in my other app that uses this code??

Basics:

* Support for pinch gesture to zoom
* Animate to center
* Rubber-band mouse movements
* Pixel value display

Longer term:

* Alpha display
* RGB channel display
* Wipe/compare
* Random colors
* Luminance/gray display
* Stop up/down, brightness/contrast
