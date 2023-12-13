//
//  CPDFDrawPencilKitFuncView.h
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

typedef NS_ENUM(NSInteger, CPDFDrawPencilKitFuncType) {
    CPDFDrawPencilKitFuncType_Eraser,
    CPDFDrawPencilKitFuncType_Cancel,
    CPDFDrawPencilKitFuncType_Done,
};

@class CPDFDrawPencilKitFuncView;
@protocol CPDFDrawPencilViewDelegate <NSObject>

- (void)drawPencilFuncView:(CPDFDrawPencilKitFuncView *)view eraserBtn:(UIButton *)btn;

- (void)drawPencilFuncView:(CPDFDrawPencilKitFuncView *)view saveBtn:(UIButton *)btn;

- (void)drawPencilFuncView:(CPDFDrawPencilKitFuncView *)view cancelBtn:(UIButton *)btn;

@end

@interface CPDFDrawPencilKitFuncView : UIView

@property(nonatomic,assign) id<CPDFDrawPencilViewDelegate> delegate;

- (void)resetAllSubviews;

@end
