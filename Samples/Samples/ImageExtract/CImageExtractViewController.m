//
//  CImageExtractViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CImageExtractViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to extract all images from PDF documents
//-----------------------------------------------------------------------------------------

@interface CImageExtractViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSMutableArray *imageFilePaths;

@property (nonatomic, strong) NSMutableArray *imageNames;

@end

@implementation CImageExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to extract all the images of a PDF document", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
    
    self.imageFilePaths = [NSMutableArray array];
    self.imageNames = [NSMutableArray array];
}

#pragma mark - Samples Methods

- (void)imageExtract:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Extract all images in the documentn"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"ImageExtract"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Extract all images from document
    NSIndexSet *pages = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)];
    
    [document extractImageFromPages:pages toPath:writeDirectoryPath];
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:writeDirectoryPath error:nil];
    for (NSString *fileName in fileArray) {
        NSString *filePath = [writeDirectoryPath stringByAppendingPathComponent:fileName];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"%@\n", fileName];
        [self.imageFilePaths addObject:filePath];
        [self.imageNames addObject:fileName];
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
        
        for (int i = 0; i < self.imageFilePaths.count; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@", self.imageNames[i]];
            UIAlertAction *imageAction = [UIAlertAction actionWithTitle:NSLocalizedString(imageName, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // Open ImageExtractTest.pdf
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running ImageExtract sample...\n\n"];
        [self imageExtract:self.document];
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
