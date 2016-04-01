//
//  AppMacro.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

/*--------------------------------开发中常用到的宏定义--------------------------------------*/

//系统目录
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//----------设备系统相关---------

#define kFirstLaunch     kAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define kFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行

//设备相关
#define isIPad              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


//系统版本和当前系统语言
#define kIsiOS7 [[[UIDevice currentDevice] systemVersion] floatValue] == 7.0
#define kIOS8_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define kSystemVersion      ([[UIDevice currentDevice] systemVersion])
#define kCurrentLanguage    ([[NSLocale preferredLanguages] objectAtIndex:0])


//应用名称和版本
#define kAPPName            [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPPVersion         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


//appStore相关(App Id、评论地址、更新地址、下载地址)
#define kAppId      @"593499239"
#define kAPPCommentUrl      @"itms-apps://itunes.apple.com/app/id%d"
#define kAPPUpdateUrl       @"http://itunes.apple.com/lookup?id=%d"
#define kAppUrl     [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ling-hao-xian/id%@?ls=1&mt=8",kAppId]


//设备屏幕尺寸
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)


//--------调试相关-------

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define mSafeRelease(object)     [object release];  x=nil
#endif

//调试模式下输入NSLog，发布后不再输入。
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#if kTargetOSiPhone
//iPhone Device
#endif

#if kTargetOSiPhoneSimulator
//iPhone Simulator
#endif

//----------方法简写-------
//应用委托
#define kAppDelegate        ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define kKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//Block self
#define WEAKSELF    __weak          typeof(self)  weakSelf = self;
#define STRONGSELF  __strong        typeof(weakSelf) strongSelf = weakSelf;

//以tag读取View
#define kViewByTag(parentView, tag, Class)  (Class *)[parentView viewWithTag:tag]

//读取CellXib文件的类
#define kCellByNib(ClassNameStr, myOwner, index) [[NSBundle mainBundle] loadNibNamed:ClassNameStr owner:myOwner options:nil][index];
//#define kCellByNib(ClassName, owner, index) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ClassName class]) owner:owner options:nil] objectAtIndex:index]

#define kViewByNib(ClassName)   [[ClassName alloc] initWithNibName:NSStringFromClass([ClassName class]) bundle:nil]

//加载图片
#define kImageByName(name)        [UIImage imageNamed:name]
#define kImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]

//id对象与NSData之间转换
#define kObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define kDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian*180.0) / (M_PI)

//颜色
#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//rgb颜色转换（16进制->10进制）
#define kRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
//16进制转UIColor
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
//G－C－D
#define kGCDBackground(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kGCDMain(block)       dispatch_async(dispatch_get_main_queue(),block)

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


#endif /* AppMacro_h */
