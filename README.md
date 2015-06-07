# SKSpinner [![CI Status](https://travis-ci.org/TXF/SKSpinner.svg?branch=master)](https://travis-ci.org/TXF/SKSpinner) [![Version](https://img.shields.io/cocoapods/v/SKSpinner.svg?style=flat)](http://cocoapods.org/pods/SKSpinner) [![Platform](https://img.shields.io/cocoapods/p/SKSpinner.svg?style=flat)](http://cocoapods.org/pods/SKSpinner)
SKSpinner is an iOS control that displays a loader while tasks is being processed.

![SKSpinner](http://s16.postimg.org/gut0nypad/Spinner2.gif)
<!---
 [![License](https://img.shields.io/cocoapods/l/SKSpinner.svg?style=flat)](http://cocoapods.org/pods/SKSpinner)
-->

## Requirements

SKSpinner works on any iOS version and is compatible with ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* QuartzCore.framework

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add SKSpinner to your project.

1. Add a pod entry for SKSpinner to your Podfile `pod 'SKSpinner', '~> 0.1.1'`
2. Install the pod(s) by running `pod install`.
3. Include SKSpinner wherever you need it with `#import "SKSpinner.h"`.

### Source files

Alternatively you can directly add the `SKSpinner.h` and `SKSpinner.m` source files to your project.

1. Download the [latest code version](https://github.com/TXF/SKSpinner/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `SKSpinner.h` and `SKSpinner.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include SKSpinner wherever you need it with `#import "SKSpinner.h"`.

## Usage

(see sample Xcode project in `/Demo`)

The main guideline you need to follow when dealing with SKSpinner while running long-running tasks is keeping the main thread work-free, so the UI can be updated promptly. The recommended way of using SKSpinner is therefore to set it up on the main thread and then spinning the task, that you want to perform, off onto a new thread. 

```objective-c
[SKSpinner showTo:self.view animated:YES];
dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    // Do something...
dispatch_async(dispatch_get_main_queue(), ^{
    [SKSpinner hideAnimated:NO];
});
});
```

If you need to configure the spinner you can do this by using the SKSpinner reference that initWithView: returns. 

```objective-c
SKSpinner *spinner = [[SKSpinner alloc] initWithView:self.view];
spinner.minShowTime = 5.f;
spinner.color = [UIColor greenColor];
[spinner showAnimated:YES];
[self doSomethingInBackgroundWithProgressCallback:^(float progress) {
   // Do something...
} completionCallback:^{
    [spinner hideAnimated:YES];
}];
```

API documentation is provided in the header file (SKSpinner.h).

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 

