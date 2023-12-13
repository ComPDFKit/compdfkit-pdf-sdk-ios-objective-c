//
//  CCreateCertificateInfoViewController.h
//  ComPDFKit_Tools
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CPDFSignatureWidgetAnnotation;
@class CCreateCertificateInfoViewController;
@class CPDFSignatureCertificate;
@class CPDFSignatureConfig;

@protocol CCreateCertificateInfoViewControllerDelegate <NSObject>

@optional

- (void)createCertificateInfoViewControllerSave:(CCreateCertificateInfoViewController *)createCertificateInfoViewController PKCS12Cert:(NSString *)path password:(NSString *)password config:(CPDFSignatureConfig *)config;

- (void)createCertificateInfoViewControllerCancel:(CCreateCertificateInfoViewController *)createCertificateInfoViewController;

@end

@interface CCreateCertificateInfoViewController : UIViewController

@property (nonatomic, weak) id<CCreateCertificateInfoViewControllerDelegate> delegate;

- (instancetype)initWithAnnotation:(CPDFSignatureWidgetAnnotation *)annotation;

@end

NS_ASSUME_NONNULL_END
