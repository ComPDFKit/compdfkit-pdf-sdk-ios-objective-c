//
//  CPDFFormToolBar.h
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
typedef NS_ENUM(NSInteger, CPDFFormToolbarSelectedIndex) {
    CPDFFromToolbarNone = 0,
    CPDFFormToolbarText,
    CPDFFormToolbarCheckBox,
    CPDFToolbarRadioButton,
    CPDFToolbarComboBox,
    CPDFToolbarList,
    CPDFToolbarButton,
    CPDFToolbarSign,
};

@class CPDFFormToolBar;
@class CPDFListView;
@class CAnnotationManage;

@protocol CPDFFormBarDelegate <NSObject>

@optional
- (void)formBarClick:(CPDFFormToolBar *)pdfFormBar forSelected:(BOOL)isSelected forButton:(UIButton *)button;
@end

@interface CPDFFormToolBar : UIView

@property (nonatomic, readonly) CPDFListView *pdfListView;

@property (nonatomic, weak) id<CPDFFormBarDelegate> delegate;

@property (nonatomic, strong) UIViewController *parentVC;

- (instancetype)initAnnotationManage:(CAnnotationManage *)annotationManage;
- (void)reloadData;
- (void)buttonItemClicked_open:(UIButton *)button;
- (void)buttonItemClicked_openOption:(CPDFWidgetAnnotation *)annotation;
- (void)updateStatus;
- (void)initUndoRedo;

@end
