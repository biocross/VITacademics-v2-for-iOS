RSBarcodes [![Build Status](https://travis-ci.org/yeahdongcn/RSBarcodes.png)](https://travis-ci.org/yeahdongcn/RSBarcodes)
==========
RSBarcodes allows you to scan 1D and 2D barcodes using metadata scanning capabilities introduced with iOS7 and generate the same set of barcode images for displaying and sharing.

Current Status
------------
###Barcode Scanner:
    Multiple corners and border rectangles display view -- Done
    Manually changing focus point -- Done
    Focus mark drawing -- Done

###Barcode Generators:
    "org.gs1.UPC-E", -- Done
    "org.iso.Code39", -- Done
    "org.iso.Code39Mod43", -- Done
    "org.gs1.EAN-13", -- Done by 张玺 (http://zhangxi.me)
    "org.gs1.EAN-8", -- Done by 张玺 (http://zhangxi.me)
    "com.intermec.Code93", -- Done
    "org.iso.Code128", -- Done
    "org.iso.PDF417", -- Done
    "org.iso.QRCode", -- Done
    "org.iso.Aztec", -- Done
    // --------------------
    Extended Code 39, -- Done
    ISBN, -- WIP
    ISSN -- WIP
    
    Code display view -- Done
    
Installation
------------
<a href="http://cocoapods.org/" target="_blank">CocoaPods</a> is the recommended method of installing RSBarcodes.

Simply add the following line to your `Podfile`:

    pod 'RSBarcodes'

Usage
------------

###Barcode Scanner:

Place a `UIViewController` in storyboard and set `RSScannerViewController` based class as its custom class. If you want to use the corners view (for barcode corners and borders displaying), you can put a `UIView` onto the view controller’s view and set `RSCornersView` as its custom class then link the `highlightView` to it, make sure the view’s size is as large as the view controller’s view.

In `RSScannerViewController` based class implements your own handler.

    - (id)initWithCoder:(NSCoder *)aDecoder
    {
        self = [super initWithCoder:aDecoder];
        if (self) {
            __weak typeof(self) weakSelf = self;
            self.barcodesHandler = ^(NSArray *barcodeObjects) {
            };
            self.tapGestureHandler = ^(CGPoint tapPoint) {
            });
        }
        return self;
    }

###Barcode Generators:

Import `RSCodeGen.h` into your source file and using `CodeGen` to generate barcode image. RSBarcodes provides 2 ways.

    @protocol RSCodeGenerator <NSObject>

    - (UIImage *)genCodeWithMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)machineReadableCodeObject;

    - (UIImage *)genCodeWithContents:(NSString *)contents machineReadableCodeObjectType:(NSString *)type;

    @end

Here are examples, the generated image could be used along with `RSCodeView` or `UIImageView`.

    [CodeGen genCodeWithContents:<#(NSString *)#> machineReadableCodeObjectType:<#(NSString *)#>] // Types are coming from AVMetadataObject.h and RSCodeGen.h

or

    [CodeGen genCodeWithMachineReadableCodeObject:<#(AVMetadataMachineReadableCodeObject *)#>]

License
------------
    The MIT License (MIT)

    Copyright (c) 2012-2014 P.D.Q.

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

------------  
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/yeahdongcn/rsbarcodes/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

