//
//  CPDFEditViewController.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//


#import <UIKit/UIKit.h>
#if __has_include(<ComPDFKit_Tools/ComPDFKit_Tools.h>)
#import <ComPDFKit_Tools/CPDFEditToolBar.h>
#else
#import "CPDFEditToolBar.h"
#endif


NS_ASSUME_NONNULL_BEGIN

@interface CPDFEditViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CPDFEditMode editMode;

@property (nonatomic, readonly) CPDFView *pdfView;

- (instancetype)initWithPDFView:(CPDFView *)pdfView;


@end

NS_ASSUME_NONNULL_END
