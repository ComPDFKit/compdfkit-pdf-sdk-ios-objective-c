//
//  CEncryptViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
#import "CEncryptViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to encrypt and decrypt documents using API.
//-----------------------------------------------------------------------------------------

@interface CEncryptViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) NSMutableArray *userPasswordURLs;

@end

@implementation CEncryptViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to set user password and permission password, decrypt, set document permission.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
    
    self.userPasswordURLs = [NSMutableArray array];
}

#pragma mark - Samples Methods

- (void)encryptByUserPassword:(CPDFDocument *)oldDocument {
    {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Document use RC4 encrypt done\n"];
        
        // Get Sandbox path for saving the PDF File
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
  
        if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
            [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptUserRC4Test"];
        
        // Save the document in the test PDF file
        NSURL *encryptUserRC4URL = [NSURL fileURLWithPath:writeFilePath];
        [oldDocument writeToURL:encryptUserRC4URL];
        
        // Create a new document for test PDF file
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptUserRC4URL];
        [self.userPasswordURLs addObject:encryptUserRC4URL];
        
        // Set encryption attributes
        NSDictionary *options = @{CPDFDocumentUserPasswordOption : @"User",
                                  CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelRC4)};
        [document writeToURL:encryptUserRC4URL withOptions:options];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"User password is: User\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptUserRC4Test.pdf\n\n"];
    }
    
    {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Document use AES128 encrypt done\n"];
        
        // Get Sandbox path for saving the PDF File
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
     
        if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
            [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptUserAES128Test"];
        
        // Save the document in the test PDF file
        NSURL *encryptUserAES128URL = [NSURL fileURLWithPath:writeFilePath];
        [oldDocument writeToURL:encryptUserAES128URL];
        
        // Create a new document for test PDF file
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptUserAES128URL];
        [self.userPasswordURLs addObject:encryptUserAES128URL];
        
        // Set encryption attributes
        NSDictionary *options = @{CPDFDocumentUserPasswordOption : @"User",
                                  CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelAES128)};
        [document writeToURL:encryptUserAES128URL withOptions:options];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"User password is: User\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptUserAES128Test.pdf\n\n"];
    }
    
    {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3: Document use AES256 encrypt done\n"];
        
        // Get Sandbox path for saving the PDF File
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
  
        if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
            [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptUserAES256Test"];
        
        // Save the document in the test PDF file
        NSURL *encryptUserAES256URL = [NSURL fileURLWithPath:writeFilePath];
        [oldDocument writeToURL:encryptUserAES256URL];
        
        // Create a new document for test PDF file
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptUserAES256URL];
        [self.userPasswordURLs addObject:encryptUserAES256URL];
        
        // Set encryption attributes
        NSDictionary *options = @{CPDFDocumentUserPasswordOption : @"User",
                                  CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelAES256)};
        [document writeToURL:encryptUserAES256URL withOptions:options];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"User password is: User\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptUserAES256Test.pdf\n\n"];
    }
    
    {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 4: Document use NoEncryptAlgo encrypt done\n"];
        
        // Get Sandbox path for saving the PDF File
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
            [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptUserNoEncryptAlgoTest"];
        
        // Save the document in the test PDF file
        NSURL *encryptUserNoEncryptAlgoURL = [NSURL fileURLWithPath:writeFilePath];
        [oldDocument writeToURL:encryptUserNoEncryptAlgoURL];
        
        // Create a new document for test PDF file
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptUserNoEncryptAlgoURL];
        [self.userPasswordURLs addObject:encryptUserNoEncryptAlgoURL];
        
        // Set encryption attributes
        NSDictionary *options = @{CPDFDocumentUserPasswordOption : @"User",
                                  CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelNoEncryptAlgo)};
        [document writeToURL:encryptUserNoEncryptAlgoURL withOptions:options];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"User password is: User\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptUserNoEncryptAlgoTest.pdf\n\n"];
    }
}

- (void)encryptByOwnerPassword:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 5: Encrypt by owner password done\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptOwnerRC4Test"];

    // Save the document in the test PDF file
    NSURL *encryptOwnerRC4URL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:encryptOwnerRC4URL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptOwnerRC4URL];
    [self.userPasswordURLs addObject:encryptOwnerRC4URL];
    
    // Set encryption attributes
    NSDictionary *options = @{CPDFDocumentUserPasswordOption : @"User",
                              CPDFDocumentOwnerPasswordOption : @"Owner",
                              CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelRC4),
                              CPDFDocumentAllowsPrintingOption : @(NO),
                              CPDFDocumentAllowsCopyingOption : @(NO),};
    [document writeToURL:encryptOwnerRC4URL withOptions:options];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Owner password is: Owner\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptOwnerRC4Test.pdf\n\n"];
}

- (void)encryptByAllPasswords:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 6: Encrypt by Both user and owner passwords done\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"EncryptAllAES256Test"];
    
    // Save the document in the test PDF file
    NSURL *encryptAllAES256URL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:encryptAllAES256URL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:encryptAllAES256URL];
    [self.userPasswordURLs addObject:encryptAllAES256URL];
    
    // Set encryption attributes
    NSDictionary *options = @{CPDFDocumentOwnerPasswordOption : @"Owner",
                              CPDFDocumentUserPasswordOption : @"User",
                              CPDFDocumentEncryptionLevelOption : @(CPDFDocumentEncryptionLevelAES256),
                              CPDFDocumentAllowsPrintingOption : @(YES),
                              CPDFDocumentAllowsHighQualityPrintingOption : @(NO),
                              CPDFDocumentAllowsCopyingOption : @(NO),
                              CPDFDocumentAllowsDocumentChangesOption : @(NO),
                              CPDFDocumentAllowsDocumentAssemblyOption : @(NO),
                              CPDFDocumentAllowsCommentingOption : @(NO),
                              CPDFDocumentAllowsFormFieldEntryOption : @(NO)};
    [document writeToURL:encryptAllAES256URL withOptions:options];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"User password is: User\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Owner password is: Owner\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in EncryptAllAES256Test.pdf\n\n"];
}

- (void)unlock {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 7: Unlock with owner password and user password\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
    NSString *documentFolder = [[NSBundle mainBundle] pathForResource:@"AllPasswords" ofType:@"pdf"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"unlockAllPasswords"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    // Unlock the document and print document permission information
    // It is worth noting that the document is only unlocked, not decrypted, and the password is still required for the next opening
    NSURL *unlockAllPasswordsURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:unlockAllPasswordsURL];
    
    [document unlockWithPassword:@"Owner"];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsPrinting:%@\n", document.allowsPrinting ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsHighQualityPrinting:%@\n", document.allowsHighQualityPrinting ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsCopying:%@\n", document.allowsCopying ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsDocumentChanges:%@\n", document.allowsDocumentChanges ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsDocumentAssembly:%@\n", document.allowsDocumentAssembly ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsCommenting:%@\n", document.allowsPrinting ? @"YES" :  @"NO"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"AllowsFormFieldEntry:%@\n\n", document.allowsFormFieldEntry ? @"YES" :  @"NO"];
}

- (void)decrypt {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 8: Decrypt with owner password and user password\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Encrypt"];
    NSString *documentFolder = [[NSBundle mainBundle] pathForResource:@"AllPasswords" ofType:@"pdf"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DecryptAllPasswordsTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    
    // Decrypt document
    NSURL *decryptAllPasswordsURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:decryptAllPasswordsURL];
    [self.userPasswordURLs addObject:decryptAllPasswordsURL];
    
    [document unlockWithPassword:@"Owner"];
    [document writeDecryptToURL:decryptAllPasswordsURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DecryptAllPasswordsTest.pdf\n\n"];
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
        
        UIAlertAction *encryptUserRC4Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptUserRC4Test.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptUserRC4Test.pdf
            [self openFileWithURL:self.userPasswordURLs[0]];
        }];
        
        UIAlertAction *encryptUserAES128Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptUserAES128Test.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptUserAES128Test.pdf
            [self openFileWithURL:self.userPasswordURLs[1]];
        }];
        UIAlertAction *encryptUserAES256Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptUserAES256Test.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptUserAES256Test.pdf
            [self openFileWithURL:self.userPasswordURLs[2]];
        }];
        UIAlertAction *encryptUserNoEncryptAlgoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptUserNoEncryptAlgoTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptUserNoEncryptAlgoTest.pdf
            [self openFileWithURL:self.userPasswordURLs[3]];
        }];
        UIAlertAction *encryptOwnerRC4Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptOwnerRC4Test.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptOwnerRC4Test.pdf
            [self openFileWithURL:self.userPasswordURLs[4]];
        }];
        UIAlertAction *encryptAllAES256Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"   EncryptAllAES256Test.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open EncryptAllAES256Test.pdf
            [self openFileWithURL:self.userPasswordURLs[5]];
        }];
        UIAlertAction *decryptAllPasswordsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DecryptAllPasswordsTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DecryptAllPasswordsTest.pdf
            [self openFileWithURL:self.userPasswordURLs[6]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:encryptUserRC4Action];
        [alertController addAction:encryptUserAES128Action];
        [alertController addAction:encryptUserAES256Action];
        [alertController addAction:encryptUserNoEncryptAlgoAction];
        [alertController addAction:encryptOwnerRC4Action];
        [alertController addAction:encryptAllAES256Action];
        [alertController addAction:decryptAllPasswordsAction];
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
        [self encryptByUserPassword:self.document];
        [self encryptByOwnerPassword:self.document];
        [self encryptByAllPasswords:self.document];
        [self unlock];
        [self decrypt];
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
