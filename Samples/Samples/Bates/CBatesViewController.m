//
//  CBatesViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CBatesViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to add and remove bates using API.
//-----------------------------------------------------------------------------------------

@interface CBatesViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *addCommonBatesURL;

@property (nonatomic, strong) NSURL *editBatesURL;

@property (nonatomic, strong) NSURL *deleteBatesURL;

@end

@implementation CBatesViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to add and remove bates codes.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)addCommonBates:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Insert common bates\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Bates"];
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddCommonBatesTest"];
    
    // Save the document in the test PDF file
    self.addCommonBatesURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addCommonBatesURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addCommonBatesURL];
    
    // Create common bates
    CPDFBates *bates = document.bates;
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:0];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [bates setFontSize:14.0 atIndex:0];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:1];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:1];
    [bates setFontSize:14.0 atIndex:1];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:2];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:2];
    [bates setFontSize:14.0 atIndex:2];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:3];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:3];
    [bates setFontSize:14.0 atIndex:3];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:4];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:4];
    [bates setFontSize:14.0 atIndex:4];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:5];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:5];
    [bates setFontSize:14.0 atIndex:5];
    bates.pageString = @"0-4";
    [bates update];
    
    // Print bates message
    for (int i = 0; i < 6; i++) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text: %@\n", [bates textAtIndex:i]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n\n", [self getStringFromEnumLocation:i]];
    }
    
    [document writeToURL:self.addCommonBatesURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddCommonBatesTest.pdf\n"];
}

- (void)editBates {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Edit common bates\n"];
    
    // Save a document in Sandbox
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Bates"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"Bates",@"AddCommonBatesTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EditBatesTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    self.editBatesURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.editBatesURL];
    
    // Edit dates message
    CPDFBates *bates = document.bates;
    [bates setText:@"<<#3#5#ComPDFKit-#-ComPDFKit>>" atIndex:0];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [bates setFontSize:14.0 atIndex:0];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:1];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:1];
    [bates setFontSize:14.0 atIndex:1];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:2];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:2];
    [bates setFontSize:14.0 atIndex:2];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:3];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:3];
    [bates setFontSize:14.0 atIndex:3];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:4];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:4];
    [bates setFontSize:14.0 atIndex:4];
    [bates setText:@"<<#3#5#Prefix-#-Suffix>>" atIndex:5];
    [bates setTextColor:[CPDFKitPlatformColor redColor] atIndex:5];
    [bates setFontSize:14.0 atIndex:5];
    bates.pageString = @"0-4";
    [bates update];
    
    for (int i = 0; i < 3; i++) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text: %@\n", [bates textAtIndex:i]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n\n", [self getStringFromEnumLocation:i]];
    }
    
    [document writeToURL:self.editBatesURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EditBatesTest.pdf\n"];
}

- (void)deleteBates {
//     DeleteBatesTest
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3: Delete common bates\n"];
    
    // Save a document in Sandbox
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Bates"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"Bates",@"AddCommonBatesTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteBatesTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    self.deleteBatesURL = [NSURL fileURLWithPath:writeFilePath];
     CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteBatesURL];
    
    CPDFBates *bates = document.bates;
    [bates clear];
    
    [document writeToURL:self.deleteBatesURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DeleteBatesTest.pdf\n"];
}

- (NSString *)getStringFromEnumLocation:(NSInteger)enums {
    switch (enums) {
        case 0:
            return @"Top Left";
            break;
        case 1:
            return @"Top Middle";
            break;
        case 2:
            return @"Top Right";
            break;
        case 3:
            return @"Button Left";
            break;
        case 4:
            return @"Button Middle";
            break;
        case 5:
            return @"Button Right";
            break;
        default:
            return @" ";
            break;
    }
}

- (void)openFileWithURL:(NSURL *)url {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityVC.definesPresentationContext = YES;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        activityVC.popoverPresentationController.sourceView = self.openfileButton;
        activityVC.popoverPresentationController.sourceRect = self.openfileButton.bounds;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {

        if (completed) {
            NSLog(@"Success!");
        } else {
            NSLog(@"Failed Or Canceled!");
        }
    };
}

#pragma mark - Action

- (IBAction)buttonItemClick_openFile:(id)sender {
    // Determine whether to export the document
    if (self.isRun) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose a file to open...", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            alertController.popoverPresentationController.sourceView = self.openfileButton;
            alertController.popoverPresentationController.sourceRect = self.openfileButton.bounds;
        }
        
        UIAlertAction *addCommonBatesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddCommonBatesTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddCommonBatesTest.pdf
            [self openFileWithURL:self.addCommonBatesURL];
        }];
        UIAlertAction *editBatesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EditBatesTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EditBatesTest.pdf
            [self openFileWithURL:self.editBatesURL];
        }];
        UIAlertAction *deleteBatesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteBatesTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteBatesTest.pdf
            [self openFileWithURL:self.deleteBatesURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:addCommonBatesAction];
        [alertController addAction:editBatesAction];
        [alertController addAction:deleteBatesAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:NO completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose a file to open...", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            alertController.popoverPresentationController.sourceView = self.openfileButton;
            alertController.popoverPresentationController.sourceRect = self.openfileButton.bounds;
        }
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No files for this sample.", nil) style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:noAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

- (IBAction)buttonItemClick_run:(id)sender {
    if (self.document) {
        self.isRun = YES;
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running Bates sample...\n\n"];
        [self addCommonBates:self.document];
        [self editBates];
        [self deleteBates];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\nDone!\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        
        // Refresh commandline message
        self.commandLineTextView.text = self.commandLineStr;
    } else {
        self.isRun = NO;
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"The document is null, can't open..\n\n"];
        self.commandLineTextView.text = self.commandLineStr;
    }
}

@end
