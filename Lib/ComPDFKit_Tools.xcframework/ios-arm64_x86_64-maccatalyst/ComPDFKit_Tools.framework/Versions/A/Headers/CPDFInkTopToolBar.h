//
//  CPDFFreehandView.h
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

typedef NS_ENUM(NSInteger, CPDFInkTopToolBarSelect) {
    CPDFInkTopToolBarSetting = 0,
    CPDFInkTopToolBarErase,
    CPDFInkTopToolBarUndo,
    CPDFInkTopToolBarRedo,
    CPDFInkTopToolBarClear,
    CPDFInkTopToolBarSave
};

@class CPDFInkTopToolBar;

@protocol CPDFInkTopToolBarDelegate <NSObject>

@optional

- (void)inkTopToolBar:(CPDFInkTopToolBar *)inkTopToolBar tag:(CPDFInkTopToolBarSelect)tag isSelect:(BOOL)isSelect;

@end

@interface CPDFInkTopToolBar : UIView

@property (nonatomic, weak) id<CPDFInkTopToolBarDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

NS_ASSUME_NONNULL_END
