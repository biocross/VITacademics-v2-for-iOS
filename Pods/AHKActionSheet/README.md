# AHKActionSheet
[![Twitter: @arekholko](https://img.shields.io/badge/contact-@arekholko-red.svg?style=flat)](https://twitter.com/arekholko)
[![License: MIT](https://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://github.com/fastred/AHKActionSheet/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/AHKActionSheet.svg?style=flat)](https://github.com/fastred/AHKActionSheet)

An alternative to the UIActionSheet with a block-based API and a customizable look. Inspired by the Spotify app. It looks a lot better live than on the GIF (because compression).

![Demo GIF](https://raw.githubusercontent.com/fastred/AHKActionSheet/master/example.gif)

## Features

 * Modern, iOS 7 look
 * Block-based API
 * Highly customizable
 * Gesture-driven navigation with two ways to hide the control: either quick flick down or swipe and release (at the position when the blur is starting to fade)
 * Use a simple label or a completely custom view above the buttons
 * Use with or without icons (text can be optionally centered)
 * Status bar style matches the one from the presenting controller

## Demo

Build and run the `AHKActionSheetExample` project in Xcode. `AHKViewController.m` file contains the important code used in the example.

## Requirements

 * iOS 7.0 and above
 * ARC
 * Optimized for iPhone

## Installation
### CocoaPods

AHKActionSheet is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "AHKActionSheet"
### Manual
Copy all files from `Classes/` directory to your project. Then, add `QuartzCore.framework` to your project.

## Usage
A simple example:

```obj-c
#import "AHKActionSheet.h"
...
AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:nil];
[actionSheet addButtonWithTitle:@"Test" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
    NSLog(@"Test tapped");
}];
[actionSheet show];
```

The view is customizable either directly or through a UIAppearance API. See the header file (`Classes/AHKActionSheet.h`) and the example project to learn more.
