//
//  CCertificateViewController.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CPDFDocument;
@class CPDFSignatureWidgetAnnotation;
@class CImportCertificateViewController;
@class CPDFSignatureCertificate;
@class CPDFSignatureConfig;

@protocol CCertificateViewControllerDelegate <NSObject>

@optional

- (void)importCertificateViewControllerSave:(CImportCertificateViewController *)importCertificateViewController PKCS12Cert:(NSString *)path password:(NSString *)password config:(CPDFSignatureConfig *)config;

- (void)importCertificateViewControllerCancel:(CImportCertificateViewController *)importCertificateViewController;

@end

@interface CImportCertificateViewController : UIViewController

@property (nonatomic, weak) id<CCertificateViewControllerDelegate> delegate;

- (instancetype)initWithP12FilePath:(NSURL *)filePath Annotation:(CPDFSignatureWidgetAnnotation *)annotation;

@end

NS_ASSUME_NONNULL_END
