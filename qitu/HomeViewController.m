//
//  HomeViewController.m
//  MakeMoney
//
//  Created by lvzx on 15/6/5.
//  Copyright (c) 2015年 YiGuang. All rights reserved.
//

#import "HomeViewController.h"
#import "MyEventVC.h"
#import "CreatorVC.h"
#import "PublicEventVC.h"

@interface HomeViewController ()<UITabBarControllerDelegate>
{
    NSInteger _preSelectedTabIndex;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)initUI
{
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      RGBCOLOR(139, 139, 139),
      NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      RGBCOLOR(83, 189, 173),
      NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"MyEvent" bundle:nil];
    MyEventVC *vc1 = [storyboard1 instantiateViewControllerWithIdentifier:@"MyEventVC"];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:TABBAR_BARITEM_FIRST_ICON] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:TABBAR_BARITEM_FIRST_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController * navi1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    
    UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Creator" bundle:nil];
    CreatorVC *vc2 = [storyboard2 instantiateViewControllerWithIdentifier:@"CreatorVC"];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"创作" image:[[UIImage imageNamed:TABBAR_BARITEM_SECOND_ICON] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:TABBAR_BARITEM_SECOND_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController * navi2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    UIStoryboard *storyboard3 = [UIStoryboard storyboardWithName:@"PublicEvent" bundle:nil];
    PublicEventVC *vc3 = [storyboard3 instantiateViewControllerWithIdentifier:@"PublicEventVC"];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"热门" image:[[UIImage imageNamed:TABBAR_BARITEM_THIRD_ICON] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:TABBAR_BARITEM_THIRD_SELECTED] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController * navi3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    
    self.viewControllers = @[navi1, navi2, navi3];
    self.tabBar.barTintColor = RGBCOLOR(247, 247, 247);
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    CATransition *ssa = [CATransition animation];
    ssa.duration = 0.3;
    ssa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ssa.type = kCATransitionPush;
    if (_preSelectedTabIndex < tabBarController.selectedIndex) {
        ssa.subtype = kCATransitionFromRight;
    }
    else
    {
        ssa.subtype = kCATransitionFromLeft;
    }
    ssa.removedOnCompletion = YES;
    UIView *ui = tabBarController.view.subviews[0];
    [ui.layer addAnimation:ssa forKey:nil];//给tabbarcontroller视图中内容视图添加动画
    _preSelectedTabIndex = tabBarController.selectedIndex;
}
@end
