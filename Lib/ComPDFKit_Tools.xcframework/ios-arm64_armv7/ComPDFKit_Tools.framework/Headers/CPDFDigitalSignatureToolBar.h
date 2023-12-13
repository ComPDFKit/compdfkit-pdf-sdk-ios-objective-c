//
//  CPDFDigitalSignatureToolBar.h
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

@class CPDFListView;
@class CPDFDigitalSignatureToolBar;
@class CPDFSignature;

@protocol CPDFDigitalSignatureToolBarDelegate <NSObject>

@optional

- (void)verifySignatureBar:(CPDFDigitalSignatureToolBar *)pdfSignatureBar souceButton:(UIButton *)souceButton;

- (void)addSignatureBar:(CPDFDigitalSignatureToolBar *)pdfSignatureBar souceButton:(UIButton *)souceButton;

@end


@interface CPDFDigitalSignatureToolBar : UIView

@property (nonatomic, readonly) CPDFListView *pdfListView;

@property (nonatomic, strong) UIViewController *parentVC;

@property (nonatomic, weak) id<CPDFDigitalSignatureToolBarDelegate> delegate;

- (instancetype)initWithPDFListView:(CPDFListView *)pdfListView;

- (void)updateStatusWithsignatures:(NSArray<CPDFSignature *> *) signatures;


@end

NS_ASSUME_NONNULL_END
