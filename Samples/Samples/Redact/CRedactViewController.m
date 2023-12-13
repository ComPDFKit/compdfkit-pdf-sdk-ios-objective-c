//
//  CRedactViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CRedactViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// PDF Redactor is a separately licensable Add-on that offers options to remove
// (not just covering or obscuring) content within a region of PDF.
// With printed pages, redaction involves blacking-out or cutting-out areas of
// the printed page. With electronic documents that use formats such as PDF,
// redaction typically involves removing sensitive content within documents for
// safe distribution to courts, patent and government institutions, the media,
// customers, vendors or any other audience with restricted access to the content.
//-----------------------------------------------------------------------------------------

@interface CRedactViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *addRedactURL;

@end

@implementation CRedactViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to tag ciphertext and is a separate permissioned add-on that provides options to delete (not just overwrite or obscure) content within the PDF area. For a printed page, redaction involves removing or deleting certain areas of the printed page. For electronic documents that use formats such as PDF, redaction typically involves removing sensitive content from the document for safe distribution to courts, patent and government agencies, the media, customers, suppliers, or any other audience with restricted access to the content.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)addRadact:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Redact"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddRedactTest"];
    
    // Save the document in the test PDF file
    self.addRedactURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addRedactURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addRedactURL];
    
    // Add redact
    CPDFPage *page = [document pageAtIndex:0];
    
    NSArray *resultArray = [document findString:@"Page" withOptions:CPDFSearchCaseInsensitive];
    
    // Get the first page of search resultsGet the first page of search results
    NSArray *selections = [resultArray objectAtIndex:3];
    
    // Get the first search result on the first page
    CPDFSelection *selection = [selections objectAtIndex:0];
    
    CPDFRedactAnnotation *redact = [[CPDFRedactAnnotation alloc] initWithDocument:document];
    redact.bounds = selection.bounds;
    redact.overlayText = @"REDACTED";
    redact.font = [UIFont systemFontOfSize:12];
    redact.fontColor = [UIColor redColor];
    redact.alignment = NSTextAlignmentLeft;
    redact.interiorColor = [UIColor blackColor];
    redact.borderColor = [UIColor yellowColor];
    [page addAnnotation:redact];
    
    [document writeToURL:self.addRedactURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"The text need to be redact is: Page%d\n", (int)[document indexForPage:page]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"\tText in the redacted area is: %d, %d, %d, %d\n\n", (int)redact.bounds.origin.x,(int)redact.bounds.origin.y, (int)redact.bounds.size.width, (int)redact.bounds.size.height];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddRedactTest.pdf\n"];
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
        
        UIAlertAction *addRedactAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddRedactTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddRedactTest.pdf
            [self openFileWithURL:self.addRedactURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:addRedactAction];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running Redact sample...\n\n"];
        [self addRadact:self.document];
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
