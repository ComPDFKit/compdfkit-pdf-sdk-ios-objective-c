//
//  PDFOutlineViewController.h
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
@class CPDFOutlineViewController;
@class CPDFView;
@class CPDFOutline;

@protocol CPDFOutlineViewControllerDelegate <NSObject>

- (void)outlineViewController:(CPDFOutlineViewController *)outlineViewController pageIndex:(NSInteger)pageIndex;

@end

@interface CPDFOutlineViewController : UIViewController

@property (nonatomic, weak) id<CPDFOutlineViewControllerDelegate> delegate;
@property (nonatomic, readonly) CPDFView *pdfView;

- (instancetype)initWithPDFView:(CPDFView *)pdfView;

@end

NS_ASSUME_NONNULL_END
