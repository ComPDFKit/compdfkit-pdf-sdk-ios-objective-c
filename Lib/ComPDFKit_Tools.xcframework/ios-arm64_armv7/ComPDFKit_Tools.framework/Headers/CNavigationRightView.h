//
//  CNavigationRightView.h
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

typedef NS_ENUM(NSUInteger, CNavigationRightType) {
    CNavigationRightTypeSearch = 0,
    CNavigationRightTypeBota,
    CNavigationRightTypeMore
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CNavigationRightAction

@interface CNavigationRightAction : NSObject

+ (CNavigationRightAction *)actionWithImage:(UIImage *)image tag:(NSUInteger)tag;

@property(nonatomic, readonly) UIImage *image;

@property(nonatomic, readonly) NSUInteger tag;

@end

#pragma mark - CNavigationRightView

@interface CNavigationRightView : UIView

- (instancetype)initWithRightActions:(NSArray<CNavigationRightAction *> *)rightActions clickBack:(void (^)(NSUInteger tag))clickBack;

- (instancetype)initWithDefaultItemsClickBack:(void (^)(NSUInteger tag))clickBack;

@end

NS_ASSUME_NONNULL_END
