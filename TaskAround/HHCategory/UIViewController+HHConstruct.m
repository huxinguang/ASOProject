//
//  UIViewController+Construct.m
//  BaseConstruct
//
//  Created by hxw on 2017/4/13.
//  Copyright © 2017年 hxw. All rights reserved.
//

#import "UIViewController+HHConstruct.h"
#import "HHWaitingHudView.h"
#import "HHRetryAlertView.h"
#import "HHTextAlertView.h"
#import <objc/runtime.h>

#define HUDT 0.2
#define TEXTINTERVAL 1.0

static char * const hudViewKey       = "hudViewKey";
static char * const textViewKey      = "textViewKey";
static char * const retryViewKey     = "retryViewKey";
static char * const loadSuperViewKey = "loadSuperViewKey";

static WaitHudMode hudMode;

@interface UIViewController ()

@property (nonatomic, strong) HHWaitingHudView *hudView;
@property (nonatomic, strong) HHTextAlertView  *textView;
@property (nonatomic, strong) HHRetryAlertView *retryView;

@end

@implementation UIViewController (HHConstruct)

#pragma mark hud业务逻辑
- (void)setHudView:(HHWaitingHudView *)hudView
{
    objc_setAssociatedObject(self, hudViewKey, hudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (HHWaitingHudView *)hudView
{
    return objc_getAssociatedObject(self, hudViewKey);
}

+ (void)registerWaitHudMode:(WaitHudMode)mode
{
    hudMode = mode;
}

- (void)showWaitHud
{
    [self showWaitHudOffset:0];
}
- (void)showWaitHud:(WaitHudMode)mode
{
    [self showWaitHud:mode Offset:0];
}
- (void)showWaitHudInView:(UIView *)view
{
    [self showWaitHudInView:view Offset:0];
}
- (void)showWaitHudInView:(UIView *)view mode:(WaitHudMode)mode
{
    [self showWaitHudInView:view mode:mode Offset:0];
}
- (void)showWaitHudOffset:(CGFloat)offset
{
    [self showWaitHud:hudMode Offset:offset];
}
- (void)showWaitHud:(WaitHudMode)mode Offset:(CGFloat)offset
{
    [self showWaitHudInView:self.view mode:mode Offset:offset];
}
- (void)showWaitHudInView:(UIView *)view Offset:(CGFloat)offset
{
    [self showWaitHudInView:view mode:hudMode Offset:offset];
}
- (void)showWaitHudInView:(UIView *)view mode:(WaitHudMode)mode Offset:(CGFloat)offset
{
    if (!view) return;
    if (self.hudView) {
        [self.hudView removeFromSuperview];
        self.hudView = nil;
    }
    self.hudView = [HHWaitingHudView hudView:mode Offset:offset];
    [view addSubview:self.hudView];
    view.userInteractionEnabled = NO;
    objc_setAssociatedObject(self, loadSuperViewKey, view,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideWaitHud
{
    if (!self.hudView) return;
    [UIView animateWithDuration:HUDT animations:^{
        self.hudView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hudView removeFromSuperview];
        self.hudView = nil;
        self.view.userInteractionEnabled = YES;
        UIView *loadSuperView = objc_getAssociatedObject(self, loadSuperViewKey);
        if (loadSuperView) {
            loadSuperView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark text业务逻辑
- (void)setTextView:(HHTextAlertView *)textView
{
    objc_setAssociatedObject(self, textViewKey, textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (HHTextAlertView *)textView
{
    return objc_getAssociatedObject(self, textViewKey);
}

- (void)showText:(NSString *)text
{
    [self showText:text Offset:0];
}
- (void)showText:(NSString *)text interval:(NSTimeInterval)interval
{
    [self showText:text interval:interval Offset:0];
}
- (void)showText:(NSString *)text inview:(UIView *)view
{
    [self showText:text inview:view interval:TEXTINTERVAL];
}
- (void)showText:(NSString *)text inview:(UIView *)view interval:(NSTimeInterval)interval
{
    [self showText:text inview:view interval:interval Offset:0];
}
- (void)showText:(NSString *)text Offset:(CGFloat)offset
{
    [self showText:text interval:TEXTINTERVAL Offset:offset];
}
- (void)showText:(NSString *)text inview:(UIView *)view Offset:(CGFloat)offset
{
    [self showText:text inview:view interval:TEXTINTERVAL Offset:offset];
}
- (void)showText:(NSString *)text interval:(NSTimeInterval)interval Offset:(CGFloat)offset
{
    [self showText:text inview:self.view interval:interval Offset:offset];
}
- (void)showText:(NSString *)text inview:(UIView *)view interval:(NSTimeInterval)interval Offset: (CGFloat)offset
{
    if (!view)return;
    [self hideText];
    self.textView = [HHTextAlertView textAlert:text interval:interval offset:offset];
    [view addSubview:self.textView];
}
- (void)hideText
{
    if (self.textView) {
        [self.textView removeFromSuperview];
        self.textView = nil;
    }
}

#pragma mark retryView业务逻辑
- (void)setRetryView:(HHRetryAlertView *)retryView
{
    objc_setAssociatedObject(self, retryViewKey, retryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (HHRetryAlertView *)retryView
{
    return objc_getAssociatedObject(self, retryViewKey);
}
- (void)showRetryView:(RetryViewInfo)retryViewInfo buttonClick:(retryEvent)block
{
    [self hideRetryView];
    self.retryView = [HHRetryAlertView retryView:retryViewInfo event:block];
    [self.view addSubview:self.retryView];
}
- (void)showRetryView:(RetryViewInfo)retryViewInfo below:(UIView *)view buttonClick:(retryEvent)block
{
    [self hideRetryView];
    self.retryView = [HHRetryAlertView retryView:retryViewInfo event:block];
    [self.view insertSubview:self.retryView belowSubview:view];
}
- (void)showRetryView:(RetryViewInfo)retryViewInfo above:(UIView *)view buttonClick:(retryEvent)block
{
    [self hideRetryView];
    self.retryView = [HHRetryAlertView retryView:retryViewInfo event:block];
    [view addSubview:self.retryView];
}
- (void)showRetryView:(RetryViewInfo)retryViewInfo inView:(UIView *)view buttonClick:(retryEvent)block
{
    if (self.retryView) return;
    self.retryView = [HHRetryAlertView retryView:retryViewInfo event:block];
    [view addSubview:self.retryView];
}
- (void)hideRetryView
{
    if (self.retryView) {
        [self.retryView removeFromSuperview];
        self.retryView = nil;
    }
}

- (void)showAlertController:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle otherAction:(void (^ _Nullable)(UIAlertAction *))handler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle)
    {
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancleAction];
    }
    if (otherTitle)
    {
        UIAlertAction * otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:handler];
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
    return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
