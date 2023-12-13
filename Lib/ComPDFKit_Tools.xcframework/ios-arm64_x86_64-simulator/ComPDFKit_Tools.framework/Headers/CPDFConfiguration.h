//
//  CPDFConfiguration.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <ComPDFKit/ComPDFKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CPDFToolFunctionTypeState) {
    CPDFToolFunctionTypeStateViewer,
    CPDFToolFunctionTypeStateEdit,
    CPDFToolFunctionTypeStateAnnotation,
    CPDFToolFunctionTypeStateForm,
    CPDFToolFunctionTypeStatePageEdit,
    CPDFToolFunctionTypeStateSignature,
};

typedef NS_OPTIONS(NSInteger, CPDFViewBarLeftButtonItem) {
    CPDFViewBarLeftButtonItem_Back =            (1UL << 1),
    CPDFViewBarLeftButtonItem_Thumbnail =       (1UL << 2),
};

typedef NS_OPTIONS(NSInteger, CPDFViewBarRightButtonItem) {
    CPDFViewBarRightButtonItem_Search =           (1UL << 3),
    CPDFViewBarRightButtonItem_Bota =             (1UL << 4),
    CPDFViewBarRightButtonItem_More =             (1UL << 5),
};

@interface CNavBarButtonItem : NSObject

@property(nonatomic,readonly)CPDFViewBarLeftButtonItem leftBarItem;

@property(nonatomic,readonly)CPDFViewBarRightButtonItem rightBarItem;

- (instancetype)initWithViewLeftBarButtonItem:(CPDFViewBarLeftButtonItem)barButtonItem;

- (instancetype)initWithViewRightBarButtonItem:(CPDFViewBarRightButtonItem)barButtonItem;

@end

@interface CPDFConfiguration : NSObject

@property (nonatomic, retain) NSArray <CNavBarButtonItem *>* showleftItems;

@property (nonatomic, retain) NSArray <CNavBarButtonItem *>* showRightItems;

@property (nonatomic, assign) CPDFToolFunctionTypeState enterToolModel;

@end

NS_ASSUME_NONNULL_END
