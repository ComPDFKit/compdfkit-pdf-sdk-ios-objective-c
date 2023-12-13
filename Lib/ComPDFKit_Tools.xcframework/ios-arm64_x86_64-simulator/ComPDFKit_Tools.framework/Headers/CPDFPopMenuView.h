//
//  CPDFPopMenuView.h
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

typedef NS_ENUM(NSInteger, CPDFPopMenuViewType) {
    CPDFPopMenuViewTypeSetting = 0,
    CPDFPopMenuViewTypePageEdit,
    CPDFPopMenuViewTypeInfo,
    CPDFPopMenuViewTypeShare,
    CPDFPopMenuViewTypeAddFile
};


@class CPDFPopMenuView;

@protocol CPDFPopMenuViewDelegate <NSObject>

- (void)menuDidClickAtView:(CPDFPopMenuView*)view clickType:(CPDFPopMenuViewType)viewType;

@end
@interface CPDFPopMenuView : UIView

@property (nonatomic, weak) id<CPDFPopMenuViewDelegate> delegate;

@end

