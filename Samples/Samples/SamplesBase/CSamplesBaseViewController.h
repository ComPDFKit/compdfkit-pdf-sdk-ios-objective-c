//
//  CSamplesBaseViewController.h
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

NS_ASSUME_NONNULL_BEGIN

@class CPDFDocument;

@interface CSamplesBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *openfileButton;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@property (weak, nonatomic) IBOutlet UITextView *commandLineTextView;

- (IBAction)buttonItemClick_run:(id)sender;

- (IBAction)buttonItemClick_openFile:(id)sender;

- (instancetype)initWithDocument:(CPDFDocument *)document;

@end

NS_ASSUME_NONNULL_END
