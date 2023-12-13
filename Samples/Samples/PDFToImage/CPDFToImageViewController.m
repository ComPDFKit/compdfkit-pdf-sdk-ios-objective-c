//
//  CPDFToImageViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CPDFToImageViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to PDF to picture using API.
//-----------------------------------------------------------------------------------------

@interface CPDFToImageViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSMutableArray *imageFilePaths;

@end

@implementation CPDFToImageViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to convert PDF to image.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
    
    self.imageFilePaths = [NSMutableArray array];
}

#pragma mark - Samples Methods

// PDF to picture and save the picture
- (void)PDFToImage:(CPDFDocument *)document {
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFToImage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Traverse the page, converting all pages to images
    for (int i = 0; i < document.pageCount; i++) {
        // Get image from page
        CPDFPage *page = [document pageAtIndex:i];
        CGSize pageSize = [document pageSizeAtIndex:i];
        UIImage *image = [page thumbnailOfSize:pageSize];
        
        // Save image in Sandbox
        NSString *imageFilePath = [writeDirectoryPath stringByAppendingFormat:@"/PDFToImageTest%d.png", i];
        [self.imageFilePaths addObject:imageFilePath];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        BOOL success = [imageData writeToFile:imageFilePath atomically:YES];
        
        if (success) {
            self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Done. Results saved in PDFToImageTest%d.png\n", i];
        } else {
            self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Done. Results saved in PDFToImageTest%d.png fail !\n", i];
        }
    }
}

- (void)openFile:(NSString *)imageFilePath {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:imageFilePath]] applicationActivities:nil];
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
        
        for (int i = 0; i < self.document.pageCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"PDFToImageTest%d.png", i];
            UIAlertAction *imageAction = [UIAlertAction actionWithTitle:NSLocalizedString(imageName, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // Open PDFToImageTest.png
                [self openFile:self.imageFilePaths[i]];
            }];
            [alertController addAction:imageAction];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running Bookmark sample...\n\n"];
        [self PDFToImage:self.document];
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
