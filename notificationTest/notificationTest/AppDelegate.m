//
//  AppDelegate.m
//  notificationTest
//


#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>//1这个代理处理前台和后台的通知

@end

@implementation AppDelegate

//2在下面方法中，其他方法的话可能会错过通知
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;// 3center的代理赋值给object，合适的时候会调用代理方法
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"request success");
            [self setNotification];
        } else {
            NSLog(@"没有打开系统通知权限");
        }
    }];
    
    
    return YES;
}

-(void)setNotification{
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    //4用户可以随时改变app通知方式，发送通知时，获取一下app的通知设置
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.alertSetting == UNNotificationSettingEnabled) {
            //只有弹框
            [self setDetailNotificationWithType:@"1"];
        } else {
            //有声音和badge
            
        }
        
    }];
    
}

-(void)setDetailNotificationWithType:(NSString*)type
{
    if ([type isEqualToString:@"1"]) {
        //内容
        UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
        content.title = @"测试通知标题";
        content.body = @"测试通知内容";
        content.sound = [UNNotificationSound defaultSound];
        //content.sound = [UNNotificationSound soundNamed:@"MySound.aiff"];//自定义的通知声音
        
        //时间
        NSDateComponents * date = [[NSDateComponents alloc] init];
        
        date.weekday = 6;
        date.hour = 14;
        date.minute = 25;
        UNCalendarNotificationTrigger * trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:YES];
        //创建request
        
        UNNotificationRequest * notiRequest = [UNNotificationRequest requestWithIdentifier:@"IDENTIFIER" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notiRequest withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"标识为IDENTIFIER的通知添加成功");
            }
        }];
        
    } else {
        
    }
    
}
//app在前台
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"app在前台");
    completionHandler(UNNotificationPresentationOptionAlert);
}

//处理点击通知的动作
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"点击通知进来");
    completionHandler();
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
