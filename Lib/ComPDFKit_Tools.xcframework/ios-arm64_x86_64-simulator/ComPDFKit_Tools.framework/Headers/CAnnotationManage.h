//
//  CAnnotationManage.h
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
NS_ASSUME_NONNULL_BEGIN

@class CPDFListView;
@class CAnnotStyle;
@class CPDFAnnotation;

@interface CAnnotationManage : NSObject

@property (nonatomic, readonly) CPDFListView *pdfListView;

@property (nonatomic, readonly) CAnnotStyle *annotStyle;

- (instancetype)initWithPDFView:(CPDFListView *)pdfListView;

- (void)setAnnotStyleFromAnnotations:(NSArray<CPDFAnnotation *> *)annotations;

- (void)setAnnotStyleFromMode:(CPDFViewAnnotationMode)annotationMode;

- (void)refreshPageWithAnnotations:(NSArray *)annotations;
/**
 * Get the default color of highlight annotations.
 */
+ (UIColor *)highlightAnnotationColor;
/**
 * Get the default color of underline annotations.
 */
+ (UIColor *)underlineAnnotationColor;

/**
 * Get the default color of strikeout annotations.
 */
+ (UIColor *)strikeoutAnnotationColor;

/**
 * Get the default color of squiggly annotations.
 */
+ (UIColor *)squigglyAnnotationColor;

/**
 * Get the default color of freehand annotations.
 */
+ (UIColor *)freehandAnnotationColor;

@end

NS_ASSUME_NONNULL_END
