//
//  ViewController.h
//  ComPDFKit_Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CSamplesType)  {
    CSamplesTypeBookmark = 0,
    CSamplesTypeOutline,
    CSamplesTypePDFToImage,
    CSamplesTypeTextSearch,
    CSamplesTypeAnnotation,
    CSamplesTypeAnnotationImportExport,
    CSamplesTypeInteractiveForms,
    CSamplesTypePDFPage,
    CSamplesTypeImageExtract,
    CSamplesTypeTextExtract,
    CSamplesTypeDocumentInfo,
    CSamplesTypeWatermark,
    CSamplesTypeBackground,
    CSamplesTypeHeaderFooter,
    CSamplesTypePDFBates,
    CSamplesTypePDFRedact,
    CSamplesTypeEncry,
    CSamplesTypePDFA,
    CSamplesTypeFlattenedCopy,
    CSamplesTypeDigitalSignature
};

@interface CSamplesFuctionViewController : UIViewController

- (instancetype)initWithFilePath:(NSArray *)filePaths password:(NSString *)password;

@end

