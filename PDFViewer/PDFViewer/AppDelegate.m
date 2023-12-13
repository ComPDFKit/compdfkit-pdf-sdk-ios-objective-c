//
//  AppDelegate.m
//  ComPDFKit
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//


#import "AppDelegate.h"

#import <ComPDFKit/ComPDFKit.h>

#if __has_include(<ComPDFKit_Tools/ComPDFKit_Tools.h>)
 #import <ComPDFKit_Tools/ComPDFKit_Tools.h>
#else
#import "ComPDFKit_Tools.h"
#endif

#import "CPDFViewController.h"
#import "XMLReader.h"

static AppDelegate *appDelegate = NULL;

@interface AppDelegate ()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *xmlFileString = [[NSBundle mainBundle] pathForResource:@"license_key_ios" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlFileString];
    NSError *error = nil;
    
    NSDictionary *result = [XMLReader dictionaryForXMLData:xmlData error:&error];
    if (error)
        NSLog(@"License key can not be empty.");
    
    if([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *license = [result objectForKey:@"license"];
        if([license isKindOfClass:[NSDictionary class]]) {
            NSDictionary * keysDic = license[@"key"];
            
            NSString * key = keysDic[@"text"];
            [CPDFKit verifyWithKey:key];
        }  else {
            NSLog(@"License key can not be empty.");
        }
    } else {
        NSLog(@"License key can not be empty.");
    }
    
    if (@available(iOS 13.0, *)) {
        
    } else {
        UIWindow *windows = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self configWindow:windows];

    }
    return YES;
}

- (void)configWindow:(UIWindow *)window {
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PDF32000_2008" ofType:@"pdf"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@", @"Documents",@"Samples"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:documentFolder] withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString * documentPath = [documentFolder stringByAppendingPathComponent:filePath.lastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:filePath] toURL:[NSURL fileURLWithPath:documentPath] error:nil];
    
    CPDFViewController *pdfViewController = [[CPDFViewController alloc] initWithFilePath:documentPath password:nil];
    CNavigationController *navController = [[CNavigationController alloc]initWithRootViewController:pdfViewController];

    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];

}

+ (AppDelegate *)sharedAppDelegate {
    if (!appDelegate)
        appDelegate = [[AppDelegate alloc] init];
    
    return appDelegate;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
