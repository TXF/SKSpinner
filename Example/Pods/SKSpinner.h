//
//  SKSpinner.h
//  Version 0.0.1
//  Created by David N on 5/15/15.

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2009-2015 David N
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface SKSpinner : UIView
/**
 * Creates a new Spinner, adds it to provided view and shows it.
 *
 * @param view The view that the Spinner will be added to
 * @param animated If set to YES the Spinner will appear using fade animation. If set to NO the Spinner will not use
 * animation while appearing.
 */
+ (void)showTo:(UIView *)view animated:(BOOL)animated;

/**
 * Removes Spinner from the parent view. The counterpart to this method is showTo:animated:.
 *
 * @param animated If set to YES the Spinner will disappear using fade animation. If set to NO the fade animation will not use animation while disappearing.
 *
 * @see showTo:animated:
 */
+ (void)hideAnimated:(BOOL)animated;

/**
 * A convenience constructor that initializes the Spinner to present it on the view. 
 *
 * @param view The view instance where the Spinner will be placed on. Should be the same instance as
 * the Spinner's superview (i.e., the view that the Spinner will be added to).
 * @return A reference to the created Spinner.
 */
- (instancetype)initWithView:(UIView *)view;

/**
 * Display the Spinner. Call this method when your task is already set-up to be executed in a new thread
 * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
 *
 * @param animated If set to YES the Spinner. Call will appear using fade animation. If set to NO Spinner will not use
 * animation while disappearing.
 */
- (void)showAnimated:(BOOL)animated;

/**
 * Hide the Spinner.This is the counterpart of the showTo: method. Use it to hide the Spinner when your task completes.
 *
 * @param animated If set to YES the Spinner will disappear using fade animation. If set to NO Spinner will not use
 * animation while disappearing.
 */
- (void)hideAnimated:(BOOL)animated;

/**
 * Hide the Spinner after a delay. This is the counterpart of the showTo: method. Use it to
 * hide the Spinner when your task completes.
 *
 * @param animated If set to YES the Spinner will disappear using fade animation. If set to NO Spinner will not use
 * animation while disappearing.
 * @param delay Delay in seconds until the Spinner is hidden.
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * The color of the Spinner circles. Default to white.
 */
@property (nonatomic,strong) UIColor *color;

/**
 * The minimum time (in seconds) that the Spinner is shown.
 * This avoids the problem of the Spinner being shown and than instantly hidden.
 * Defaults to 0 (no minimum show time).
 */
@property (nonatomic,assign) NSTimeInterval minShowTime;

/**
* Spinner circle radius.
* Defaults to 20.
*/
@property (nonatomic,assign) CGFloat radius;

@end
