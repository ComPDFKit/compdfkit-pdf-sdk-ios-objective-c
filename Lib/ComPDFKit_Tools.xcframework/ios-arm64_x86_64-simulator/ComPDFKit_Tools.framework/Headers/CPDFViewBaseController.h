//
//  CPDFViewBaseController.h
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

#import <ComPDFKit_Tools/CPDFConfiguration.h>

@class CPDFListView;
@class CPDFPopMenu;
@class CNavigationBarTitleButton;
@class CNavigationRightView;
@class CPDFConfiguration;
@class CPDFViewBaseController;
@class CPDFSignature;
@class CActivityIndicatorView;

@protocol CPDFViewBaseControllerDelete <NSObject>

- (void)PDFViewBaseControllerDissmiss:(CPDFViewBaseController *_Nonnull)baseControllerDelete;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CPDFViewBaseController : UIViewController

@property(nonatomic, readonly) NSString *filePath;

@property(nonatomic, readonly) CPDFListView *pdfListView;

@property(nonatomic, readonly) CPDFPopMenu *popMenu;

@property(nonatomic, strong) NSString *navigationTitle;

@property(nonatomic, strong) CNavigationBarTitleButton * titleButton;

@property(nonatomic, strong) CNavigationRightView *rightView;

@property (nonatomic, weak) id<CPDFViewBaseControllerDelete> delegate;

@property (nonatomic, readonly) UIBarButtonItem *thumbnailBarItem;

@property (nonatomic, readonly) UIBarButtonItem *backBarItem;

@property (nonatomic, strong) NSArray<CPDFSignature *> * signatures;

@property(nonatomic, strong) CActivityIndicatorView *loadingView;

@property(nonatomic, readonly) CPDFConfiguration *configuration;

@property (nonatomic) CPDFToolFunctionTypeState functionTypeState;

@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerViewController;

- (instancetype)initWithFilePath:(NSString *)filePath password:(nullable NSString *)password;

- (instancetype)initWithFilePath:(NSString *)filePath password:(nullable NSString *)password configuration:(CPDFConfiguration *)configuration;

- (void)reloadDocumentWithFilePath:(NSString *)filePath password:(nullable NSString *)password completion:(void (^)(BOOL result))completion;

- (void)initWitNavigationTitle;

- (void)enterPDFShare;

- (void)enterPDFAddFile;

- (void)enterPDFPageEdit;

- (void)setTitleRefresh;

- (void)selectDocumentRefresh;

- (void)shareRefresh;

- (void)PDFViewCurrentPageDidChanged:(CPDFListView *)pdfView;

- (void)PDFViewDocumentDidLoaded:(CPDFListView *)pdfView;

- (void)buttonItemClicked_thumbnail:(id)sender;

- (void)buttonItemClicked_back:(id)sender;

- (void)titleButtonClickd:(UIButton *)button;

- (void)buttonItemClicked_Search:(id)sender;

- (void)buttonItemClicked_Bota:(id)sender;

- (void)buttonItemClicked_More:(id)sender;

- (void)openFileWithUrls:(NSArray<NSURL *> *)urls;

@end

NS_ASSUME_NONNULL_END
