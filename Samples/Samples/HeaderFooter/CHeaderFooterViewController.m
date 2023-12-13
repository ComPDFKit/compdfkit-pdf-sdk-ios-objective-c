//
//  CHeaderFooterViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//


#import "CHeaderFooterViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to add and remove header footer using API.
//-----------------------------------------------------------------------------------------

@interface CHeaderFooterViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *addCommonHeaderFooterURL;

@property (nonatomic, strong) NSURL *addPageHeaderFooterURL;

@property (nonatomic, strong) NSURL *editHeaderFooterURL;

@property (nonatomic, strong) NSURL *deleteHeaderFooterURL;

@end

@implementation CHeaderFooterViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to add and remove headers and footers.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)addCommonHeaderFooter:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Insert common header footer\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"HeaderFoooter"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddCommonHeaderFooterTest"];
    
    // Save the document in the test PDF file
    self.addCommonHeaderFooterURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addCommonHeaderFooterURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addCommonHeaderFooterURL];
    
    // Create text header footer
    CPDFHeaderFooter *headerFooter = document.headerFooter;
    [headerFooter setText:@"ComPDFKit" atIndex:0];
    [headerFooter setText:@"ComPDFKit" atIndex:1];
    [headerFooter setText:@"ComPDFKit" atIndex:2];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [headerFooter setFontSize:14.0 atIndex:0];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:1];
    [headerFooter setFontSize:14.0 atIndex:1];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:2];
    [headerFooter setFontSize:14.0 atIndex:2];
    headerFooter.pageString = @"0-4";
    
    [headerFooter update];
    
    // Print header footer object message
    for (int i = 0; i < 3; i++) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text: %@\n", [headerFooter textAtIndex:i]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n\n", [self getStringFromEnumLocation:i]];
    }
    
    [document writeToURL:self.addCommonHeaderFooterURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddCommonHeaderFooterTest.pdf\n"];
}

- (void)addPageHeaderFooter:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Insert page header footer\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"HeaderFoooter"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddPageHeaderFooterTest"];
    
    // Save the document in the test PDF file
    self.addPageHeaderFooterURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addPageHeaderFooterURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addPageHeaderFooterURL];
    
    // Create page header footer
    CPDFHeaderFooter *headerFooter = document.headerFooter;
    [headerFooter setText:@"<<1,2>>" atIndex:0];
    [headerFooter setText:@"<<1,2>>" atIndex:1];
    [headerFooter setText:@"<<1,2>>" atIndex:2];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [headerFooter setFontSize:14.0 atIndex:0];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [headerFooter setFontSize:14.0 atIndex:1];
    [headerFooter setTextColor:[CPDFKitPlatformColor redColor] atIndex:0];
    [headerFooter setFontSize:14.0 atIndex:2];
    headerFooter.pageString = @"0-4";
    
    [headerFooter update];
    
    // Print page header footer message
    for (int i = 0; i < 3; i++) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text: %@\n", [headerFooter textAtIndex:i]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n\n", [self getStringFromEnumLocation:i]];
    }
    
    [document writeToURL:self.addPageHeaderFooterURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddPageHeaderFooterTest.pdf\n"];
}

- (void)editHeaderFooter {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3: Edit header footer\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"HeaderFoooter"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"HeaderFoooter",@"AddCommonHeaderFooterTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EditHeaderFooterTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    // Edit text header footer
    self.editHeaderFooterURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.editHeaderFooterURL];
    
    CPDFHeaderFooter *headerFooter = document.headerFooter;
    [headerFooter setText:@"ComPDFKit Samples" atIndex:0];
    [headerFooter setText:@"ComPDFKit" atIndex:1];
    [headerFooter setText:@"ComPDFKit" atIndex:2];
    [headerFooter update];
    
    for (int i = 0; i < 3; i++) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text: %@\n", [headerFooter textAtIndex:i]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n\n", [self getStringFromEnumLocation:i]];
    }
    
    [document writeToURL:self.editHeaderFooterURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EditHeaderFooterTest.pdf\n"];
}

- (void)deleteHeaderFooter {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 4: Delete header footer\n"];
    
    // Save a document in Sandbox
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"HeaderFoooter"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"HeaderFoooter",@"AddCommonHeaderFooterTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteHeaderFooterTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    self.deleteHeaderFooterURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteHeaderFooterURL];
    
    // Delete header footer
    CPDFHeaderFooter *headerFooter = document.headerFooter;
    [headerFooter clear];
    
    [document writeToURL:self.deleteHeaderFooterURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DeleteHeaderFooterTest.pdf\n"];
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
        
        UIAlertAction *commonHeaderFooterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddCommonHeaderFooterTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddCommonHeaderFooterTest.pdf
            [self openFileWithURL:self.addCommonHeaderFooterURL];
        }];
        UIAlertAction *pageHeaderFooterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddPageHeaderFooterTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddPageHeaderFooterTest.pdf
            [self openFileWithURL:self.addPageHeaderFooterURL];
        }];
        UIAlertAction *editHeaderFooterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EditHeaderFooterTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EditHeaderFooterTest.pdf
            [self openFileWithURL:self.editHeaderFooterURL];
        }];
        UIAlertAction *deleteHeaderFooterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteHeaderFooterTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteHeaderFooterTest.pdf
            [self openFileWithURL:self.deleteHeaderFooterURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:commonHeaderFooterAction];
        [alertController addAction:pageHeaderFooterAction];
        [alertController addAction:editHeaderFooterAction];
        [alertController addAction:deleteHeaderFooterAction];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running HeaderFooter sample...\n\n"];
        [self addCommonHeaderFooter:self.document];
        [self addPageHeaderFooter:self.document];
        [self editHeaderFooter];
        [self deleteHeaderFooter];
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
