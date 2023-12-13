//
//  CPDFEditToolBar.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CPDFEditMode) {
    CPDFEditModeText,
    CPDFEditModeImage,
    CPDFEditModeAll
};

@class CPDFView,CPDFEditToolBar;
NS_ASSUME_NONNULL_BEGIN
@protocol CPDFEditToolBarDelegate <NSObject>

@optional

- (void)editClickInToolBar:(CPDFEditToolBar*)toolBar editMode:(CPDFEditMode)mode;
- (void)propertyEditDidClickInToolBar:(CPDFEditToolBar *)toolBar;
- (void)redoDidClickInToolBar:(CPDFEditToolBar *)toolBar;
- (void)undoDidClickInToolBar:(CPDFEditToolBar *)toolBar;

@end

@interface CPDFEditToolBar : UIView

@property (nonatomic, readonly) CPDFView *pdfView;
@property (nonatomic, weak) id<CPDFEditToolBarDelegate> delegate;

@property(nonatomic, readonly) CPDFEditMode editToolBarSelectType;

- (instancetype)initWithPDFView:(CPDFView *)pdfView;

- (void)updateButtonState;

@end
NS_ASSUME_NONNULL_END
