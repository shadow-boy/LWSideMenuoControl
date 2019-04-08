//
//  FirstViewController.m
//  LWSideMenuoControl
//
//  Created by CPX on 2018/10/1.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "FirstViewController.h"
#import "UIViewController+SideMenu.h"
#import "thirdViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    thirdViewController * vc = [[thirdViewController alloc]init];
    [self setSideMenuController:vc sideMenuDirection:SideMenuDirection_right attribute:@{k_Menu_width_key:@(200),k_mask_color_key:[[UIColor blackColor] colorWithAlphaComponent:0.2]}];

}
- (IBAction)show:(id)sender {
    
    
    [self showSideMenuView:YES];
    
}


@end
