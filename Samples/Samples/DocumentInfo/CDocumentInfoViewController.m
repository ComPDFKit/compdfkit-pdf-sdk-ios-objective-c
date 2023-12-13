//
//  CDocumentInfoViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CDocumentInfoViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to extract PDF document information such as: date using API.
//-----------------------------------------------------------------------------------------

@interface CDocumentInfoViewController ()

@end

@implementation CDocumentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to extract information about PDF documents, such as: author, date created.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)printDocumentInfo:(CPDFDocument *)document {
    NSDictionary *documentAttributes = [document documentAttributes];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"File Name: %@\n", document.documentURL.lastPathComponent];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"File Szie: %@\n", [self fileSizeStr]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Title: %@\n", documentAttributes[CPDFDocumentTitleAttribute]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Author: %@\n", documentAttributes[CPDFDocumentAuthorAttribute]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Subject: %@\n", documentAttributes[CPDFDocumentSubjectAttribute]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Keywords: %@\n", documentAttributes[CPDFDocumentKeywordsAttribute]];
    NSString * versionString = [NSString stringWithFormat:@"%ld.%ld",(long)document.majorVersion,(long)document.minorVersion];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Version: %@\n", versionString];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages: %zd\n", document.pageCount];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Creator: %@\n", documentAttributes[CPDFDocumentCreatorAttribute]];
    
    {
        if (documentAttributes[CPDFDocumentCreationDateAttribute]) {
            NSMutableString* mSting = [NSMutableString string];
            NSString*    tstring = [NSString stringWithFormat:@"%@",documentAttributes[CPDFDocumentCreationDateAttribute]];
            if (tstring.length >= 16) {
                NSRange        range;
                range.location = 2;range.length=4;
                [mSting appendString:[tstring substringWithRange:range]];
                range.location = 6;range.length=2;
                [mSting appendFormat:@"-%@",[tstring substringWithRange:range]];
                range.location = 8;range.length=2;
                [mSting appendFormat:@"-%@",[tstring substringWithRange:range]];
                
                range.location = 10;range.length=2;
                [mSting appendFormat:@" %@",[tstring substringWithRange:range]];
                range.location = 12;range.length=2;
                [mSting appendFormat:@":%@",[tstring substringWithRange:range]];
                range.location = 14;range.length=2;
                [mSting appendFormat:@":%@",[tstring substringWithRange:range]];
                
                self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Creation Date: %@\n", mSting];
            }
        }
    }
    
    {
        if (documentAttributes[CPDFDocumentModificationDateAttribute]){
            NSMutableString* mSting = [NSMutableString string];
            NSString*    tstring = [NSString stringWithFormat:@"%@",documentAttributes[CPDFDocumentModificationDateAttribute]];

            if (tstring.length >= 16) {
                NSRange        range;
                range.location = 2;range.length=4;
                [mSting appendString:[tstring substringWithRange:range]];
                range.location = 6;range.length=2;
                [mSting appendFormat:@"-%@",[tstring substringWithRange:range]];
                range.location = 8;range.length=2;
                [mSting appendFormat:@"-%@",[tstring substringWithRange:range]];
                
                range.location = 10;range.length=2;
                [mSting appendFormat:@" %@",[tstring substringWithRange:range]];
                range.location = 12;range.length=2;
                [mSting appendFormat:@":%@",[tstring substringWithRange:range]];
                range.location = 14;range.length=2;
                [mSting appendFormat:@":%@",[tstring substringWithRange:range]];
                
                self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Modification Date: %@\n", mSting];
            }
        }
    }
    
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Printing: %@\n", document.allowsPrinting ? @"true" : @"flase"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Content Copying:: %@\n", document.allowsCopying ? @"true" : @"flase"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Document Change: %@\n", document.allowsDocumentChanges ? @"true" : @"flase"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Document Assembly: %@\n", document.allowsDocumentAssembly ? @"true" : @"flase"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Commenting: %@\n", document.allowsCommenting ? @"true" : @"flase"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Filling of Form Field: %@\n", document.allowsFormFieldEntry ? @"true" : @"flase"];
}

// Get file size
- (NSString *)fileSizeStr {

    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:self.document.documentURL.path]) {
        return @"";
    }
    
    NSDictionary *attrib = [[NSFileManager defaultManager] attributesOfItemAtPath:self.document.documentURL.path error:nil];
    float tFileSize   = [[attrib objectForKey:NSFileSize] floatValue];
    
    float fileSize = tFileSize / 1024;
    float size = fileSize >= 1024 ?(fileSize < 1048576 ? fileSize/1024.0 : fileSize/1048576.0) : fileSize;
    char  unit = fileSize >= 1024 ? (fileSize < 1048576 ? 'M':'G'):'K';
    return [NSString stringWithFormat:@"%0.1f%c", size, unit];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running DocumentInfo sample...\n\n"];
        [self printDocumentInfo:self.document];
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
