//
//  SKSpinner.h
//  Version 0.0.1
//  Created by David N on 5/15/15.

#import "SKSpinner.h"

#define SPINNER_RADIUS 20
#define CIRCLE_SIZE 4

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

static SKSpinner *_spinner;

@interface SKSpinner() {
    NSMutableArray *_circles;
    NSMutableArray *_layers;
    NSArray*_timeFunctions;
    UIBezierPath *_animationPath;
    NSTimer *_reloadTimer;
    NSDate *_spinnerShowTime;
    NSTimer *_minShowTimer;
}
@end

@implementation SKSpinner

#pragma mark - Class methods


+ (void)showTo:(UIView *)view animated:(BOOL)animated
{
    _spinner = [[SKSpinner alloc]initWithView:view];
    [_spinner showAnimated:animated];
}

+ (void)hideAnimated:(BOOL)animated
{
    [_spinner hideAnimated:animated];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Must use initWithView: instead" userInfo:nil];
}

- (instancetype)initWithView:(UIView *)view
{
    NSAssert(view, @"View must not be nil.");
    if(self = [super init]) {
        _timeFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.74 :0.18: 0: 0.76],
                           [CAMediaTimingFunction functionWithControlPoints:0.74 :0.18 :0 :0.82],
                           [CAMediaTimingFunction functionWithControlPoints:0.74 :0.18 :0 :0.88],
                           [CAMediaTimingFunction functionWithControlPoints:0.74 :0.18 :0 :0.94]];
        self.color = [UIColor whiteColor];
        self.minShowTime = .0;
        self.radius = SPINNER_RADIUS;
        self.alpha = .0;
        self.frame = CGRectMake(CGRectGetMidX(view.frame) - SPINNER_RADIUS, CGRectGetMidY(view.frame) - SPINNER_RADIUS, 2 * SPINNER_RADIUS, 2 * SPINNER_RADIUS);
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [view addSubview:self];
        [self registerForNotifications];
    }
    return self;
}

- (void)showAnimated:(BOOL)animated
{
    NSAssert(self.superview, @"Spinner superview is not defined");
    [self setupCircleLayers];
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        [UIView commitAnimations];
    } else {
        self.alpha = 1.0f;
    }
    _spinnerShowTime = [NSDate date];
    [self prepareForAnimation];
}

- (void)hideAnimated:(BOOL)animated
{
    if(_minShowTimer.isValid)
        return;
    if (_minShowTime > 0.0) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:_spinnerShowTime];
        if (interv < self.minShowTime)
            _minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv)
                                                             target:self
                                                           selector:@selector(handleMinShowTimer:)
                                                           userInfo:@(animated) repeats:NO];
        else {
            _minShowTime = .0;
            [self hideAnimated:animated];
        }
    }
    else if (animated) {
        [UIView animateWithDuration:0.30 animations: ^{
            self.alpha = 0.02f;
        }
        completion:^(BOOL completed)
        {
            [self remove];
        }];
    } else {
        self.alpha = 0.0f;
        [self remove];
    }
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hideAnimated:animated];
    });
}

- (void)handleMinShowTimer:(NSTimer *)theTimer
{
    _minShowTime = .0;
    _minShowTimer = nil;
    BOOL animated = [theTimer.userInfo boolValue];
    [self hideAnimated:animated];
}

- (void)setupCircleLayers
{
    _circles = [NSMutableArray new];
    _layers = [NSMutableArray new];
    CGFloat circleSize = CIRCLE_SIZE;
    for (uint8_t i = 0;i < 8;i++) {
        CALayer *circle = [CALayer layer];
        CGPoint p = CGPointMake(self.radius, 0);
        circle.frame = CGRectMake(0, 0, circleSize, circleSize);
        circle.position = p;
        circle.cornerRadius = circleSize / 2.0;
        [circle setMasksToBounds:YES];
        circle.backgroundColor = self.color.CGColor;
        if (i < 4) {
            [self.layer addSublayer:circle];
            [_circles addObject:circle];
        }
        circleSize = i==3?CIRCLE_SIZE:circleSize + 1.2;
        [_layers addObject:circle];
    }
}

- (void)prepareForAnimation
{
    _animationPath = [UIBezierPath bezierPath];
    [_animationPath addArcWithCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle: -M_PI_2 endAngle:3 * M_PI_2 clockwise:YES];
    [self startAnimation];
    _reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                    target:self
                                                  selector:@selector(reloadAnimation)
                                                  userInfo:nil repeats:YES];
}

- (void)startAnimation
{
    CFTimeInterval delay = 0.0;
    CFTimeInterval duration = 1.8;
    for(uint8_t i = 0;i < 4;i++) {
        CALayer *circle = _circles[i];
        //Create scale animation
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.duration = duration;
        if (i == 0) {
            scaleAnimation.keyTimes = @[@0, @0.55, @0.65, @0.8, @1];
            float originalSize = CIRCLE_SIZE / CGRectGetWidth(circle.frame);
            
            CALayer *lastCircle = _circles.lastObject;
            float midSize = CGRectGetWidth(lastCircle.frame) / CIRCLE_SIZE;
            float maxSize = (CGRectGetWidth(lastCircle.frame) + 2) / CIRCLE_SIZE;
            scaleAnimation.values = @[@1,
                                      [NSNumber numberWithFloat:originalSize],
                                      [NSNumber numberWithFloat:midSize],
                                      [NSNumber numberWithFloat:maxSize],
                                      [NSNumber numberWithFloat:midSize]];
        } else {
            scaleAnimation.keyTimes = @[@0, @0.4];
            float originalSize = CIRCLE_SIZE / CGRectGetWidth(circle.frame);
            scaleAnimation.values = @[@1,[NSNumber numberWithFloat:originalSize]];
        }
        //Create rotation animation
        CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        rotationAnimation.path = _animationPath.CGPath;
        rotationAnimation.rotationMode = kCAAnimationRotateAuto;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.timingFunction = _timeFunctions[i];
        rotationAnimation.duration = duration;
        
        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        group.animations = @[rotationAnimation,scaleAnimation];
        group.removedOnCompletion = NO;
        group.duration = duration;
        group.fillMode = kCAFillModeBackwards;
        group.beginTime = CACurrentMediaTime() + delay;
        [circle addAnimation:group forKey:nil];
        delay += 0.09;
        duration -= 0.06;
    }
}

- (void)reloadAnimation
{
    static BOOL flag = YES;
    
    NSArray *circlesToRemove = flag?[_layers subarrayWithRange:NSMakeRange(0, 4)]:[_layers subarrayWithRange:NSMakeRange(4, 4)];
    NSArray *circlesToInsert = flag?[_layers subarrayWithRange:NSMakeRange(4, 4)]:[_layers subarrayWithRange:NSMakeRange(0, 4)];
    _circles = [circlesToInsert mutableCopy];
    [self startAnimation];
    for(uint8_t i = 0;i < 4;i++)
    {
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            CALayer *circle = circlesToInsert[i];
            [weakSelf.layer addSublayer:circle];
            circle = circlesToRemove[i];
            [circle removeFromSuperlayer];
            [circle removeAllAnimations];
        });
    }
    flag = !flag;
}

- (void)remove
{
    self.alpha = 0.f;
    [_reloadTimer invalidate];
    [self removeFromSuperview];
    _reloadTimer = nil;
    _spinner = nil;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = MIN(radius,30);
    CGRect rect = self.superview.frame;
    self.frame = CGRectMake(CGRectGetMidX(rect) - _radius, CGRectGetMidY(rect) - _radius, 2 * _radius, 2 * _radius);
}

- (void)didMoveToSuperview
{
    [self updateForCurrentOrientationAnimated:NO];
}

#pragma mark - Notifications


- (void)registerForNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification
             object:nil];
}

- (void)unregisterFromNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    } else {
        [self updateForCurrentOrientationAnimated:YES];
    }
}

- (void)updateForCurrentOrientationAnimated:(BOOL)animated
{
    //No transforms applied to window in iOS 8, but only if compiled with iOS 8 sdk as base sdk, otherwise system supports old rotation logic.
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    // Only needed pre iOS 7 when added to a window
    BOOL iOS8OrLater = kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0;
    if (iOS8OrLater || ![self.superview isKindOfClass:[UIWindow class]]) return;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
        else { radians = (CGFloat)M_PI_2; }
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
        else { radians = 0; }
    }
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    [self setTransform:rotationTransform];
    if (animated) {
        [UIView commitAnimations];
    }
#endif
}

- (void)dealloc
{
    [self unregisterFromNotifications];
}
@end
