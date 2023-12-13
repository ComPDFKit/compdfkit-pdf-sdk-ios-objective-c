//
//  ViewController.m
//  ComPDFKit_Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CSamplesFuctionViewController.h"

#import "CBookmarkViewController.h"
#import "COutlineViewController.h"
#import "CPDFToImageViewController.h"
#import "CTextSearchViewController.h"
#import "CAnnotaitonViewController.h"
#import "CAnnotationImportExportViewController.h"
#import "CInteractiveFormsViewController.h"
#import "CPDFPageViewController.h"
#import "CImageExtractViewController.h"
#import "CTextExtractViewController.h"
#import "CDocumentInfoViewController.h"
#import "CWatermarkViewController.h"
#import "CBackgroundViewController.h"
#import "CHeaderFooterViewController.h"
#import "CBatesViewController.h"
#import "CRedactViewController.h"
#import "CEncryptViewController.h"
#import "CPDFAViewController.h"
#import "CFlattenedCopyViewController.h"
#import "CDigitalSignatureViewController.h"

#import <ComPDFKit/ComPDFKit.h>

@interface CSamplesFuctionViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *filePaths;

@property(nonatomic, strong) NSString *password;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) CPDFDocument *document;

@end

@implementation CSamplesFuctionViewController

#pragma mark - Initializers

- (instancetype)initWithFilePath:(NSArray *)filePaths password:(NSString *)password {
    if(self = [super init]) {
        self.filePaths = filePaths;
        self.password = password;
    }
    return self;
}

#pragma mark - Accessors

- (NSArray *)dataArray {
    return @[NSLocalizedString(@"Bookmark", nil),
             NSLocalizedString(@"Outline", nil),
             NSLocalizedString(@"PDFToImage", nil),
             NSLocalizedString(@"TextSearch", nil),
             NSLocalizedString(@"Annotation", nil),
             NSLocalizedString(@"AnnotationImportExport", nil),
             NSLocalizedString(@"InteractiveForms", nil),
             NSLocalizedString(@"PDFPage", nil),
             NSLocalizedString(@"ImageExtract", nil),
             NSLocalizedString(@"TextExtract", nil),
             NSLocalizedString(@"DocumentInfo", nil),
             NSLocalizedString(@"Watermark", nil),
             NSLocalizedString(@"Background", nil),
             NSLocalizedString(@"HeaderFooter", nil),
             NSLocalizedString(@"Bates", nil),
             NSLocalizedString(@"PDFRedact", nil),
             NSLocalizedString(@"Encry", nil),
             NSLocalizedString(@"PDFA", nil),
             NSLocalizedString(@"FlattenedCopy", nil),
             NSLocalizedString(@"DigitalSignature", nil)];
    
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.title = NSLocalizedString(@"Samples", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *filePath = self.filePaths[0];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    self.document = [[CPDFDocument alloc] initWithURL:url];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"samples"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"samples"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case CSamplesTypeBookmark:
        {
            CBookmarkViewController *bookmarkVC = [[CBookmarkViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:bookmarkVC animated:YES];
        }
            break;
        case CSamplesTypeOutline:
        {
            
            COutlineViewController *outlineVC = [[COutlineViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:outlineVC animated:YES];
        }
            break;
        case CSamplesTypePDFToImage:
        {
            CPDFToImageViewController *PDFToImageVC = [[CPDFToImageViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:PDFToImageVC animated:YES];
        }
            break;
        case CSamplesTypeTextSearch:
        {
            NSString *filePath = self.filePaths[2];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            CPDFDocument *document = [[CPDFDocument alloc] initWithURL:url];
            CTextSearchViewController *textSearchVC = [[CTextSearchViewController alloc] initWithDocument:document];
            [self.navigationController pushViewController:textSearchVC animated:YES];
        }
            break;
        case CSamplesTypeAnnotation:
        {
            CAnnotaitonViewController *annotationVC = [[CAnnotaitonViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:annotationVC animated:YES];
        }
            break;
        case CSamplesTypeAnnotationImportExport:
        {
            NSString *filePath = self.filePaths[3];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            CPDFDocument *document = [[CPDFDocument alloc] initWithURL:url];
            CAnnotationImportExportViewController *annotationImportExportVC = [[CAnnotationImportExportViewController alloc] initWithDocument:document];
            [self.navigationController pushViewController:annotationImportExportVC animated:YES];
        }
            break;
        case CSamplesTypeInteractiveForms:
        {
            CInteractiveFormsViewController *interactiveFormsVC = [[CInteractiveFormsViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:interactiveFormsVC animated:YES];
        }
            break;
        case CSamplesTypePDFPage:
        {
            CPDFPageViewController *PDFPageVC = [[CPDFPageViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:PDFPageVC animated:YES];
        }
            break;
        case CSamplesTypeImageExtract:
        {
            CImageExtractViewController *imageExtractVC = [[CImageExtractViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:imageExtractVC animated:YES];
        }
            break;
        case CSamplesTypeTextExtract:
        {
            CTextExtractViewController *textExtractVC = [[CTextExtractViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:textExtractVC animated:YES];
        }
            break;
        case CSamplesTypeDocumentInfo:
        {
            CDocumentInfoViewController *documentInfoVC = [[CDocumentInfoViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:documentInfoVC animated:YES];
        }
            break;
        case CSamplesTypeWatermark:
        {
            CWatermarkViewController *watermarkVC = [[CWatermarkViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:watermarkVC animated:YES];
        }
            break;
        case CSamplesTypeBackground:
        {
            CBackgroundViewController *backgroundVC = [[CBackgroundViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:backgroundVC animated:YES];
        }
            break;
        case CSamplesTypeHeaderFooter:
        {
            CHeaderFooterViewController *headerfooterVC = [[CHeaderFooterViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:headerfooterVC animated:YES];
        }
            break;
        case CSamplesTypePDFBates:
        {
            CBatesViewController *batesVC = [[CBatesViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:batesVC animated:YES];
        }
            break;
        case CSamplesTypePDFRedact:
        {
            CRedactViewController *redactVC = [[CRedactViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:redactVC animated:YES];
        }
            break;
        case CSamplesTypeEncry:
        {
            CEncryptViewController *encryptVC = [[CEncryptViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:encryptVC animated:YES];
        }
            break;
        case CSamplesTypePDFA:
        {
            CPDFAViewController *PDFAVC = [[CPDFAViewController alloc] initWithDocument:self.document];
            [self.navigationController pushViewController:PDFAVC animated:YES];
        }
            break;
        case CSamplesTypeFlattenedCopy:
        {
            NSString *filePath = self.filePaths[3];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            CPDFDocument *document = [[CPDFDocument alloc] initWithURL:url];
            CFlattenedCopyViewController *flattenedCopyVC = [[CFlattenedCopyViewController alloc] initWithDocument:document];
            [self.navigationController pushViewController:flattenedCopyVC animated:YES];
        }
            break;
        case CSamplesTypeDigitalSignature:
        {
            NSString *filePath = self.filePaths[0];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            CPDFDocument *document = [[CPDFDocument alloc] initWithURL:url];
            CDigitalSignatureViewController *digitalSignatureViewController = [[CDigitalSignatureViewController alloc] initWithDocument:document];
            [self.navigationController pushViewController:digitalSignatureViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
