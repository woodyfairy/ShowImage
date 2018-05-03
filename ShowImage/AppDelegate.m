//
//  AppDelegate.m
//  ShowImage
//
//  Created by 吴冬炀 on 2018/4/17.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowImageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSMutableArray *arrayImages = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"imgs"];
    NSError *err = nil;
    NSArray *arrSubFiles = [[fileManager contentsOfDirectoryAtPath:dir error:&err] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *fullName1 = (NSString *)obj1;
        NSString *name1 = fullName1;
        //        if ([fullName1 componentsSeparatedByString:@"."].count > 0) {
        //            name1 = [fullName1 componentsSeparatedByString:@"."].firstObject;
        //        }
        NSString *fullName2 = (NSString *)obj2;
        NSString *name2 = fullName2;
        //        if ([fullName2 componentsSeparatedByString:@"."].count > 0) {
        //            name2 = [fullName2 componentsSeparatedByString:@"."].firstObject;
        //        }
        if (name1.intValue < name2.intValue) {
            return NSOrderedAscending;
        }else if (name1.intValue > name2.intValue){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    if (err) {
        NSLog(@"ERROR:%@", err.description);
    }else{
        for (NSString *fileName in arrSubFiles) {
            NSString *subPath = [dir stringByAppendingPathComponent:fileName];
            UIImage *image = [UIImage imageWithContentsOfFile:subPath];
            if (image) {
                [arrayImages addObject:image];
            }else{
                NSLog(@"image is nil: %@", subPath);
            }
        }
    }
    
    ShowImageViewController *vc = [[ShowImageViewController alloc] initWithImageArray:arrayImages];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
