//
//  CPDFSigntureVerifyViewController.h
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

#define CSignatureHaveChangeDidChangeNotification  @"CSignatureHaveChangeDidChangeNotification"

#define CSignatureTrustCerDidChangeNotification  @"CSignatureTrustCerDidChangeNotification"

@class CPDFListView;
@class CPDFSigntureVerifyViewController;

@protocol CPDFSigntureVerifyViewControllerDelegate <NSObject>

@optional

- (void)signtureVerifyViewControllerUpdate:(CPDFSigntureVerifyViewController *)signtureVerifyViewController;

@end

@interface CPDFSigntureVerifyViewController : UIViewController

@property (nonatomic, weak) id<CPDFSigntureVerifyViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *signatures;

@property (nonatomic, strong) CPDFListView *PDFListView;

- (void)reloadData;

@end
