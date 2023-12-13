//
//  KMPDFPageSelectView.h
//  PDFConnoisseur
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CDigitalSelectType) {
    CDigitalSelectTypeNonw = 0,
    CDigitalSelectTypeCertificate,
    CDigitalSelectTypeSelfSigned
};

@class CDigitalTypeSelectView;

@protocol CDigitalTypeSelectViewDelegate <NSObject>

@optional

- (void)CDigitalTypeSelectViewUse:(CDigitalTypeSelectView *)digitalTypeSelectView;

- (void)CDigitalTypeSelectViewCreate:(CDigitalTypeSelectView *)digitalTypeSelectView;

@end

@interface CDigitalTypeSelectView : UIView

@property (nonatomic, weak) id<CDigitalTypeSelectViewDelegate> delegate;

@property (nonatomic, copy)void (^pageFromTo)(NSInteger, NSInteger);
- (void)showinView:(UIView *)superView;
- (void)dissView;

@end
