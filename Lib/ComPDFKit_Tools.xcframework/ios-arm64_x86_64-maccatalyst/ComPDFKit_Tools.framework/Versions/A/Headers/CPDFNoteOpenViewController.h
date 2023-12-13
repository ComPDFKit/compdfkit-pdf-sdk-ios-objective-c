//
//  CPDFNoteOpenViewController.h
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

@class CPDFNoteOpenViewController;
@class CPDFAnnotation;

@protocol CPDFNoteOpenViewControllerDelegate <NSObject>

@optional

- (void)getNoteOpenViewController:(CPDFNoteOpenViewController *)noteOpenVC content:(NSString *)content isDelete:(BOOL)isDelete;

@end

@interface CPDFNoteOpenViewController : UIViewController

@property (nonatomic, weak) id<CPDFNoteOpenViewControllerDelegate> delegate;

@property (nonatomic, readonly) CPDFAnnotation * annotation;

- (instancetype)initWithAnnotation:(CPDFAnnotation *)annotation;

- (void)showViewController:(UIViewController *)viewController inRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
