//
//  CPDFAnnotationToolBar.h
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

#if __has_include(<ComPDFKit_Tools/ComPDFKit_Tools.h>)
#import <ComPDFKit_Tools/CPDFListView.h>
#else
#import "CPDFListView.h"
#endif

typedef NS_ENUM(NSInteger, CPDFToolbarSelectedIndex) {
    CPDFToolbarNone = 0,
    CPDFToolbarNote,
    CPDFToolbarHighlight,
    CPDFToolbarUnderline,
    CPDFToolbarStrikeout,
    CPDFToolbarSquiggly,
    CPDFToolbarShapeCircle,
    CPDFToolbarShapeRectangle,
    CPDFToolbarShapeArrow,
    CPDFToolbarShapeLine,
    CPDFToolbarFreehand,
    CPDFToolbarPencilDrawing,
    CPDFToolbarFreeText,
    CPDFToolbarSignature,
    CPDFToolbarStamp,
    CPDFToolbarImage,
    CPDFToolbarLink,
    CPDFToolbarLSound,
};

NS_ASSUME_NONNULL_BEGIN

@class CPDFAnnotationToolBar;
@class CPDFListView;
@class CPDFInkTopToolBar;
@class CPDFDrawPencilKitFuncView;
@class CAnnotationManage;

@protocol CPDFAnnotationBarDelegate <NSObject>

@optional

- (void)annotationBarClick:(CPDFAnnotationToolBar *)annotationBar clickAnnotationMode:(CPDFViewAnnotationMode)annotationMode forSelected:(BOOL)isSelected forButton:(UIButton *)button;

@end

@interface CPDFAnnotationToolBar : UIView

@property (nonatomic, assign) NSInteger shapeStyle;

@property (nonatomic, weak) id<CPDFAnnotationBarDelegate> delegate;

@property (nonatomic, strong) UIViewController *parentVC;

@property (nonatomic, readonly) CPDFListView *pdfListView;

@property (nonatomic, strong) CPDFInkTopToolBar *topToolBar;

@property (nonatomic, strong) CPDFDrawPencilKitFuncView *drawPencilFuncView;

- (instancetype)initAnnotationManage:(CAnnotationManage *)annotationManage;

- (void)reloadData;

- (void)updatePropertiesButtonState;

- (void)updateUndoRedoState;

- (void)buttonItemClicked_openAnnotation:(id)button;

- (void)buttonItemClicked_openModel:(id)button;

- (void)openSignatureAnnotation:(CPDFSignatureWidgetAnnotation *)signatureAnnotation;

- (void)addStampAnnotationWithPage:(CPDFPage *)page point:(CGPoint)point;

- (void)addImageAnnotationWithPage:(CPDFPage *)page point:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
