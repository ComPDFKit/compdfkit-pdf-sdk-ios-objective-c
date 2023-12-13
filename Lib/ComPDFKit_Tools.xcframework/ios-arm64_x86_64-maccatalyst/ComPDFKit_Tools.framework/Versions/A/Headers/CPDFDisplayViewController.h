//
//  CPDFDisplayViewController.h
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

@class CPDFView;
@class CPDFDisplayViewController;

#pragma mark - CPDFDisplayViewDelegate

@protocol CPDFDisplayViewDelegate <NSObject>

@optional

- (void)displayViewControllerDismiss:(CPDFDisplayViewController *)displayViewController;

@end

#pragma mark - CPDFDisplayViewController

@interface CPDFDisplayViewController : UIViewController

@property (nonatomic, readonly) CPDFView * pdfview;

@property (nonatomic, assign) id<CPDFDisplayViewDelegate> delegate;

- (instancetype)initWithPDFView:(CPDFView *)pdfview;

- (void)updateDisplayView;

@end

NS_ASSUME_NONNULL_END
