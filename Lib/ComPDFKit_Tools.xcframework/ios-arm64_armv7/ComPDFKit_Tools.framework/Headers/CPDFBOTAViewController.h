//
//  CPDFBOTAViewController.h
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

typedef NS_ENUM(NSInteger, CPDFBOTATypeState) {
    CPDFBOTATypeStateOutline = (1UL << 0),
    CPDFBOTATypeStateBookmark =(1UL << 1),
    CPDFBOTATypeStateAnnotation = (1UL << 2)
};

@class CPDFBOTAViewController;
@class CPDFView;

@protocol CPDFBOTAViewControllerDelegate <NSObject>

@required

- (void)botaViewControllerDismiss:(CPDFBOTAViewController *) botaViewController;

@end

@interface CPDFBOTAViewController : UIViewController

@property (nonatomic, readonly) CPDFView *pdfView;

@property (nonatomic, weak) id<CPDFBOTAViewControllerDelegate> delegate;

- (instancetype)initWithPDFView:(CPDFView *)pdfView;

- (instancetype)initCustomizeWithPDFView:(CPDFView *)pdfView navArrays:(NSArray *)botaTypes;


@end

NS_ASSUME_NONNULL_END
