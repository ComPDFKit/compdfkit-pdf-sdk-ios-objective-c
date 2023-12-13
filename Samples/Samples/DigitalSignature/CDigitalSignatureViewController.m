//
//  CDigitalSignatureViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CDigitalSignatureViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// This sample demonstrates the creation of digital certificates, the generation of digital
// signatures, the verification of digital certificates, the validation of digital signatures,
// the reading of digital signature information, certificate trust, and signature removal
// functionality. using API.
//-----------------------------------------------------------------------------------------

@interface CDigitalSignatureViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *digitalSignatureURL;

@property (nonatomic, strong) NSURL *certificateURL;

@property (nonatomic, strong) NSURL *deleteDigitalSignatureURL;

@end

@implementation CDigitalSignatureViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample demonstrates the creation of digital certificates, the generation of digital signatures, the verification of digital certificates, the validation of digital signatures, the reading of digital signature information, certificate trust, and signature removal functionality.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

// <summary>
// in the core function "CPDFPKCS12CertHelper.GeneratePKCS12Cert":
//
// Generate certificate
//
// Password: ComPDFKit
//
// info: /C=SG/O=ComPDFKit/D=R&D Department/CN=Alan/emailAddress=xxxx@example.com
//
// C=SG: This represents the country code "SG," which typically stands for Singapore.
// O=ComPDFKit: This is the Organization (O) field, indicating the name of the organization or entity, in this case, "ComPDFKit."
// D=R&D Department: This is the Department (D) field, indicating the specific department within the organization, in this case, "R&D Department."
// CN=Alan: This is the Common Name (CN) field, which usually represents the name of the individual or entity. In this case, it is "Alan."
// emailAddress=xxxx@example.com: Email is xxxx@example.com
//
// CPDFCertUsage.CPDFCertUsageAll: Used for both digital signing and data validation simultaneously.
//
// is_2048 = true: Enhanced security encryption.
// </summary>

- (void)generateCertificate {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Create a pfx format certificate for digital signature use\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Signature"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Create a pfx format certificate
    
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pfx",writeDirectoryPath,@"Certificate"];
    self.certificateURL = [NSURL fileURLWithPath:writeFilePath];
    
    NSMutableDictionary * cer = [NSMutableDictionary dictionary];
    [cer setValue:@"Alan" forKey:@"CN"];
    [cer setValue:@"xxxx@example.com" forKey:@"emailAddress"];
    [cer setValue:@"CN" forKey:@"C"];
    
    
    BOOL save = [CPDFSignature generatePKCS12CertWithInfo:cer password:@"ComPDFKit" toPath:writeFilePath certUsage:CPDFCertUsageDigSig];
    
    if (save) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"File saved in %@\n", writeFilePath];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Generate PKCS12 certificate done.\n"];
    } else {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Generate PKCS12 certificate failed.\n"];
    }
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
}

// <summary>
//
// Adding a signature is divided into two steps:
// creating a signature field and filling in the signature.
//
// Page Index: 0
// Rect: CRect(28, 420, 150, 370)
// Border RGB:{ 0, 0, 0 }
// Widget Background RGB: { 150, 180, 210 }
//
// Text: Grantor Name
// Content:
//     Name: get grantor name from certificate
//     Date: now(yyyy.mm.dd)
//     Reason: I am the owner of the document.
//     DN: Subject
//     Location: Singapor
//     IsContentAlginLeft: false
//     IsDrawLogo: True
//     LogoBitmap: logo.png
//     text color RGB: { 0, 0, 0 }
//     content color RGB: { 0, 0, 0 }
//     Output file name: document.FileName + "_Signed.pdf"
// </summary>

- (void)CreateDigitalSignature:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Create a pfx format certificate for digital signature use\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Signature"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DigitalSignature"];
    
    // Save the document in the test PDF file
    self.digitalSignatureURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.digitalSignatureURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.digitalSignatureURL];
    
    CPDFPage *page = [document pageAtIndex:0];
    
    CPDFSignatureWidgetAnnotation *widgetAnnotation = [[CPDFSignatureWidgetAnnotation alloc] initWithDocument:document];
    
    [widgetAnnotation setFieldName:[NSString stringWithFormat:@"%@",@"Signature"]];
    
    widgetAnnotation.borderWidth = 2.0;
    widgetAnnotation.bounds = CGRectMake(28, 420, 150, 370);
    [widgetAnnotation setModificationDate:[NSDate date]];
    [page addAnnotation:widgetAnnotation];
    
    CPDFSignatureCertificate *signatureCertificate = [CPDFSignatureCertificate certificateWithPKCS12Path:self.certificateURL.path password:@"ComPDFKit"];
    
    CPDFSignatureConfig *signatureConfig = [[CPDFSignatureConfig alloc] init];
    signatureConfig.image = [UIImage imageNamed:@"Logo"];
    signatureConfig.isContentAlginLeft = NO;
    signatureConfig.isDrawLogo = YES;
    signatureConfig.isDrawKey = YES;
    signatureConfig.logo = [UIImage imageNamed:@"Logo"];
    
    NSMutableArray *contents = [NSMutableArray arrayWithArray:signatureConfig.contents];
    
    CPDFSignatureConfigItem *configItem1 = [[CPDFSignatureConfigItem alloc]init];
    configItem1.key = @"Digitally signed by Apple Distribution";
    configItem1.value = NSLocalizedString([signatureCertificate.issuerDict objectForKey:@"CN"], nil);
    [contents addObject:configItem1];
    
    CPDFSignatureConfigItem *configItem2 = [[CPDFSignatureConfigItem alloc]init];
    configItem2.key = @"Date";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    configItem2.value = [dateFormatter stringFromDate:[NSDate date]];
    [contents addObject:configItem2];
    
    CPDFSignatureConfigItem *configItem3 = [[CPDFSignatureConfigItem alloc]init];
    configItem3.key = @"DN";
    configItem3.value = NSLocalizedString([signatureCertificate.subjectDict objectForKey:@"C"], nil);
    [contents addObject:configItem3];
    
    CPDFSignatureConfigItem *configItem4 = [[CPDFSignatureConfigItem alloc]init];
    configItem4.key = @"ComPDFKit Version";
    NSDictionary*infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    configItem4.value = app_Version;
    [contents addObject:configItem4];
    
    CPDFSignatureConfigItem *configItem5 = [[CPDFSignatureConfigItem alloc]init];
    configItem5.key = @"Reason";
    configItem5.value = NSLocalizedString(@"I am the owner of the document.", nil);
    [contents addObject:configItem5];
    
    CPDFSignatureConfigItem *configItem6 = [[CPDFSignatureConfigItem alloc]init];
    configItem6.key = @"Location";
    configItem6.value = NSLocalizedString(@"<your signing location here>", nil);
    [contents addObject:configItem6];
    
    signatureConfig.contents = contents;
    [widgetAnnotation signWithSignatureConfig:signatureConfig];
    
    BOOL isSuccess = [document writeSignatureToURL:[NSURL fileURLWithPath:writeFilePath] withWidget:widgetAnnotation PKCS12Cert:self.certificateURL.path password:@"ComPDFKit" location:@"<your signing location here>" reason:@"I am the owner of the document." permissions:CPDFSignaturePermissionsNone];
    
    if (isSuccess) {
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"File saved in %@\n", writeFilePath];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Create digital signature done.\n"];
    } else {
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Create digital signature failed.\n"];
    }
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
}


- (void)verifySignatureInfo {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3:verify certificate\n"];
    
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.digitalSignatureURL];

    NSArray *signatures = [document signatures];

    // Iterate through all digital signatures
    if (signatures.count > 0) {
        for (CPDFSignature *signature in signatures) {
            CPDFSigner *signer = signature.signers.firstObject;
            CPDFSignatureCertificate * cer = signer.certificates.firstObject;
            
            BOOL isSignVerified = YES;
            BOOL isCertTrusted = YES;
            
            // Verify the validity of the signature
            if (!signer.isCertTrusted) {
                isCertTrusted = NO;
            }
            
            // Determine if the signature is valid and the document is unmodified
            if (!signer.isSignVerified) {
                isSignVerified = NO;
            }
            
            if (isSignVerified && isCertTrusted) {
                // Signature is valid and the certificate is trusted
                // Perform corresponding actions
                
            } else if(isSignVerified && !isCertTrusted) {
                // Signature is valid but the certificate is not trusted
                // Perform corresponding actions
            } else if(!isSignVerified && !isCertTrusted){
                
            } else {
                // Signature is invalid
                // Perform corresponding actions
            }
            
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Is the certificate trusted: %@\n", (isSignVerified == YES) ? @"YES" : @"NO"];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Is the signature verified: %@\n", (isCertTrusted == YES) ? @"YES" : @"NO"];
        }
    }
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Verify digital signature done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
}

- (void)verifyCertificate {
    CPDFSignatureCertificate *signatureCertificate = [CPDFSignatureCertificate certificateWithPKCS12Path:self.certificateURL.path password:@"ComPDFKit"];

    [signatureCertificate checkCertificateIsTrusted];

    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Verify certificate done.\n"];
}

- (void)printDigitalSignatureInfo {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 4:Print digital signature info.\n"];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.digitalSignatureURL];

    NSArray *signatures = [document signatures];
    if (signatures.count > 0) {
        for (CPDFSignature *signature in signatures) {
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Name: %@\n", signature.name];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Location: %@\n", signature.location];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Reason: %@\n", signature.reason];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Date: %@\n", signature.date];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Subject: %@\n", signature.subFilter];
        }
    }
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Print digital signature info done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
}

- (void)trustCertificate {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 5:Trust certificate.\n"];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.digitalSignatureURL];

    NSArray *signatures = [document signatures];

    CPDFSignature *signature = signatures[0];
    CPDFSigner *signer = signature.signers.firstObject;
    CPDFSignatureCertificate * certificate = signer.certificates.firstObject;

    [certificate checkCertificateIsTrusted];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"---Begin trusted---\n"];
    [certificate addToTrustedCertificates];
    [certificate checkCertificateIsTrusted];

    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Trust certificate done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
}

- (void)removeDigitalSignature {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 6:Remove digital signature.\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Signature"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteDigitalSignature"];
    
    // Save the document in the test PDF file
    self.deleteDigitalSignatureURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *oldDocument = [[CPDFDocument alloc] initWithURL:self.digitalSignatureURL];
    [oldDocument writeToURL:self.deleteDigitalSignatureURL];
    
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteDigitalSignatureURL];
    
    NSArray *signatures = [document signatures];

    CPDFSignature *signature = signatures[0];
    
    [document removeSignature:signature];
    
    [document writeToURL:self.deleteDigitalSignatureURL];
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
        
        UIAlertAction *certificateAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   Certificate.pfx   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open Certificate.pfx
            [self openFileWithURL:self.certificateURL];
        }];
        
        UIAlertAction *digitalSignatureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DigitalSignature.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DigitalSignature.pdf
            [self openFileWithURL:self.digitalSignatureURL];
        }];
        
        UIAlertAction *deleteSignatureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteDigitalSignature.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteDigitalSignature.pdf
            [self openFileWithURL:self.deleteDigitalSignatureURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:certificateAction];
        [alertController addAction:digitalSignatureAction];
        [alertController addAction:deleteSignatureAction];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running FlattenedCopy sample...\n\n"];
        [self generateCertificate];
        [self CreateDigitalSignature:self.document];
        [self verifySignatureInfo];
        [self verifyCertificate];
        [self printDigitalSignatureInfo];
        [self trustCertificate];
        [self removeDigitalSignature];
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
