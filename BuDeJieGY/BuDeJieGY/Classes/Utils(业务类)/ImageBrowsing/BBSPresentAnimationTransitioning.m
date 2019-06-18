//
//  BBSPresentAnimationTransitioning.m
//  ImageBrowsingImitateWeChat
//
//  Created by 李子栋 on 2018/3/9.
//  Copyright © 2018年 李子栋. All rights reserved.
//

#import "BBSPresentAnimationTransitioning.h"
//#import "ViewController.h"  // gaoyuan
#import "BBSImageBrowsingController.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN
@interface BBSPresentAnimationTransitioning ()

@property (nonatomic, assign) BBSPresentAnimationTransitioningType type;
@property (weak, nonatomic) UIImageView *animationImageView;

@end

NS_ASSUME_NONNULL_END

@implementation BBSPresentAnimationTransitioning
// gaoyuan
//- (instancetype)initWithTransitionType:(BBSPresentAnimationTransitioningType)type {
- (instancetype)initWithTransitionType:(BBSPresentAnimationTransitioningType)type animationImageView:(UIImageView*)animationImageView{
    self = [super init];
    if (self) {
        self.type = type;
        // gaoyuan
       self.animationImageView = animationImageView;
    }
    return self;
}
// gaoyuan
//+ (instancetype)transitionWithTransitionType:(BBSPresentAnimationTransitioningType)type {
+ (instancetype)transitionWithTransitionType:(BBSPresentAnimationTransitioningType)type animationImageView:(UIImageView*)animationImageView {
    return [[BBSPresentAnimationTransitioning alloc] initWithTransitionType:type animationImageView:animationImageView];
}

//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}
//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (self.type) {
        case BBSPresentAnimationTransitioningTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case BBSPresentAnimationTransitioningTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

//实现present动画逻辑代码

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    BBSImageBrowsingController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    

    UIView *containerView = [transitionContext containerView];
    UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = _animationImageView.image;
    tempImageView.clipsToBounds = YES;
    tempImageView.backgroundColor = [UIColor clearColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempImageView];
    tempImageView.frame = [_animationImageView convertRect:_animationImageView.bounds toView:fromVC.view];
    fromVC.view.hidden = YES;
    toVC.view.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         tempImageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*_animationImageView.image.size.height/_animationImageView.image.size.width);
                         tempImageView.center = toVC.view.center;
                     }
                     completion:^(BOOL finished) {
                         //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         tempImageView.hidden = YES;
                         toVC.view.hidden =  NO;
                         fromVC.view.hidden = NO;
                         [tempImageView removeFromSuperview];
                         //转场失败后的处理
                         if ([transitionContext transitionWasCancelled]) {
                             //失败后，我们要把vc1显示出来
                             fromVC.view.hidden = NO;
                         }
                     }];
}

//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    BBSImageBrowsingController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // gaoyuan
    //ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSLog(@"%@ -- %p", NSStringFromCGRect(_animationImageView.frame), toVC);

    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    UIImageView *tempImageView = [UIImageView new];
    // gaoyuan
    tempImageView.image = fromVC.showImageView.image;
    tempImageView.clipsToBounds = YES;
    tempImageView.backgroundColor = [UIColor clearColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:tempImageView];
    tempImageView.frame = fromVC.showImageView.frame;
    fromVC.view.alpha = 1;
    // gaoyuan
    //toVC.animationImageView.hidden = YES;
    _animationImageView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         tempImageView.frame = [_animationImageView convertRect:_animationImageView.bounds toView:toVC.view];
                         fromVC.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         //转场失败后的处理
                         if (![transitionContext transitionWasCancelled]) {
                             [tempImageView removeFromSuperview];
                             _animationImageView.hidden = NO;
                         }
                     }];
}

/*
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    BBSImageBrowsingController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // gaoyuan
    ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
 
    UIView *containerView = [transitionContext containerView];
//    containerView.backgroundColor = [UIColor blackColor];
    UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = fromVC.animationImageView.image;
    tempImageView.clipsToBounds = YES;
    tempImageView.backgroundColor = [UIColor clearColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempImageView];
    tempImageView.frame = [fromVC.animationImageView convertRect:fromVC.animationImageView.bounds toView:fromVC.view];
    fromVC.view.hidden = YES;
    toVC.view.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         tempImageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*fromVC.animationImageView.image.size.height/fromVC.animationImageView.image.size.width);
                         tempImageView.center = toVC.view.center;
    }
                     completion:^(BOOL finished) {
                         //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         tempImageView.hidden = YES;
                         toVC.view.hidden =  NO;
                         fromVC.view.hidden = NO;
                         [tempImageView removeFromSuperview];
                         //转场失败后的处理
                         if ([transitionContext transitionWasCancelled]) {
                             //失败后，我们要把vc1显示出来
                             fromVC.view.hidden = NO;
                         }
                     }];
}
*/
/*
//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是vc1、fromVC就是vc2
    BBSImageBrowsingController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    NSLog(@"%@ -- %p", NSStringFromCGRect(_animationImageView.frame), toVC);
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    UIImageView *tempImageView = [UIImageView new];
    tempImageView.image = fromVC.showImageView.image;
    tempImageView.clipsToBounds = YES;
    tempImageView.backgroundColor = [UIColor clearColor];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:tempImageView];
    tempImageView.frame = fromVC.showImageView.frame;
    fromVC.view.alpha = 1;
    // gaoyuan
    //toVC.animationImageView.hidden = YES;
    _animationImageView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         tempImageView.frame = [toVC.animationImageView convertRect:toVC.animationImageView.bounds toView:toVC.view];
                         fromVC.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         //转场失败后的处理
                         if (![transitionContext transitionWasCancelled]) {
                             [tempImageView removeFromSuperview];
                             toVC.animationImageView.hidden = NO;
                         }
                     }];
}
*/
@end
