//
//  CSamplesBaseViewController.m
//  ComPDFKit_Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CSamplesBaseViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The UI, drawn using xib, is the base class for all samples classes
//-----------------------------------------------------------------------------------------

@interface CSamplesBaseViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@end

@implementation CSamplesBaseViewController

#pragma mark - Initializers

- (instancetype)initWithDocument:(CPDFDocument *)document {
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nil];
    
    self.document = document;
    return self;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

#pragma mark - Action

- (IBAction)buttonItemClick_openFile:(id)sender {
}

- (IBAction)buttonItemClick_run:(id)sender {
}
@end
