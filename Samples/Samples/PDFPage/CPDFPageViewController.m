//
//  CPDFPageViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CPDFPageViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to operate multiple pages of pdf document, including
// insert blank page, insert PDF document page, split page, merge page, delete page,
// rotate page, replace document page and export document page.
//-----------------------------------------------------------------------------------------



@interface CPDFPageViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *insertBlankPageURL;

@property (nonatomic, strong) NSURL *insertPDFPageURL;

@property (nonatomic, strong) NSURL *mergePageURL;

@property (nonatomic, strong) NSURL *removePageURL;

@property (nonatomic, strong) NSURL *rotatePageURL;

@property (nonatomic, strong) NSURL *replacePageURL;

@property (nonatomic, strong) NSURL *extractPageURL;

@property (nonatomic, strong) NSMutableArray *splitFilePaths;

@end

@implementation CPDFPageViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to print form list information, set up interactive forms (including text, checkbox, radioButton, button, list, Combox, and sign forms, delete forms), and fill out form information.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
    
    self.splitFilePaths = [NSMutableArray array];
}

#pragma mark - Samples Methods

// Insert blank page
- (void)insertBlankPage:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Insert a blank A4-sized page into the sample document\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"InsertBlankPage"];
    
    // Save the document in the test PDF file
    self.insertBlankPageURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.insertBlankPageURL];
    
    // Create a new document for test PDF file
     CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.insertBlankPageURL];
    
    // insert blank page
    [document insertPage:CGSizeMake(595, 852) atIndex:1];
    
    // Save the create insert a blank PDF page action in document
    [document writeToURL:self.insertBlankPageURL];
     
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Insert PageIndex : 1\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Size : 595*842\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in InsertBlankPage.pdf\n"];
}

// Insert PDF document
- (void)insertPDFPPage:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Import pages from another document into the example document\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // get PDF document
    NSString *filePathTest = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"pdf"];
    CPDFDocument *insertDocument = [[CPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:filePathTest]];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Open the document to be imported\n"];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    
    // Save the document in the test PDF file
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"InsertPDFPage"];
    
    // Save the document in the test PDF file
    self.insertPDFPageURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.insertPDFPageURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.insertPDFPageURL];
    
    // Insert PDF document
    [document importPages:indexSet fromDocument:insertDocument atIndex:1];
    
    // Save the create insert PDF document action in document
    [document writeToURL:self.insertPDFPageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in InsertPDFPage.pdf\n"];
}

// Split page
- (void)splitPages:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3: Split a PDF document into multiple pages\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    for (int i = 0; i < document.pageCount; i++) {
        CPDFDocument *splitDocument = [[CPDFDocument alloc] init];
        NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:i];
        
        NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@%d.pdf",writeDirectoryPath,@"CommonFivePageSplitPage",i];
        
        [self.splitFilePaths addObject:writeFilePath];
        
        [splitDocument importPages:index fromDocument:document atIndex:0];
        [splitDocument writeToURL:[NSURL fileURLWithPath:writeFilePath]];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Done. Results saved in CommonFivePageSplitPage%d.pdf\n", i];
    }
}

// merge page
- (void)mergePages:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 4: Merge split documents\n"];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"MergePages"];
    
    CPDFDocument *mergeDocument = [[CPDFDocument alloc] init];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    for (int i = 0; i < self.splitFilePaths.count; i++) {
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:self.splitFilePaths[i]]];
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opening CommonFivePageSplitPage%d.pdf\n", i];
        NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:0];
        [mergeDocument importPages:index fromDocument:document atIndex:i];
    }
    
    self.mergePageURL = [NSURL fileURLWithPath:writeFilePath];
    [mergeDocument writeToURL:self.mergePageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in MergePages.pdf\n"];
}

// Delete page
- (void)deletePages:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 5: Delete the specified page of the document\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"RemovePages"];
    
    // Save the document in the test PDF file
    self.removePageURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.removePageURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.removePageURL];
    
    // Delete even-numbered pages of a document
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i = 1; i < document.pageCount; i = i+2) {
        [indexSet addIndex:i];
    }
    
    [document removePageAtIndexSet:indexSet];
    
    // Save the delete even-numbered pages of a document action in document
    [document writeToURL:self.removePageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in RemovePages.pdf\n"];
}

// Rotate page
- (void)rotatePages:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 6: Rotate document pages\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"RotatePage"];
    
    // Create a new document for test PDF file
    self.rotatePageURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.rotatePageURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.rotatePageURL];
    
    // Rotate the first page 90 degrees
    CPDFPage *page = [document pageAtIndex:0];
    page.rotation += 90;
    
    // Save the rotate page action in document
    [document writeToURL:self.rotatePageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in RotatePage.pdf\n"];
}

// Replace document page
- (void)repalcePages:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 7: Replace specified pages of example documentation with other documentation specified pages\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"ReplacePages"];
    
    // Save the document in the test PDF file
    self.replacePageURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.replacePageURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.replacePageURL];
    
    // Get PDF document
    NSString *filePathTest = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"pdf"];
    CPDFDocument *insertDocument = [[CPDFDocument alloc] initWithURL:[NSURL fileURLWithPath:filePathTest]];
    
    // Replace PDF document
    NSIndexSet *inserSet = [[NSIndexSet alloc]  initWithIndex:0];
    NSIndexSet *removeSet = [[NSIndexSet alloc]  initWithIndex:1];
    [document removePageAtIndexSet:removeSet];
    [document importPages:inserSet fromDocument:insertDocument atIndex:1];
    
    // Save the replace pages action in document
    [document writeToURL:self.replacePageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in ReplacePages.pdf\n"];
}

// Export document page
- (void)extractPages:(CPDFDocument *)document {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 8: Extract specific pages of a document\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Opening the Samples PDF File\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"PDFPage"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"ExtractPages"];
    
    // Get range of extract page
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:1];
    
    self.extractPageURL = [NSURL fileURLWithPath:writeFilePath];
    
    CPDFDocument *extractDocument = [[CPDFDocument alloc] init];
    [extractDocument importPages:indexSet fromDocument:document atIndex:0];
    
    // Save the extract pages action in document
    [extractDocument writeToURL:self.extractPageURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in ExtractPages.pdf\n"];
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
        
        UIAlertAction *insertBlankAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   InsertBlankPage.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open InsertBlankPage.pdf
            [self openFileWithURL:self.insertBlankPageURL];
        }];
        [alertController addAction:insertBlankAction];
        
        UIAlertAction *insertPDFAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   InsertPDFPage.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open InsertPDFPage.pdf
            [self openFileWithURL:self.insertPDFPageURL];
        }];
        [alertController addAction:insertPDFAction];
        
        for (int i = 0; i < self.document.pageCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"CommonFivePageSplitPage%d.pdf", i];
            UIAlertAction *imageAction = [UIAlertAction actionWithTitle:NSLocalizedString(imageName, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // Open CommonFivePageSplitPage.pdf
                [self openFileWithURL:[NSURL fileURLWithPath:self.splitFilePaths[i]]];
            }];
            [alertController addAction:imageAction];
        }
        
        UIAlertAction *mergeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   MergePage.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open MergePage.pdf
            [self openFileWithURL:self.mergePageURL];
        }];
        [alertController addAction:mergeAction];
        
        UIAlertAction *removePagesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   RemovePages.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open RemovePages.pdf
            [self openFileWithURL:self.removePageURL];
        }];
        [alertController addAction:removePagesAction];
        
        UIAlertAction *rotatePagesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   RotatePage.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open RotatePage.pdf
            [self openFileWithURL:self.rotatePageURL];
        }];
        [alertController addAction:rotatePagesAction];
        
        UIAlertAction *replacePagesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   ReplacePages.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open ReplacePages.pdf
            [self openFileWithURL:self.replacePageURL];
        }];
        [alertController addAction:replacePagesAction];
        
        UIAlertAction *ExtractPagesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   ExtractPages.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open ExtractPages.pdf
            [self openFileWithURL:self.extractPageURL];
        }];
        [alertController addAction:ExtractPagesAction];
        
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running PDFPage sample...\n\n"];
        [self insertBlankPage:self.document];
        [self insertPDFPPage:self.document];
        [self splitPages:self.document];
        [self mergePages:self.document];
        [self deletePages:self.document];
        [self rotatePages:self.document];
        [self repalcePages:self.document];
        [self extractPages:self.document];
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
