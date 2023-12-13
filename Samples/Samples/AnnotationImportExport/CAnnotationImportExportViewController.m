//
//  CAnnotationImportExportViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CAnnotationImportExportViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to import and export anntation using API
//-----------------------------------------------------------------------------------------

@interface CAnnotationImportExportViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSString *exportFilePath;

@property (nonatomic, strong) NSURL *importURL;

@end

@implementation CAnnotationImportExportViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to set up the export and import of annotations. Thedocument from which the annotations are exported is an xfdf file.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)importAnnotaiton {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"AnnotationImportExport"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"Samples",@"CommonFivePage"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"ImportAnnotaitonTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    CPDFDocument *importDocument = [[CPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:documentFolder]];
    [importDocument importAnnotationFromXFDFPath:self.exportFilePath];
    
    // Save the document in the PDF file
    self.importURL = [NSURL fileURLWithPath:writeFilePath];
    [importDocument writeToURL:self.importURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in ImportAnnotaitonTest.pdf\n"];
}

- (void)exportAnnotaiton:(CPDFDocument *)document {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"AnnotationImportExport"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    self.exportFilePath = [NSString stringWithFormat:@"%@/%@.xfdf",writeDirectoryPath,@"ExportAnnotaiton"];
    
    [document exportAnnotationToXFDFPath:self.exportFilePath];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in ExportAnnotaitonTest.xfdf\n"];
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
        
        UIAlertAction *exportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   ExportAnnotaiton.xfdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open ExportAnnotaiton.pdf
            [self openFileWithURL:[NSURL fileURLWithPath:self.exportFilePath]];
        }];
        
        UIAlertAction *importAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   ImportAnnotaitonTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open ImportAnnotaitonTest.pdf
            [self openFileWithURL:self.importURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:exportAction];
        [alertController addAction:importAction];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running AnnotationImportExport sample...\n\n"];
        [self exportAnnotaiton:self.document];
        [self importAnnotaiton];
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
