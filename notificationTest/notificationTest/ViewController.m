//
//  ViewController.m
//  notificationTest
//


#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    //5一个通知注册成功，除非到达条件触发了或者我们精准取消这个通知
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"IDENTIFIER"]];
}

@end
