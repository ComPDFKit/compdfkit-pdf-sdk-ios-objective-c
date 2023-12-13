//
//  CPDFViewController.m
//   ContentEditor
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CPDFViewController.h"

#import <ComPDFKit/ComPDFKit.h>
#import <AVFAudio/AVFAudio.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CPDFViewController () <CPDFSoundPlayBarDelegate,CPDFAnnotationBarDelegate,CPDFToolsViewControllerDelegate,CPDFNoteOpenViewControllerDelegate,CPDFBOTAViewControllerDelegate,CPDFEditToolBarDelegate,CPDFFormBarDelegate,CPDFListViewDelegate,CPDFSignatureViewControllerDelegate,CPDFPageEditViewControllerDelegate,CPDFKeyboardToolbarDelegate,CPDFDigitalSignatureToolBarDelegate,CCertificateViewControllerDelegate,CDigitalTypeSelectViewDelegate,CCreateCertificateInfoViewControllerDelegate,CPDFSigntureVerifyViewControllerDelegate,CSignatureTypeSelectViewDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong) CPDFAnnotationToolBar *annotationBar;

@property(nonatomic, strong) CPDFFormToolBar *formBar;

@property(nonatomic, strong) CPDFSoundPlayBar *soundPlayBar;

@property(nonatomic, strong) CAnnotationManage *annotationManage;

@property(nonatomic, strong) CPDFEditToolBar * toolBar;

@property(nonatomic, strong) CPDFEditViewController *baseVC;

@property(nonatomic, assign) CPDFEditMode editMode;

@property(nonatomic, strong) CPDFSignatureWidgetAnnotation * signatureAnnotation;

@property(nonatomic, assign) CGRect addImageRect;

@property(nonatomic, retain) CPDFPage *addImagePage;

@property (nonatomic, strong) CPDFDigitalSignatureToolBar *digitalSignatureBar;

@property (nonatomic, strong) CPDFSigntureViewController *signtureViewController;

@property (nonatomic, strong) CPDFSigntureVerifyViewController *signtureVerifyViewController;

@property (nonatomic, strong) UIDocumentPickerViewController *pkcs12DocumentPickerViewController;

@property (nonatomic, assign) BOOL isSelctSignature;

@end

@implementation CPDFViewController


- (void)viewDidLoad {
    [super viewDidLoad];
        
    CPDFEditingConfig *editingConfig = [[CPDFEditingConfig alloc]init];
    editingConfig.editingBorderWidth = 1.0;
    editingConfig.editingOffsetGap = 5;
    self.pdfListView.editingConfig = editingConfig;
    
    self.isSelctSignature = NO;
    
    [self initAnnotationBar];
    [self initWithEditTool];
    [self initWithFormTool];
    [self initDigitalSignatureBar];
    
    if(self.configuration.enterToolModel == CPDFToolFunctionTypeStateSignature) {
        [self enterSignatureMode];
    } else if (self.configuration.enterToolModel == CPDFToolFunctionTypeStateEdit) {
        [self enterEditMode];
    } else if (self.configuration.enterToolModel == CPDFToolFunctionTypeStateForm) {
        [self enterFormMode];
    } else if (self.configuration.enterToolModel == CPDFToolFunctionTypeStateAnnotation) {
        [self enterAnnotationMode];
    }  else {
        [self enterViewerMode];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signatureHaveChangeDidChangeNotification:) name:CSignatureHaveChangeDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signatureTrustCerDidChangeNotification:) name:CSignatureTrustCerDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDFPageDidRemoveAnnotationNotification:) name:CPDFPageDidRemoveAnnotationNotification object:nil];
}

- (void)initAnnotationBar {
    self.annotationManage = [[CAnnotationManage alloc] initWithPDFView:self.pdfListView];
    
    self.annotationBar = [[CPDFAnnotationToolBar alloc] initAnnotationManage:self.annotationManage];
    
    CGFloat height = 44.0;
    if (@available(iOS 11.0, *))
        height += self.view.safeAreaInsets.bottom;
    
    self.annotationBar.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height);
    self.annotationBar.delegate = self;
    [self.annotationBar setParentVC:self];
    [self.view addSubview:self.annotationBar];
}

- (void)initWithEditTool {
    if(!self.toolBar){
        self.toolBar = [[CPDFEditToolBar alloc] initWithPDFView:self.pdfListView];
    }
    
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
}

- (void)initWithFormTool {
    if(!self.formBar){
        self.formBar = [[CPDFFormToolBar  alloc] initAnnotationManage:self.annotationManage];
    }
    self.formBar.delegate = self;
    self.formBar.parentVC = self;
    [self.view addSubview:self.formBar];
}

- (void)initDigitalSignatureBar {
    self.digitalSignatureBar = [[CPDFDigitalSignatureToolBar alloc] initWithPDFListView:self.pdfListView];
    
    CGFloat height = 60.0;
    if (@available(iOS 11.0, *))
        height += self.view.safeAreaInsets.bottom;
    
    self.digitalSignatureBar.delegate = self;
}

- (void)initWitNavigationTitle {
    [super initWitNavigationTitle];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if([self.popMenu superview]) {
        if (@available(iOS 11.0, *)) {
            [self.popMenu showMenuInRect:CGRectMake(self.view.frame.size.width - self.view.safeAreaInsets.right - 250, CGRectGetMaxY(self.navigationController.navigationBar.frame), 250, 250)];
        } else {
            // Fallback on earlier versions
            [self.popMenu showMenuInRect:CGRectMake(self.view.frame.size.width - 250, CGRectGetMaxY(self.navigationController.navigationBar.frame), 250, 250)];
        }
    }
    
    CGFloat height = 44.0;
    
    if (@available(iOS 11.0, *))
        height += self.view.safeAreaInsets.bottom;
    
    CGFloat bottomHeight = 0;
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        self.annotationBar.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        bottomHeight = self.self.annotationBar.frame.size.height;
    } else if(CToolModelEdit == self.pdfListView.toolModel){
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        bottomHeight = self.self.toolBar.frame.size.height;
    } else if(CToolModelForm == self.pdfListView.toolModel){
        self.formBar.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height);
        bottomHeight = self.self.formBar.frame.size.height;
    }
    
    if(self.digitalSignatureBar.superview) {
        height += 14;
        self.digitalSignatureBar.frame = CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height);
    }
    
    height = CGRectGetMaxY(self.navigationController.navigationBar.frame) ;
    if([self.signtureViewController.view superview]) {
        self.signtureViewController.view.frame = CGRectMake(0, height, self.view.frame.size.width, 44.0);
    }
    
    CGFloat tPosY = 0;
    CGFloat tBottomY = 0;
    
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        if (!self.navigationController.navigationBarHidden) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height-frame.size.height;
                self.annotationBar.frame = frame;
            }];
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
            
            tBottomY = self.annotationBar.frame.size.height;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height;
                self.annotationBar.frame = frame;
            }];
        }
    } else {
        tPosY = 0;
        if (!self.navigationController.navigationBarHidden) {
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
        }
    }
    
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 10 + bottomHeight;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
}

#pragma mark - Public Methods

- (void)selectDocumentRefresh {
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        self.pdfListView.annotationMode = CPDFViewAnnotationModeNone;
        [self.annotationBar updatePropertiesButtonState];
        [self.annotationBar reloadData];
        [self.annotationBar updateUndoRedoState];
    }else if(CToolModelForm == self.pdfListView.toolModel) {
        [self.formBar initUndoRedo];
    }
}

- (void)reloadDocumentWithFilePath:(NSString *)filePath password:(nullable NSString *)password completion:(void (^)(BOOL result))completion {
    
    [self.navigationController.view setUserInteractionEnabled:NO];
    
    if (![self.loadingView superview]) {
        [self.view addSubview:self.loadingView];
    }
    [self.loadingView startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL fileURLWithPath:filePath];
        CPDFDocument *document = [[CPDFDocument alloc] initWithURL:url];
        if([document isLocked]) {
            [document unlockWithPassword:password];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.view setUserInteractionEnabled:YES];
            [self.loadingView stopAnimating];
            [self.loadingView removeFromSuperview];
            
            if (document.error && document.error.code != CPDFDocumentPasswordError) {
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedString(@"Sorry PDF Reader Can't open this pdf file!", nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:okAction];
                if (completion) {
                    completion(NO);
                }
            } else {
                self.pdfListView.document = document;
                
                if (completion) {
                    completion(YES);
                }
            }
        });
    });
}

#pragma mark - Private

- (void)enterEditMode {
    self.functionTypeState = CPDFToolFunctionTypeStateEdit;

    [self selectDocumentRefresh];
    
    self.toolBar.hidden = NO;
    self.annotationBar.hidden = YES;
    self.formBar.hidden = YES;
    self.pdfListView.toolModel = CToolModelEdit;
    
    if (CPDFEditModeText == self.toolBar.editToolBarSelectType) {
        [self.pdfListView beginEditingLoadType:CEditingLoadTypeText];
        [self.pdfListView setShouAddEditAreaType:CAddEditingAreaTypeText];
    } else if (CPDFEditModeImage == self.toolBar.editToolBarSelectType) {
        [self.pdfListView beginEditingLoadType:CEditingLoadTypeImage];
        [self.pdfListView setShouAddEditAreaType:CAddEditingAreaTypeImage];
    } else {
        [self.pdfListView beginEditingLoadType:CEditingLoadTypeText | CEditingLoadTypeImage];
        [self.pdfListView setShouAddEditAreaType:CAddEditingAreaTypeNone];
    }
    
    self.navigationTitle = NSLocalizedString(@"Content Edit", nil);
    [self.titleButton setTitle:self.navigationTitle forState:UIControlStateNormal];
    
    [self.toolBar updateButtonState];
    
    CGRect frame = self.toolBar.frame;
    frame.origin.y = self.view.bounds.size.height-frame.size.height;
    self.toolBar.frame = frame;
    
    if([self.digitalSignatureBar superview]) {
        [self.digitalSignatureBar removeFromSuperview];
    }
    
    [self viewWillLayoutSubviews];
}

- (void)enterAnnotationMode {
    self.functionTypeState = CPDFToolFunctionTypeStateAnnotation;

    self.toolBar.hidden = YES;
    self.annotationBar.hidden = NO;
    self.formBar.hidden = YES;
    if (self.pdfListView.isEdited) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.pdfListView commitEditing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdfListView endOfEditing];
            });
        });
    } else {
        [self.pdfListView endOfEditing];
    }
    self.pdfListView.toolModel = CToolModelAnnotation;
    self.navigationTitle = NSLocalizedString(@"Annotation", nil);
    [self.titleButton setTitle:self.navigationTitle forState:UIControlStateNormal];
    
    CGFloat tPosY = 0;
    CGFloat tBottomY = 0;
    CGRect frame = self.annotationBar.frame;
    frame.origin.y = self.view.bounds.size.height-frame.size.height;
    self.annotationBar.frame = frame;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    tBottomY = self.annotationBar.frame.size.height;
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 10 + self.annotationBar.frame.size.height;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
    
    if([self.digitalSignatureBar superview]) {
        [self.digitalSignatureBar removeFromSuperview];
    }
    
    [self viewWillLayoutSubviews];
}

- (void)enterViewerMode {
    self.functionTypeState = CPDFToolFunctionTypeStateViewer;

    self.toolBar.hidden = YES;
    self.formBar.hidden = YES;
    self.annotationBar.hidden = YES;
    if (self.pdfListView.isEdited) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.pdfListView commitEditing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdfListView endOfEditing];
            });
        });
    } else {
        [self.pdfListView endOfEditing];
    }
    self.pdfListView.toolModel = CToolModelViewer;
    self.navigationTitle = NSLocalizedString(@"Viewer", nil);
    [self.titleButton setTitle:self.navigationTitle forState:UIControlStateNormal];
    
    CGRect frame = self.annotationBar.frame;
    frame.origin.y = self.view.bounds.size.height;
    self.annotationBar.frame = frame;
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
    
    if([self.digitalSignatureBar superview]) {
        [self.digitalSignatureBar removeFromSuperview];
    }
}

- (void)enterFormMode {
    self.functionTypeState = CPDFToolFunctionTypeStateForm;

    self.toolBar.hidden = YES;
    self.annotationBar.hidden = YES;
    self.formBar.hidden = NO;
    if (self.pdfListView.isEdited) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.pdfListView commitEditing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdfListView endOfEditing];
            });
        });
    } else {
        [self.pdfListView endOfEditing];
    }
    self.pdfListView.toolModel = CToolModelForm;
    self.navigationTitle = NSLocalizedString(@"Form", nil);
    [self.titleButton setTitle:self.navigationTitle forState:UIControlStateNormal];
    
    CGFloat tPosY = 0;
    CGFloat tBottomY = 0;
    CGRect frame = self.formBar.frame;
    frame.origin.y = self.view.bounds.size.height-frame.size.height;
    self.formBar.frame = frame;
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    tBottomY = self.formBar.frame.size.height;
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 10 + self.formBar.frame.size.height;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
    
    if([self.digitalSignatureBar superview]) {
        [self.digitalSignatureBar removeFromSuperview];
    }
    
    [self viewWillLayoutSubviews];
}

- (void)enterSignatureMode {
    self.functionTypeState = CPDFToolFunctionTypeStateSignature;

    if (self.pdfListView.isEdited) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.pdfListView commitEditing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pdfListView endOfEditing];
            });
        });
    } else {
        [self.pdfListView endOfEditing];
    }
    
    if(self.isSelctSignature) {
        self.pdfListView.toolModel = CToolModelForm;
    } else {
        self.pdfListView.toolModel = CToolModelViewer;
    }
    [self.view addSubview:self.digitalSignatureBar];
    self.navigationTitle = NSLocalizedString(@"Digital Signature", nil);
    [self.titleButton setTitle:self.navigationTitle forState:UIControlStateNormal];
    
    CGFloat tPosY = 0;
    CGFloat tBottomY = 0;
    CGRect frame = self.digitalSignatureBar.frame;
    frame.origin.y = self.view.bounds.size.height-frame.size.height;
    self.digitalSignatureBar.frame = frame;
    
    tBottomY = self.digitalSignatureBar.frame.size.height;
    if([self.signtureViewController.view superview]) {
        tPosY = self.signtureViewController.view.frame.size.height;
    }
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 10 + tBottomY;
        inset.top = tPosY;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
}

- (void)setTitleRefresh {
    if (CPDFToolFunctionTypeStateEdit == self.functionTypeState) {
        [self enterEditMode];
    } else if (CPDFToolFunctionTypeStateAnnotation == self.functionTypeState) {
        [self enterAnnotationMode];
    } else if(CPDFToolFunctionTypeStateForm == self.functionTypeState) {
        [self enterFormMode];
    } else if(CPDFToolFunctionTypeStateSignature == self.functionTypeState){
        [self enterSignatureMode];
    } else {
        [self enterViewerMode];
    }
}

- (CPDFSigntureViewController *)signtureViewController {
    if (!_signtureViewController) {
        _signtureViewController = [[CPDFSigntureViewController alloc] init];
    }
    return _signtureViewController;
}

- (NSString *)tagString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-ddHH:mm:ssSS"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (void)writeSignatureToWidget:(CPDFSignatureWidgetAnnotation *)widget PKCS12Cert:(NSString *)path password:(NSString *)password config:(CPDFSignatureConfig *)config lockDocument:(BOOL)isLock {
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", homePath, @"Signature"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@_Widget_%@.pdf",writeDirectoryPath,self.pdfListView.document.documentURL.lastPathComponent.stringByDeletingPathExtension,[self tagString]];
    if([[NSFileManager defaultManager] fileExistsAtPath:writeFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:writeFilePath error:nil];
    }
    
    CPDFSignatureConfigItem *reaItem = nil;
    CPDFSignatureConfigItem *locaItem = nil;
    
    NSString *locationStr = @"";
    NSString *reasonStr = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"none", nil)];
    
    for (CPDFSignatureConfigItem *item in config.contents) {
        if ([item.key isEqual:@"Reason"]) {
            reaItem = item;
            locationStr = reaItem.value;
        } else if ([item.key isEqual:@"Location"]) {
            locaItem = item;
            locationStr = locaItem.value;
        }
    }
    
    
    BOOL isSuccess = [self.pdfListView.document writeSignatureToURL:[NSURL fileURLWithPath:writeFilePath] withWidget:widget PKCS12Cert:path password:password location:locationStr reason:reasonStr permissions:CPDFSignaturePermissionsForbidChange];
    
    if (isSuccess) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (([[NSFileManager defaultManager] fileExistsAtPath:writeFilePath])) {
                
                [self reloadDocumentWithFilePath:writeFilePath password:nil completion:^(BOOL result) {
                    
                }];
            }
        });
    }
    
}

#pragma mark - Action

- (void)buttonItemClicked_Bota:(id)sender {
    CPDFBOTAViewController *botaViewController = [[CPDFBOTAViewController alloc] initCustomizeWithPDFView:self.pdfListView navArrays:@[@(CPDFBOTATypeStateOutline),@(CPDFBOTATypeStateBookmark),@(CPDFBOTATypeStateAnnotation)]];
    
    botaViewController.delegate = self;
    
    AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    
    presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:botaViewController presentingViewController:self];
    botaViewController.transitioningDelegate = presentationController;
    
    [self presentViewController:botaViewController animated:YES completion:nil];
}

- (void) titleButtonClickd:(UIButton *) button {
    CPDFToolsViewController * toolsVc = [[CPDFToolsViewController alloc] initCustomizeWithToolArrays:@[@(CPDFToolFunctionTypeStateViewer),@(CPDFToolFunctionTypeStateEdit),@(CPDFToolFunctionTypeStateAnnotation),@(CPDFToolFunctionTypeStateForm),@(CPDFToolFunctionTypeStateSignature)]];
    toolsVc.delegate = self;
    AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:toolsVc presentingViewController:self];
    toolsVc.transitioningDelegate = presentationController;
    [self presentViewController:toolsVc animated:YES completion:nil];
}

#pragma - CPDFEditToolBarDelegate

- (void)editClickInToolBar:(CPDFEditToolBar*)toolBar editMode:(CPDFEditMode)mode {
    self.editMode = mode;
}

- (void)undoDidClickInToolBar:(CPDFEditToolBar *)toolBar{
    [self.pdfListView editTextUndo];
}

- (void)redoDidClickInToolBar:(CPDFEditToolBar *)toolBar{
    [self.pdfListView editTextRedo];
}

- (void)propertyEditDidClickInToolBar:(CPDFEditToolBar *)toolBar{
    [self showMenuList];
}


- (void)showMenuList {
    _baseVC = [[CPDFEditViewController alloc] initWithPDFView:self.pdfListView];
    _baseVC.editMode = self.editMode;
    if((self.editMode == CPDFEditModeText || self.editMode == CPDFEditModeImage) && self.pdfListView.editStatus != CEditingSelectStateEmpty){
        
        AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
        
        presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:self.baseVC presentingViewController:self];
        self.baseVC.transitioningDelegate = presentationController;
        
        [self presentViewController:self.baseVC animated:YES completion:nil];
    } else if (CAddEditingAreaTypeText == self.pdfListView.shouAddEditAreaType) {
        _baseVC.editMode = CPDFEditModeText;
        AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
        
        presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:self.baseVC presentingViewController:self];
        self.baseVC.transitioningDelegate = presentationController;
        
        [self presentViewController:self.baseVC animated:YES completion:nil];
        
    }
}

#pragma mark - CPDFViewDelegate

- (void)PDFViewEditingSelectStateDidChanged:(CPDFView *)pdfView {
    if([pdfView.editingArea isKindOfClass:[CPDFEditImageArea class]]) {
        self.editMode = CPDFEditModeImage;
    }else if([pdfView.editingArea isKindOfClass:[CPDFEditTextArea class]]) {
        self.editMode  = CPDFEditModeText;
    }
    
    [self.toolBar updateButtonState];
}

- (void)PDFViewShouldBeginEditing:(CPDFView *)pdfView textView:(UITextView *)textView forAnnotation:(CPDFFreeTextAnnotation *)annotation {
    CPDFKeyboardToolbar *keyBoadrdToolbar = [[CPDFKeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    keyBoadrdToolbar.delegate = self;
    [keyBoadrdToolbar bindToTextView:textView];
}

- (void)PDFViewEditingAddTextArea:(CPDFView * _Nonnull)pdfView addPage:(CPDFPage * _Nonnull )page addRect:(CGRect)rect {
    UIColor *fontColor = [CPDFTextProperty sharedManager].fontColor;
    if (fontColor) {
        CGFloat red, green, blue, alpha;
        [fontColor getRed:&red green:&green blue:&blue alpha:&alpha];
        fontColor = [UIColor colorWithRed:red green:green blue:blue alpha:[CPDFTextProperty sharedManager].textOpacity];
    }
    if(!fontColor)
        fontColor = [UIColor blackColor];
    
    UIFont *font = [UIFont fontWithName:[CPDFTextProperty sharedManager].fontName size:[CPDFTextProperty sharedManager].fontSize];
    if(!font)
        font = [UIFont fontWithName:@"Helvetica-Oblique" size:10];
    
    CEditAttributes *atributes = [[CEditAttributes alloc]init];
    atributes.font = font;
    atributes.fontColor = fontColor;
    atributes.isBold = [CPDFTextProperty sharedManager].isBold;
    atributes.isItalic = [CPDFTextProperty sharedManager].isItalic;
    atributes.alignment = [CPDFTextProperty sharedManager].textAlignment;
    
    [self.pdfListView createStringBounds:rect withAttributes:atributes page:page];
}

- (void)PDFViewEditingAddImageArea:(CPDFView * _Nonnull)pdfView addPage:(CPDFPage * _Nonnull)page addRect:(CGRect)rect {
    self.addImageRect = rect;
    self.addImagePage = page;
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)PDFViewDocumentDidLoaded:(CPDFView *)pdfView {
    [super PDFViewDocumentDidLoaded:self.pdfListView];
    
    if ([self.digitalSignatureBar superview]) {
        [self.digitalSignatureBar updateStatusWithsignatures:self.signatures];
    }
    
    if([self.signtureViewController.view superview]) {
        [self verifySignature];
    }
}

#pragma mark - CPDFListViewDelegate

- (void)PDFListViewPerformTouchEnded:(CPDFListView *)pdfView {
    CGFloat tPosY = 0;
    CGFloat tBottomY = 0;
    
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height-frame.size.height;
                self.annotationBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 1.0;
                self.annotationBar.topToolBar.alpha = 1.0;
                self.annotationBar.drawPencilFuncView.alpha = 1.0;
                
                self.signtureViewController.view.alpha = 1.0;
            }];
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
            
            tBottomY = self.annotationBar.frame.size.height;
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height;
                self.annotationBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 0.0;
                self.annotationBar.topToolBar.alpha = 0.0;
                self.annotationBar.drawPencilFuncView.alpha = 0.0;
                self.signtureViewController.view.alpha = 0.0;
            }];
        }
    } else if ([self.digitalSignatureBar superview]) {
        CGFloat tTopY = 0;
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.digitalSignatureBar.frame;
                frame.origin.y = self.view.bounds.size.height-frame.size.height;
                self.digitalSignatureBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 1.0;
                
                self.signtureViewController.view.alpha = 1.0;
            }];
            tPosY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
            
            if([self.digitalSignatureBar superview])  {
                tBottomY = self.digitalSignatureBar.frame.size.height;
            }
            
            if([self.signtureViewController.view superview]) {
                tTopY = self.signtureViewController.view.frame.size.height;
            }
            
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.digitalSignatureBar.frame;
                frame.origin.y = self.view.bounds.size.height;
                self.digitalSignatureBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 0.0;
                self.signtureViewController.view.alpha = 0.0;
                
            }];
        }
    } else {
        CGFloat tPosY = 0;
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                self.pdfListView.pageSliderView.alpha = 1.0;
                self.signtureViewController.view.alpha = 1.0;
            }];
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
            
        } else {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                self.pdfListView.pageSliderView.alpha = 0.0;
                self.signtureViewController.view.alpha = 0.0;
            }];
        }
    }
    
    if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 10 + self.annotationBar.frame.size.height;
        self.pdfListView.documentView.contentInset = inset;
    } else{
        UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
        inset.bottom = 0;
        self.pdfListView.documentView.contentInset = inset;
    }
}

- (void)PDFListViewEditNote:(CPDFListView *)pdfListView forAnnotation:(CPDFAnnotation *)annotation {
    if([annotation isKindOfClass:[CPDFLinkAnnotation class]]) {
        [self.annotationBar buttonItemClicked_openAnnotation:self.titleButton];
    } else if ([annotation isKindOfClass:[CPDFWidgetAnnotation class]]) {
        [self.formBar buttonItemClicked_openOption:annotation];
    } else {
        CGRect rect = [self.pdfListView convertRect:annotation.bounds fromPage:annotation.page];
        CPDFNoteOpenViewController *noteVC = [[CPDFNoteOpenViewController alloc]initWithAnnotation:annotation];
        noteVC.delegate = self;
        [noteVC showViewController:self inRect:rect];
    }
}

- (void)PDFListViewChangedAnnotationType:(CPDFListView *)pdfListView forAnnotationMode:(CPDFViewAnnotationMode)annotationMode {
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        [self.annotationBar reloadData];
    }else if(CToolModelForm == self.pdfListView.toolModel) {
        [self.formBar reloadData];
    }
}

- (void)PDFListViewPerformUrl:(CPDFListView *)pdfView withContent:(NSString *)content {
    NSURL * url = [NSURL URLWithString:content];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)PDFListViewPerformAddStamp:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page {
    [self.annotationBar addStampAnnotationWithPage:page point:point];
}

- (void)PDFListViewPerformAddImage:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page {
    [self.annotationBar addImageAnnotationWithPage:page point:point];
}

- (BOOL)PDFListViewerTouchEndedIsAudioRecordMedia:(CPDFListView *)pdfListView {
    if (CPDFMediaStateAudioRecord == [CPDFMediaManager shareManager].mediaState) {
        [self PDFListViewPerformTouchEnded:self.pdfListView];
        return YES;
    }
    return NO;
}

- (void)PDFListViewPerformCancelMedia:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page {
    [CPDFMediaManager shareManager].mediaState = CPDFMediaStateStop;
}

- (void)PDFListViewPerformRecordMedia:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page {
    if([self.soundPlayBar superview]) {
        if(self.soundPlayBar.soundState == CPDFSoundStatePlay) {
            [self.soundPlayBar stopAudioPlay];
            [self.soundPlayBar removeFromSuperview];
        } else if (self.soundPlayBar.soundState == CPDFSoundStateRecord) {
            [self.soundPlayBar stopRecord];
            [self.soundPlayBar removeFromSuperview];
        }
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusDenied) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                
            } else {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
    }
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        NSInteger pageindex = [self.pdfListView.document indexForPage:page];
        [CPDFMediaManager shareManager].mediaState = CPDFMediaStateAudioRecord;
        [CPDFMediaManager shareManager].pageNum = pageindex;
        [CPDFMediaManager shareManager].ptInPdf = point;
        
        _soundPlayBar = [[CPDFSoundPlayBar alloc] initWithStyle:self.annotationManage.annotStyle];
        _soundPlayBar.delegate = self;
        [_soundPlayBar showInView:self.pdfListView soundState:CPDFSoundStateRecord];
        [_soundPlayBar startAudioRecord];
        
    } else {
        return;
    }
}

- (void)PDFListViewPerformPlay:(CPDFListView *)pdfView forAnnotation:(CPDFSoundAnnotation *)annotation {
    NSString *filePath = [annotation mediaPath];
    if (filePath) {
        NSURL *URL = [NSURL fileURLWithPath:filePath];
        
        _soundPlayBar = [[CPDFSoundPlayBar alloc] initWithStyle:self.annotationManage.annotStyle];
        _soundPlayBar.delegate = self;
        [_soundPlayBar showInView:self.pdfListView soundState:CPDFSoundStatePlay];
        [_soundPlayBar setURL:URL];
        [_soundPlayBar startAudioPlay];
        [CPDFMediaManager shareManager].mediaState = CPDFMediaStateVedioPlaying;
    }
}

- (void)PDFListViewPerformSignatureWidget:(CPDFListView *)pdfView forAnnotation:(CPDFSignatureWidgetAnnotation *)annotation {
    if(CToolModelAnnotation == self.pdfListView.toolModel) {
        [self.annotationBar openSignatureAnnotation:annotation];
    }else if(CToolModelViewer == self.pdfListView.toolModel) {
        self.signatureAnnotation = annotation;
        CPDFSignature *signature = [annotation signature];
        
        if((signature.signers.count > 0) && (self.signatures.count > 0)) {
            
            CPDFSigntureVerifyDetailsViewController *vc = [[CPDFSigntureVerifyDetailsViewController alloc] init];
            CNavigationController *nav = [[CNavigationController alloc]initWithRootViewController:vc];
            vc.signature = signature;
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            if ([self.digitalSignatureBar superview]) {
                self.signatureAnnotation = annotation;
                CSignatureTypeSelectView *signatureTypeSelectView = [[CSignatureTypeSelectView alloc] initWithFrame:self.view.frame height:216.0];
                signatureTypeSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                signatureTypeSelectView.delegate = self;
                [signatureTypeSelectView showinView:self.view];
                
            } else {
                self.signatureAnnotation = annotation;
                AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
                CPDFSignatureViewController *signatureVC = [[CPDFSignatureViewController alloc] initWithStyle:nil];
                presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:signatureVC presentingViewController:self];
                signatureVC.delegate = self;
                signatureVC.transitioningDelegate = presentationController;
                [self presentViewController:signatureVC animated:YES completion:nil];
            }
        }
    }
}

- (void)PDFListViewEditProperties:(CPDFListView *)pdfListView forAnnotation:(CPDFAnnotation *)annotation {
    if(CToolModelAnnotation == self.pdfListView.toolModel){
        [self.annotationBar buttonItemClicked_openAnnotation:self.titleButton];
    }else if(CToolModelForm == self.pdfListView.toolModel) {
        [self.formBar buttonItemClicked_open:annotation];
    }
}

- (void)PDFListViewContentEditProperty:(CPDFListView *)pdfView point:(CGPoint)point {
    if([pdfView.editingArea isKindOfClass:[CPDFEditImageArea class]]) {
        self.editMode = CPDFEditModeImage;
    } else if([pdfView.editingArea isKindOfClass:[CPDFEditTextArea class]]) {
        self.editMode  = CPDFEditModeText;
    }
    [self showMenuList];
    [self.toolBar updateButtonState];
}

- (void)PDFViewCurrentPageDidChanged:(CPDFView *)pdfView {
    if([pdfView.editingArea isKindOfClass:[CPDFEditImageArea class]]) {
        self.editMode = CPDFEditModeImage;
    }else if([pdfView.editingArea isKindOfClass:[CPDFEditTextArea class]]) {
        self.editMode  = CPDFEditModeText;
    }
    
    [self.toolBar updateButtonState];
    [super PDFViewCurrentPageDidChanged:pdfView];
}

#pragma mark - CPDFKeyboardToolbarDelegate

- (void)keyboardShouldDissmiss:(CPDFKeyboardToolbar *)toolbar {
    [self.pdfListView commitEditAnnotationFreeText];
    self.pdfListView.annotationMode = CPDFViewAnnotationModeNone;
    [self.annotationBar reloadData];
}

#pragma mark - CPDFAnnotationBarDelegate

- (void)annotationBarClick:(CPDFAnnotationToolBar *)annotationBar clickAnnotationMode:(CPDFViewAnnotationMode)annotationMode forSelected:(BOOL)isSelected forButton:(UIButton *)button {
    if(CPDFViewAnnotationModeInk == annotationMode || CPDFViewAnnotationModePencilDrawing == annotationMode) {
        CGFloat tPosY = 0;
        if(isSelected) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height;
                self.annotationBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 0.0;
                
                UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
                inset.bottom = 0;
                self.pdfListView.documentView.contentInset = inset;
            }];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = self.annotationBar.frame;
                frame.origin.y = self.view.bounds.size.height-frame.size.height;
                self.annotationBar.frame = frame;
                self.pdfListView.pageSliderView.alpha = 1.0;
            }];
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            tPosY = self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
            
            UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
            inset.bottom = self.annotationBar.frame.size.height;
            self.pdfListView.documentView.contentInset = inset;
        }
    } else if (CPDFViewAnnotationModeSound == annotationMode && !isSelected) {
        if(CPDFSoundStateRecord == self.soundPlayBar.soundState) {
            [self.soundPlayBar stopRecord];
            
        } else if (CPDFSoundStatePlay== self.soundPlayBar.soundState) {
            [self.soundPlayBar stopAudioPlay];
        }
    }
}

#pragma mark - CPDFNoteOpenViewControllerDelegate

- (void)getNoteOpenViewController:(CPDFNoteOpenViewController *)noteOpenVC content:(NSString *)content isDelete:(BOOL)isDelete {
    if (isDelete) {
        [noteOpenVC.annotation.page removeAnnotation:noteOpenVC.annotation];
        [self.pdfListView setNeedsDisplayForPage:noteOpenVC.annotation.page];
        if([self.pdfListView.activeAnnotations containsObject:noteOpenVC.annotation]) {
            NSMutableArray *activeAnnotations = [NSMutableArray arrayWithArray:self.pdfListView.activeAnnotations];
            [activeAnnotations removeObject:noteOpenVC.annotation];
            [self.pdfListView updateActiveAnnotations:activeAnnotations];
        }
    } else {
        if([noteOpenVC.annotation isKindOfClass:[CPDFMarkupAnnotation class]]) {
            CPDFMarkupAnnotation *markupAnnotation = (CPDFMarkupAnnotation *)noteOpenVC.annotation;
            [markupAnnotation setContents:content?:@""];
        } else if(([noteOpenVC.annotation isKindOfClass:[CPDFTextAnnotation class]])){
            if(content && content.length > 0) {
                noteOpenVC.annotation.contents = content?:@"";
            } else {
                if([self.pdfListView.activeAnnotations containsObject:noteOpenVC.annotation]) {
                    [self.pdfListView updateActiveAnnotations:@[]];
                }
                [noteOpenVC.annotation.page removeAnnotation:noteOpenVC.annotation];
                [self.pdfListView setNeedsDisplayForPage:noteOpenVC.annotation.page];
            }
        } else {
            noteOpenVC.annotation.contents = content?:@"";
        }
    }
}

#pragma mark - CPDFSoundPlayBarDelegate

- (void)soundPlayBarRecordFinished:(CPDFSoundPlayBar *)soundPlayBar withFile:(NSString *)filePath {
    CPDFPage *page = [self.pdfListView.document pageAtIndex:[CPDFMediaManager shareManager].pageNum];
    CPDFSoundAnnotation *annotation = [[CPDFSoundAnnotation alloc] initWithDocument:self.pdfListView.document];
    
    if ([annotation setMediaPath:filePath]) {
        CGRect bounds = annotation.bounds;
        bounds.origin.x = [CPDFMediaManager shareManager].ptInPdf.x-bounds.size.width/2.0;
        bounds.origin.y = [CPDFMediaManager shareManager].ptInPdf.y-bounds.size.height/2.0;
        annotation.bounds = bounds;
        [self.pdfListView addAnnotation:annotation forPage:page];
    }
    
    [CPDFMediaManager shareManager].mediaState = CPDFMediaStateStop;
    [self.pdfListView stopRecord];
}

- (void)soundPlayBarRecordCancel:(CPDFSoundPlayBar *)soundPlayBar {
    if(CPDFSoundStateRecord == self.soundPlayBar.soundState) {
        [self.pdfListView stopRecord];
    }
    [CPDFMediaManager shareManager].mediaState = CPDFMediaStateStop;
}

- (void)soundPlayBarPlayClose:(CPDFSoundPlayBar *)soundPlayBar {
    [CPDFMediaManager shareManager].mediaState = CPDFMediaStateStop;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (self.pkcs12DocumentPickerViewController == controller) {
        BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
        if(fileUrlAuthozied){
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
            NSError *error;
            [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
                
                NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@", @"Documents",@"Files"];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
                    [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:documentFolder] withIntermediateDirectories:YES attributes:nil error:nil];
                
                NSString * documentPath = [documentFolder stringByAppendingPathComponent:[newURL lastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
                    [[NSFileManager defaultManager] copyItemAtPath:newURL.path toPath:documentPath error:NULL];
                    
                }
                
                NSURL *url = [NSURL fileURLWithPath:documentPath];
                CImportCertificateViewController *certificateViewController = [[CImportCertificateViewController alloc] initWithP12FilePath:url Annotation:self.signatureAnnotation];
                certificateViewController.delegate = self;
                [self presentViewController:certificateViewController animated:YES completion:nil];
                
            }];
            [urls.firstObject stopAccessingSecurityScopedResource];
        }
    } else if (self.documentPickerViewController == controller) {
        BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
        if(fileUrlAuthozied){
            if (self.pdfListView.isEditing) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if(self.pdfListView.isEdited)
                        [self.pdfListView commitEditing];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.pdfListView endOfEditing];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            if(self.pdfListView.document.isModified)
                                [self.pdfListView.document writeToURL:self.pdfListView.document.documentURL];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self openFileWithUrls:urls];
                                
                                if([self.signtureViewController.view superview]) {
                                    [self.signtureViewController.view removeFromSuperview];
                                }
                                
                            });
                        });
                    });
                });
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if(self.pdfListView.document.isModified) {
                        [self.pdfListView.document writeToURL:self.pdfListView.document.documentURL];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self openFileWithUrls:urls];
                        if([self.signtureViewController.view superview]) {
                            [self.signtureViewController.view removeFromSuperview];
                        }
                    });
                });
            }
            
        }
    }
}

#pragma mark - CDigitalTypeSelectViewDelegate

- (void)CDigitalTypeSelectViewUse:(CDigitalTypeSelectView *)digitalTypeSelectView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *documentTypes = @[(NSString *)kUTTypePKCS12];
            self.pkcs12DocumentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
            self.pkcs12DocumentPickerViewController.delegate = self;
            
            [self presentViewController:self.pkcs12DocumentPickerViewController animated:YES completion:nil];
        });
    });
}

- (void)CDigitalTypeSelectViewCreate:(CDigitalTypeSelectView *)digitalTypeSelectView {
    CCreateCertificateInfoViewController *createCertificateViewController = [[CCreateCertificateInfoViewController alloc] initWithAnnotation:self.signatureAnnotation];
    createCertificateViewController.delegate = self;
    [self presentViewController:createCertificateViewController animated:YES completion:nil];
}

#pragma mark - CCertificateViewControllerDelegate

- (void)importCertificateViewControllerSave:(CImportCertificateViewController *)importCertificateViewController PKCS12Cert:(nonnull NSString *)path password:(nonnull NSString *)password config:(nonnull CPDFSignatureConfig *)config {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self writeSignatureToWidget:self.signatureAnnotation PKCS12Cert:path password:password config:config lockDocument:YES];
}

- (void)importCertificateViewControllerCancel:(CImportCertificateViewController *)importCertificateViewController {
    [self.signatureAnnotation reset];
    [self.signatureAnnotation updateAppearanceStream];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.pdfListView setNeedsDisplayForPage:self.signatureAnnotation.page];
    
    CSignatureTypeSelectView *signatureTypeSelectView = [[CSignatureTypeSelectView alloc] initWithFrame:self.view.frame height:216.0];
    signatureTypeSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    signatureTypeSelectView.delegate = self;
    [signatureTypeSelectView showinView:self.view];

}

#pragma mark - CCreateCertificateInfoViewControllerDelegate

- (void)createCertificateInfoViewControllerSave:(CCreateCertificateInfoViewController *)createCertificateInfoViewController PKCS12Cert:(nonnull NSString *)path password:(nonnull NSString *)password config:(nonnull CPDFSignatureConfig *)config {
    [self.pdfListView setNeedsDisplayForPage:self.signatureAnnotation.page];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self writeSignatureToWidget:self.signatureAnnotation PKCS12Cert:path password:password config:config lockDocument:YES];
}

- (void)createCertificateInfoViewControllerCancel:(CCreateCertificateInfoViewController *)createCertificateInfoViewController {
    [self.signatureAnnotation reset];
    [self.signatureAnnotation updateAppearanceStream];
    [self.pdfListView setNeedsDisplayForPage:self.signatureAnnotation.page];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    CSignatureTypeSelectView *signatureTypeSelectView = [[CSignatureTypeSelectView alloc] initWithFrame:self.view.frame height:216.0];
    signatureTypeSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    signatureTypeSelectView.delegate = self;
    [signatureTypeSelectView showinView:self.view];
}

-(void)verifySignature {
    NSArray *signatures = self.signatures;
    if (signatures.count > 0) {
        [self.navigationController.view setUserInteractionEnabled:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (CPDFSignature *sign in self.signatures) {
                [sign verifySignatureWithDocument:self.pdfListView.document];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.view setUserInteractionEnabled:YES];
                
                __block __typeof(self) blockSelf = self;
                [self.signtureViewController updateCertState:signatures];
                self.signtureViewController.callback = ^{
                    blockSelf.signtureVerifyViewController = [[CPDFSigntureVerifyViewController alloc] init];
                    blockSelf.signtureVerifyViewController.delegate = blockSelf;
                    blockSelf.signtureVerifyViewController.signatures = signatures;
                    blockSelf.signtureVerifyViewController.PDFListView = blockSelf.pdfListView;
                    CNavigationController *nav = [[CNavigationController alloc]initWithRootViewController:blockSelf.signtureVerifyViewController];
                    [blockSelf presentViewController:nav animated:YES completion:nil];
                };
                if(![self.signtureViewController.view superview]) {
                    [self.view addSubview:self.signtureViewController.view];
                    [self.view bringSubviewToFront:self.signtureViewController.view];
                }
                CGFloat height = CGRectGetMaxY(self.navigationController.navigationBar.frame) ;
                self.signtureViewController.view.frame = CGRectMake(0, height, self.view.frame.size.width, 44.0);
                CGFloat tPosY = 0;
                if([self.signtureViewController.view superview]) {
                    tPosY = self.signtureViewController.view.frame.size.height;
                }
                
                if (CPDFDisplayDirectionVertical == [CPDFKitConfig  sharedInstance].displayDirection) {
                    UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
                    inset.top = tPosY;
                    self.pdfListView.documentView.contentInset = inset;
                } else{
                    UIEdgeInsets inset = self.pdfListView.documentView.contentInset;
                    self.pdfListView.documentView.contentInset = inset;
                }
            });
        });
    } else {
        if([self.signtureViewController.view superview]) {
            [self.signtureViewController.view removeFromSuperview];
            self.signtureViewController = nil;
        }
    }
}


#pragma mark - CPDFSignatureViewControllerDelegate

- (void)verifySignatureBar:(CPDFDigitalSignatureToolBar *)pdfSignatureBar souceButton:(UIButton *)souceButton {
    [self verifySignature];
}

- (void)addSignatureBar:(CPDFDigitalSignatureToolBar *)pdfSignatureBar souceButton:(UIButton *)souceButton {
  
    self.isSelctSignature = souceButton.isSelected;
    
    if(self.isSelctSignature) {
        self.pdfListView.toolModel = CToolModelForm;
        self.pdfListView.annotationMode = CPDFViewFormModeSign;
    } else {
        self.pdfListView.toolModel = CToolModelViewer;
    }
}

#pragma mark - CSignatureTypeSelectViewDelegate

- (void)signatureTypeSelectViewElectronic:(CSignatureTypeSelectView *)signatureTypeSelectView {
    AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    CPDFSignatureViewController *signatureVC = [[CPDFSignatureViewController alloc] initWithStyle:nil];
    presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:signatureVC presentingViewController:self];
    signatureVC.delegate = self;
    signatureVC.transitioningDelegate = presentationController;
    [self presentViewController:signatureVC animated:YES completion:nil];
}

- (void)signatureTypeSelectViewDigital:(CSignatureTypeSelectView *)signatureTypeSelectView {
    CDigitalTypeSelectView *digitalTypeSelect = [[CDigitalTypeSelectView alloc] init];
    digitalTypeSelect.delegate = self;
    digitalTypeSelect.frame = self.view.frame;
    digitalTypeSelect.pageFromTo = ^(NSInteger from, NSInteger to) {
        
    };
    [digitalTypeSelect showinView:self.view];
}


#pragma mark - Notification

-(void)signatureHaveChangeDidChangeNotification:(NSNotification*)notification {
    if (self.pdfListView == notification.object) {
        //        [self.pdfListView layoutDocumentView];
        NSArray *signatures = [self.pdfListView.document signatures];
        NSMutableArray *mSignatures = [NSMutableArray array];
        for (CPDFSignature *sign in signatures) {
            if (sign.signers.count > 0) {
                [mSignatures addObject:sign];
            }
        }
        self.signatures = mSignatures;
        
        [self.digitalSignatureBar updateStatusWithsignatures:self.signatures];
        
        if([self.signtureViewController.view superview]) {
            [self verifySignature];
        }
    }
}

-(void)signatureTrustCerDidChangeNotification:(NSNotification*)notification {
    NSArray *signatures = [self.pdfListView.document signatures];
    NSMutableArray *mSignatures = [NSMutableArray array];
    for (CPDFSignature *sign in signatures) {
        if (sign.signers.count > 0) {
            [mSignatures addObject:sign];
        }
    }
    self.signatures = mSignatures;
    if([self.signtureViewController.view superview]) {
        [self verifySignature];
    }
    [self.digitalSignatureBar updateStatusWithsignatures:self.signatures];
    
    if (self.signtureVerifyViewController) {
        self.signtureVerifyViewController.signatures = signatures;
        self.signtureVerifyViewController.PDFListView = self.pdfListView;
        [self.signtureVerifyViewController reloadData];
    }
}

- (void)PDFPageDidRemoveAnnotationNotification:(NSNotification *)notification {
    CPDFAnnotation *annotation = [notification object];
    
    if ([annotation isKindOfClass:[CPDFSoundAnnotation class]]) {
        [self.soundPlayBar stopAudioPlay];
        if ([self.soundPlayBar isDescendantOfView:self.view]) {
            [self.soundPlayBar removeFromSuperview];
        }
    }
}

#pragma mark - CPDFToolsViewControllerDelegate

- (void)CPDFToolsViewControllerDismiss:(CPDFToolsViewController *) viewController selectItemAtIndex:(CPDFToolFunctionTypeState)selectIndex {
    if(CPDFToolFunctionTypeStateViewer == selectIndex) {
        //viewwer
        [self enterViewerMode];
    }else if(CPDFToolFunctionTypeStateEdit == selectIndex) {
        [self enterEditMode];
    }else if(CPDFToolFunctionTypeStateAnnotation == selectIndex){
        //Annotation
        [self enterAnnotationMode];
    }else if(CPDFToolFunctionTypeStateForm == selectIndex) {
        [self.formBar updateStatus];
        [self enterFormMode];
    }else if(CPDFToolFunctionTypeStateSignature == selectIndex) {
        [self enterSignatureMode];
    }
}

#pragma mark - CPDFBOTAViewControllerDelegate

- (void)botaViewControllerDismiss:(CPDFBOTAViewController *)botaViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CPDFSignatureViewControllerDelegate

- (void)signatureViewControllerDismiss:(CPDFSignatureViewController *)signatureViewController {
    self.signatureAnnotation = nil;
}

- (void)signatureViewController:(CPDFSignatureViewController *)signatureViewController image:(UIImage *)image {
    if(self.signatureAnnotation) {
        [self.signatureAnnotation signWithImage:image];
        [self.pdfListView setNeedsDisplayForPage:self.signatureAnnotation.page];
        self.signatureAnnotation = nil;
    }
}

#pragma mark - Action

- (void)buttonItemClicked_thumbnail:(id)sender {
    if(self.pdfListView.activeAnnotations.count > 0) {
        [self.pdfListView updateActiveAnnotations:@[]];
        [self.pdfListView setNeedsDisplayForVisiblePages];
    }
    
    if(self.pdfListView.isEditing) {
        if(self.pdfListView.isEdited) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.pdfListView commitEditing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self enterThumbnail];
                });
            });
        } else {
            [self enterThumbnail];
        }
    } else {
        [self enterThumbnail];
    }
}

- (void)enterThumbnail {
    CPDFPageEditViewController *pageEditViewcontroller = [[CPDFPageEditViewController alloc] initWithPDFView:self.pdfListView];
    pageEditViewcontroller.pageEditDelegate = self;
    CNavigationController *nav = [[CNavigationController alloc]initWithRootViewController:pageEditViewcontroller];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CPDFPageEditViewControllerDelegate

- (void)pageEditViewControllerDone:(CPDFPageEditViewController *)pageEditViewController {
    __weak typeof(self) weakSelf = self;
    [pageEditViewController dismissViewControllerAnimated:YES completion:^{
        if (pageEditViewController.isPageEdit) {
            [weakSelf reloadDocumentWithFilePath:self.filePath password:self.pdfListView.document.password completion:^(BOOL result) {
                [weakSelf.pdfListView reloadInputViews];
                [weakSelf selectDocumentRefresh];
            }];
            
            [weakSelf.pdfListView reloadInputViews];
        }
    }];
    
}

- (void)pageEditViewController:(CPDFPageEditViewController *)pageEditViewController pageIndex:(NSInteger)pageIndex isPageEdit:(BOOL)isPageEdit {
    __weak typeof(self) weakSelf = self;
    [pageEditViewController dismissViewControllerAnimated:YES completion:^{
        if (isPageEdit) {
            [weakSelf reloadDocumentWithFilePath:self.filePath password:self.pdfListView.document.password completion:^(BOOL result) {
                [weakSelf.pdfListView reloadInputViews];
                [weakSelf selectDocumentRefresh];
                [self.pdfListView goToPageIndex:pageIndex animated:NO];
            }];
            
            [weakSelf.pdfListView reloadInputViews];
        } else {
            [self.pdfListView goToPageIndex:pageIndex animated:NO];

        }
    }];
}

#pragma mark - imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL * url = nil;
    if (@available(iOS 11.0, *))
        url = info[UIImagePickerControllerImageURL];
    else
        url = info[UIImagePickerControllerMediaURL];
    
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:url.path];
    CGFloat img_width = 0;
    CGFloat img_height = 0;
    CGFloat scaled_width = 149;
    CGFloat scaled_height = 210;
    
    if(image.imageOrientation!=UIImageOrientationUp){
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        img_width = image.size.height;
        img_height = image.size.width;
    } else {
        img_width = image.size.width;
        img_height = image.size.height;
    }
    
    CGFloat scaled = MIN(scaled_width/img_width, scaled_height/img_height);
    scaled_height = img_height*scaled;
    scaled_width = img_width*scaled;
    
    CGRect rect = CGRectMake(self.addImageRect.origin.x, self.addImageRect.origin.y- scaled_height, scaled_width, scaled_height);
    [self.pdfListView createEmptyImage:rect page:self.addImagePage path:url.path];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
