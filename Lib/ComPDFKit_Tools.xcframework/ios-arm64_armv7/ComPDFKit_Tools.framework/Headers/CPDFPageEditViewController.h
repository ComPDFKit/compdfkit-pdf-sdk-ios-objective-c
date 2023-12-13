//
//  CPDFPageEditViewController.h
//  ComPDFKit_Tools
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#if __has_include(<ComPDFKit_Tools/ComPDFKit_Tools.h>)
#import <ComPDFKit_Tools/ComPDFKit_Tools.h>
#else
#import "ComPDFKit_Tools.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class CPDFPageEditViewController;

@protocol CPDFPageEditViewControllerDelegate <NSObject>

@optional

- (void)pageEditViewControllerDone:(CPDFPageEditViewController *)pageEditViewController;

- (void)pageEditViewController:(CPDFPageEditViewController *)pageEditViewController pageIndex:(NSInteger)pageIndex isPageEdit:(BOOL)isPageEdit;

@end

@interface CPDFPageEditViewController : CPDFThumbnailViewController

@property (nonatomic, weak) id<CPDFPageEditViewControllerDelegate> pageEditDelegate;

@property (nonatomic, readonly) BOOL isPageEdit;

- (void)beginEdit;

@end

NS_ASSUME_NONNULL_END
