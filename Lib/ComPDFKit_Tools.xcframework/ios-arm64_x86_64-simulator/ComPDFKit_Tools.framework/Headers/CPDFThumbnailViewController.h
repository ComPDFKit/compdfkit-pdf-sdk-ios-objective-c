//
//  PDFThumbnailViewController.h
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
@class CPDFThumbnailViewController;
@class CPDFView;

@protocol CPDFThumbnailViewControllerDelegate <NSObject>

- (void)thumbnailViewController:(CPDFThumbnailViewController *)thumbnailViewController pageIndex:(NSInteger)pageIndex;

- (void)thumbnailViewControllerDismiss:(CPDFThumbnailViewController *)thumbnailViewController;

@end

@interface CPDFThumbnailViewController : UIViewController

@property (nonatomic, readonly) CPDFView *pdfView;
@property (nonatomic, weak) id<CPDFThumbnailViewControllerDelegate> delegate;

- (void)setCollectViewSize:(CGSize)size;

- (instancetype)initWithPDFView:(CPDFView *)pdfView;

@end

NS_ASSUME_NONNULL_END
