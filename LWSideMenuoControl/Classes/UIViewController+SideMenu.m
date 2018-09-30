//
//  UIViewController+SideMenu.m
//  tabbarApp
//
//  Created by CPX on 2018/9/30.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "UIViewController+SideMenu.h"
#import <objc/runtime.h>
#define MAXSPEED 800





@implementation UIViewController (SideMenu)

-(void)setLeftSideMenuController:(UIViewController *)leftSideController
                       attribute:(NSDictionary *)attr{
    self.sideMenuView = leftSideController.view;
    
    self.sideAttr = attr;
    [self cofigViews];
    [self addGestureRecognizer];
    [self addChildViewController:leftSideController];

    
}

-(void)cofigViews{
    self.maskView =  [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIView  * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.maskView];
    NSAssert(window, @"*********************window 为nil。请在window已经创建好再调用setLeftSideMenuController:attribute:方法");
    
    UIColor  * maskColor = [self.sideAttr objectForKey:k_mask_color_key];
    float width_side = [[self.sideAttr objectForKey:k_Menu_width_key]  floatValue];
    self.maskView.backgroundColor = maskColor;
    self.maskView.alpha = 0;
    CGRect rect_side = CGRectMake(0, 0, width_side, window.frame.size.height);
    self.sideMenuView.frame = rect_side;
    [window addSubview:self.sideMenuView];
    //默认隐藏到左边
    self.sideMenuView.transform = CGAffineTransformMakeTranslation(-width_side, 0);
    self.sideMenuView.userInteractionEnabled = YES;
    self.maskView.userInteractionEnabled = YES;
    

    
    
}
#pragma mark ---设置手势
-(void)addGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewOnTap:)];
    [self.maskView addGestureRecognizer:tap];
    tap.delegate = self;
    UIPanGestureRecognizer  * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanGesture:)];
    [self.maskView addGestureRecognizer:pan];
    pan.delegate = self;

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRecognizer:)];
    swipeGesture.delegate = self;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:swipeGesture];
    
    tap.enabled = NO;
    pan.enabled = NO;
    swipeGesture.enabled = YES;
    
    
    
    
}
-(void)showLeftSideMenuView:(BOOL)animation{
    [self.maskView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
            obj.enabled = NO;
        }
        obj.enabled = YES;
    }];// 开启手势

    if(animation){
        [UIView animateWithDuration:0.2 animations:^{
            self.sideMenuView.transform = CGAffineTransformIdentity;
            self.maskView.alpha = 1;
        }];
    }
    else{
        self.sideMenuView.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1;
    }
}
- (void)hideLeftSideMenuView:(BOOL)animation comletion:(nonnull void (^)(BOOL finish))comletion{
    [self.maskView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
            obj.enabled = YES;
        }
        obj.enabled = NO;
    }];// 关闭手势
    float width_side = [[self.sideAttr objectForKey:k_Menu_width_key]  floatValue];

    if (animation){
        [UIView animateWithDuration:0.3 animations:^{
            self.sideMenuView.transform = CGAffineTransformMakeTranslation(-width_side, 0);
            self.maskView.alpha = 0;

            
        } completion:comletion];
    }
    else{
        self.sideMenuView.transform = CGAffineTransformMakeTranslation(-width_side, 0);
        self.maskView.alpha = 0;
        if(comletion){
            comletion(YES);
        }
    }
}
-(void)removeLeftSideMenuView:(BOOL)animation{
    [self hideLeftSideMenuView:animation comletion:^(BOOL finish) {
        [self.maskView removeFromSuperview];
        [self.sideMenuView removeFromSuperview];
        
    }];
}

-(void)maskViewOnTap:(UITapGestureRecognizer * )sender{
    [self hideLeftSideMenuView:YES comletion:nil];
}

-(void)onPanGesture:(UIPanGestureRecognizer *)sender{
    UIGestureRecognizerState state = [sender state];
    float width_side = [[self.sideAttr objectForKey:k_Menu_width_key]  floatValue];

    
    CGPoint translate =  [sender translationInView:sender.view];
    if (translate.x>=0){
        [sender setTranslation:CGPointZero inView:sender.view];
        return;
    }

    float progress = -translate.x/width_side;
    
//    NSLog(@"translate --- %@",NSStringFromCGPoint(translate));
    self.sideMenuView.transform  = CGAffineTransformMakeTranslation(translate.x,0);
    self.maskView.alpha = 1 - progress;
    
    if (progress<0.5){
        //没有滑动到需要收起的位置，回复位置
        if (state == UIGestureRecognizerStateEnded){
            [self showLeftSideMenuView:YES];
        }
    }
    else{
        if (state == UIGestureRecognizerStateEnded){
            [self hideLeftSideMenuView:YES comletion:nil];
        }
    }
}
-(void)handleSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    if (point.x < 20){
        [self showLeftSideMenuView:YES];

    }


  
    
    
    
}



#pragma mark ----- property extension
static char menuViewKey;
-(UIView*)sideMenuView{
    UIView * view = objc_getAssociatedObject(self, &menuViewKey);
    return view;
}
-(void)setSideMenuView:(UIView *)sideMenuView{
    objc_setAssociatedObject(self, &menuViewKey, sideMenuView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
static char sideProfileKey;
-(NSDictionary *)sideAttr{
    return objc_getAssociatedObject(self, &sideProfileKey);
}
-(void)setSideAttr:(NSDictionary *)sideAttr{
    objc_setAssociatedObject(self, &sideProfileKey, sideAttr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
static char maskViewKey;
-(UIView *)maskView
{
    return objc_getAssociatedObject(self, &maskViewKey);
}
-(void)setMaskView:(UIView *)maskView{
    objc_setAssociatedObject(self, &maskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}



@end
