//
//  CPDFSignatureViewController.h
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

@class CAnnotStyle;
@class CPDFSignatureViewController;

@protocol CPDFSignatureViewControllerDelegate <NSObject>

@optional

- (void)signatureViewControllerDismiss:(CPDFSignatureViewController *)signatureViewController;

- (void)signatureViewController:(CPDFSignatureViewController *)signatureViewController image:(UIImage *)image;

@end

@interface CPDFSignatureViewController : UIViewController

@property (nonatomic, readonly) CAnnotStyle *annotStyle;

@property (nonatomic, weak) id<CPDFSignatureViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithStyle:(nullable CAnnotStyle *)annotStyle;

@end

NS_ASSUME_NONNULL_END
