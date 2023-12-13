//
//  CTextExtractViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CTextExtractViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to extract all text from PDF document using API.
//-----------------------------------------------------------------------------------------

@interface CTextExtractViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@end

@implementation CTextExtractViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to extract all the text of a PDF.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)extractPageText:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Extract all text content in the specified page\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"The text content of the first page of the document:\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Text:\n"];
    
    CPDFPage *page = [document pageAtIndex:0];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"%@\n", page.string];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\nDone!\n"];
}

- (void)extractAllPageText:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Extract all text content in the specified page\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"The text content of the first page of the document:\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Text:\n"];
    
    for (int i = 0; i < document.pageCount; i++) {
        CPDFPage *page = [document pageAtIndex:i];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"%@\n", page.string];
    }
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\nDone!\n"];
}

- (void)extractRectRangeText:(CPDFDocument *)document {
    
}

#pragma mark - Action

- (IBAction)buttonItemClick_openFile:(id)sender {
    // Determine whether to export the document
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

- (IBAction)buttonItemClick_run:(id)sender {
    if (self.document) {
        self.isRun = NO;
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running Bookmark sample...\n\n"];
        [self extractPageText:self.document];
        [self extractAllPageText:self.document];
        [self extractRectRangeText:self.document];
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
