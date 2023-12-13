//
//  CSignatureTypeSelectView.h
//  ComPDFKit_Tools
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CSignatureSelectType) {
    CSignatureSelectTypeNonw = 0,
    CSignatureSelectTypeElectronic,
    CSignatureSelectTypeDigital
};

@class CSignatureTypeSelectView;

@protocol CSignatureTypeSelectViewDelegate <NSObject>

@optional

- (void)signatureTypeSelectViewElectronic:(CSignatureTypeSelectView *)signatureTypeSelectView;

- (void)signatureTypeSelectViewDigital:(CSignatureTypeSelectView *)signatureTypeSelectView;

@end

@interface CSignatureTypeSelectView : UIView

@property (nonatomic, weak) id<CSignatureTypeSelectViewDelegate> delegate;

- (void)showinView:(UIView *)superView;

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
