//
//  UIViewController+SideMenu.h
//  tabbarApp
//
//  Created by CPX on 2018/9/30.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const k_Menu_width_key = @"k_Menu_width_key";//侧边宽度
static NSString *const k_mask_color_key = @"k_mask_color_key";//c非侧边部分背景色



/**
 侧边栏方向

 - SideMenuDirection_left: 左边出来、
 - SideMenuDirection_right: 右边出来
 */
typedef NS_ENUM(NSInteger,SideMenuDirection) {
    SideMenuDirection_left = 0,
    SideMenuDirection_right
};




NS_ASSUME_NONNULL_BEGIN



/**
 毫无入侵性的侧边栏,,,支持从左边滑出、划入隐藏、点击隐藏侧边
 author:王连友
 */
@interface UIViewController (SideMenu)<UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSDictionary  * sideAttr;/**<配置参数 */
/**
 侧边栏view
 */
@property (nonatomic,strong)UIView * sideMenuView;


/**
 蒙版view 黑色配置
 */
@property (nonatomic,strong)UIView * maskView;

@property (nonatomic,assign)BOOL isShowOn;/**<是否展开*/

@property (nonatomic,assign)SideMenuDirection direction;/**<方向*/







/**
 设置左边的菜单页(注意只能设置一次。。避免内存释放不掉)

 @param leftSideController 左边控制器
 @param attr 参数配置
 */
-(void)setSideMenuController:(UIViewController *)sideController
           sideMenuDirection:(SideMenuDirection)direction
                       attribute:(NSDictionary *)attr;



/**
 显示出侧边栏

 @param animation animation description
 */
-(void)showSideMenuView:(BOOL)animation;



/**
  隐藏侧边栏

 @param animation 动画
 @param comletion 隐藏完毕
 */
-(void)hideSideMenuView:(BOOL)animation comletion:(void(^)(BOOL finish))comletion;


/**
 移除侧边栏

 @param animation <#animation description#>
 */
-(void)removeSideMenuView:(BOOL)animation;




@end

NS_ASSUME_NONNULL_END
