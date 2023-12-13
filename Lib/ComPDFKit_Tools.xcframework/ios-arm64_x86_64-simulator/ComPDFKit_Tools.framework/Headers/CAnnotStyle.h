//
//  CAnnotStyle.h
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
#import "CPDFListView.h"

NS_ASSUME_NONNULL_BEGIN

@class CPDFPage;
@class CPDFBorder;
@class CPDFAnnotation;

@interface CAnnotStyle : NSObject

@property (nonatomic, readonly) CPDFViewAnnotationMode annotMode;

@property (nonatomic, readonly) NSArray *annotations;

@property (nonatomic, readonly) BOOL isSelectAnnot;

- (instancetype)initWithAnnotionMode:(CPDFViewAnnotationMode)annotionMode annotations:(NSArray *)annotations;

#pragma mark - Common

- (UIColor *)color;
- (void)setColor:(UIColor *)color;

- (CGFloat)opacity;
- (void)setOpacity:(CGFloat)opacity;

- (CPDFBorderStyle)style;
- (void)setStyle:(CPDFBorderStyle)style;

- (NSArray *)dashPattern;
- (void)setDashPattern:(NSArray *)dashPattern;

- (CGFloat)lineWidth;
- (void)setLineWidth:(CGFloat)lineWidth;

#pragma mark - Line

- (CPDFLineStyle)startLineStyle;
- (void)setStartLineStyle:(CPDFLineStyle)startLineStyle;

- (CPDFLineStyle)endLineStyle;
- (void)setEndLineStyle:(CPDFLineStyle)endLineStyle;

#pragma mark - FreeText

- (UIColor *)fontColor;
- (void)setFontColor:(UIColor *)fontColor;

- (CGFloat)fontSize;
- (void)setFontSize:(CGFloat)fontSize;

- (NSString *)fontName;
- (void)setFontName:(NSString *)fontName;

- (NSTextAlignment)alignment;
- (void)setAlignment:(NSTextAlignment)alignment;

#pragma mark - Circle&Square

- (UIColor *)interiorColor;
- (void)setInteriorColor:(UIColor *)interiorColor;

- (CGFloat)interiorOpacity;
- (void)setInteriorOpacity:(CGFloat)interiorOpacity;

@end

NS_ASSUME_NONNULL_END
