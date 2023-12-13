//
//  CInteractiveFormsViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CInteractiveFormsViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to create and delete interactiveforms using API,
// also help you get interactiveforms list message.
//-----------------------------------------------------------------------------------------

@interface CInteractiveFormsViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSString *exportFilePath;

@property (nonatomic, strong) NSURL *interactiveFormsURL;

@property (nonatomic, strong) NSURL *deleteInteractiveFormsURL;

@end

@implementation CInteractiveFormsViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"The sample code illustrates how to create and delete interactiveforms using API,also help you get interactiveforms list message.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

// Create all type form
- (void)createTestForms:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"InteractiveForms"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"CreateInteractiveFormsTest"];
    
    // Save the document in the test PDF file
    self.interactiveFormsURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.interactiveFormsURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.interactiveFormsURL];
    
    // Create form using API
    CPDFPage *page = [document pageAtIndex:0];
    CGSize pageSize = [document pageSizeAtIndex:0];
    CGFloat hight = pageSize.height;
    
    // create new Form Fields and Widget Annotations.
    {
        // Insert a single-line TextField.
        CPDFTextWidgetAnnotation *textWidget1 = [[CPDFTextWidgetAnnotation alloc] initWithDocument:document];
        textWidget1.bounds = [self.view convertRect:CGRectMake(28, hight-30, 80, 25) toView:self.view];
        textWidget1.fieldName = @"TextField1";
        textWidget1.isMultiline = NO;
        textWidget1.stringValue = @"Basic Text Field";
        textWidget1.fontColor = [UIColor blackColor];
        textWidget1.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:textWidget1];
    }
    
    {
        // Insert a multiline TextField.
        CPDFTextWidgetAnnotation *textWidget2 = [[CPDFTextWidgetAnnotation alloc] initWithDocument:document];
        textWidget2.bounds = [self.view convertRect:CGRectMake(28, hight-100, 80, 60) toView:self.view];
        textWidget2.fieldName = @"TextField2";
        textWidget2.stringValue = @"Basic Text Field\nBasic Text Field\nBasic Text Field";
        textWidget2.isMultiline = YES;
        textWidget2.fontColor = [UIColor blackColor];
        textWidget2.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:textWidget2];
    }
    
    {
        // Insert a ListBox widget.
        NSMutableArray *items = [NSMutableArray array];
        CPDFChoiceWidgetItem *item1 = [[CPDFChoiceWidgetItem alloc] init];
        item1.value = @"List Box No.1";
        item1.string = @"List Box No.1";
        [items addObject:item1];
        CPDFChoiceWidgetItem *item2 = [[CPDFChoiceWidgetItem alloc] init];
        item2.value = @"List Box No.2";
        item2.string = @"List Box No.2";
        [items addObject:item2];
        CPDFChoiceWidgetItem *item3 = [[CPDFChoiceWidgetItem alloc] init];
        item3.value = @"List Box No.3";
        item3.string = @"List Box No.3";
        [items addObject:item3];

        CPDFChoiceWidgetAnnotation *choiceWidget = [[CPDFChoiceWidgetAnnotation alloc] initWithDocument:document listChoice:YES];
        choiceWidget.fieldName = @"ListBox1";
        choiceWidget.bounds = CGRectMake(267, hight-100, 200, 100);
        choiceWidget.items = items;
        choiceWidget.selectItemAtIndex = 2;
        [page addAnnotation:choiceWidget];
    }
    
    {
        // Insert a ComboBox Widget.
        NSMutableArray *items = [NSMutableArray array];
        CPDFChoiceWidgetItem *item1 = [[CPDFChoiceWidgetItem alloc] init];
        item1.value = @"Combo Box No.1";
        item1.string = @"Combo Box No.1";
        [items addObject:item1];
        CPDFChoiceWidgetItem *item2 = [[CPDFChoiceWidgetItem alloc] init];
        item2.value = @"Combo Box No.2";
        item2.string = @"Combo Box No.2";
        [items addObject:item2];
        CPDFChoiceWidgetItem *item3 = [[CPDFChoiceWidgetItem alloc] init];
        item3.value = @"Combo Box No.3";
        item3.string = @"Combo Box No.3";
        [items addObject:item3];

        CPDFChoiceWidgetAnnotation *choiceWidget = [[CPDFChoiceWidgetAnnotation alloc] initWithDocument:document listChoice:NO];
        choiceWidget.fieldName = @"ComboBox1";
        choiceWidget.bounds = CGRectMake(267, hight-200, 200, 100);
        choiceWidget.items = items;
        choiceWidget.selectItemAtIndex = 2;
        [page addAnnotation:choiceWidget];
    }
    
    {
        //Insert a Form Signature Widget (unsigned)
        CPDFSignatureWidgetAnnotation *signatureWidget = [[CPDFSignatureWidgetAnnotation alloc] initWithDocument:document];
        signatureWidget.bounds = CGRectMake(28, hight-206, 80, 101);
        signatureWidget.fieldName = @"Signature1";
        [page addAnnotation:signatureWidget];
    }
    
    {
        // Insert a PushButton to jump to a page.
        CPDFButtonWidgetAnnotation *pushButton = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetPushButtonControl];
        pushButton.bounds = CGRectMake(267, hight-300, 130, 80);
        pushButton.fieldName = @"PushButton1";
        pushButton.caption = @"PushButton";
        pushButton.fontColor = [UIColor blackColor];
        pushButton.font = [UIFont systemFontOfSize:15];
        
        CPDFDestination * destination = [[CPDFDestination alloc] initWithDocument:document pageIndex:1];
        CPDFGoToAction * goToAction = [[CPDFGoToAction alloc] initWithDestination:destination];
        [pushButton setAction:goToAction];
        
        [page addAnnotation:pushButton];
    }
    
    {
        // Insert a PushButton to jump to a website..
        CPDFButtonWidgetAnnotation *pushButton = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetPushButtonControl];
        pushButton.bounds = CGRectMake(367, hight-303, 150, 80);
        pushButton.fieldName = @"PushButton2";
        pushButton.caption = @"PushButton";
        pushButton.fontColor = [UIColor blackColor];
        pushButton.font = [UIFont systemFontOfSize:15];
        
        CPDFURLAction *urlAction = [[CPDFURLAction alloc] initWithURL:@"https://www.compdf.com/"];
        [pushButton setAction:urlAction];
        
        [page addAnnotation:pushButton];
    }
    
    {
        //Insert CheckBox Widget
        CPDFButtonWidgetAnnotation *checkBox = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetCheckBoxControl];
        checkBox.bounds = CGRectMake(67, hight-351, 100, 90);
        checkBox.fieldName = @"CheckBox1";
        checkBox.borderColor = [UIColor blackColor];
        checkBox.backgroundColor = [UIColor greenColor];
        checkBox.borderWidth = 2.0;
        checkBox.state = 0;
        checkBox.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:checkBox];
    }
    
    {
        //Insert CheckBox Widget
        CPDFButtonWidgetAnnotation *checkBox = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetCheckBoxControl];
        checkBox.bounds = CGRectMake(167, hight-351, 100, 90);
        checkBox.fieldName = @"CheckBox2";
        checkBox.borderColor = [UIColor blackColor];
        checkBox.backgroundColor = [UIColor greenColor];
        checkBox.borderWidth = 2.0;
        checkBox.state = 1;
        checkBox.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:checkBox];
    }
    
    {
        //Insert Radio Button Widget
        CPDFButtonWidgetAnnotation *radioButton = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetRadioButtonControl];
        radioButton.bounds = CGRectMake(167, hight-451, 100, 90);
        radioButton.fieldName = @"RadioButton1";
        radioButton.borderColor = [UIColor blackColor];
        radioButton.backgroundColor = [UIColor greenColor];
        radioButton.borderWidth = 2.0;
        radioButton.state = 0;
        radioButton.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:radioButton];
    }
    
    {
        //Insert Radio Button Widget
        CPDFButtonWidgetAnnotation *radioButton = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetRadioButtonControl];
        radioButton.bounds = CGRectMake(267, hight-451, 100, 90);
        radioButton.fieldName = @"RadioButton2";
        radioButton.borderColor = [UIColor blackColor];
        radioButton.backgroundColor = [UIColor greenColor];
        radioButton.borderWidth = 2.0;
        radioButton.state = 1;
        radioButton.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:radioButton];
    }
    
    {
        //Insert Radio Button Widget
        CPDFButtonWidgetAnnotation *radioButton = [[CPDFButtonWidgetAnnotation alloc] initWithDocument:document controlType:CPDFWidgetRadioButtonControl];
        radioButton.bounds = CGRectMake(367, hight-451, 100, 90);
        radioButton.fieldName = @"RadioButton3";
        radioButton.borderColor = [UIColor blackColor];
        radioButton.backgroundColor = [UIColor greenColor];
        radioButton.borderWidth = 2.0;
        radioButton.state = 0;
        radioButton.font = [UIFont systemFontOfSize:15];
        [page addAnnotation:radioButton];
    }
    
    // Save the create forms action in document
    [document writeToURL:self.interactiveFormsURL];
    
    // Refresh document
    self.document = [[CPDFDocument alloc] initWithURL:self.interactiveFormsURL];
     
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in CreateInteractiveFormsTest.pdf\n"];
}

// Print form message
- (void)printFormsMessage:(CPDFDocument *)document {
    CPDFPage *page = [document pageAtIndex:0];

    NSArray *annotations = [page annotations];
    for (CPDFAnnotation *annotationz in annotations) {
        if([annotationz isKindOfClass:[CPDFWidgetAnnotation class]]) {
            CPDFWidgetAnnotation * annotation = (CPDFWidgetAnnotation *)annotationz;
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field name : %@\n", annotation.fieldName];
            if ([annotation isKindOfClass:[CPDFTextWidgetAnnotation class]]) {
                self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field partial name :  %@\n", ((CPDFTextWidgetAnnotation*)annotation).stringValue];
            } else if ([annotation isKindOfClass:[CPDFButtonWidgetAnnotation class]]) {
                if (CPDFWidgetRadioButtonControl == [(CPDFButtonWidgetAnnotation *)annotation controlType]) {
                    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field isChecked :   %ld\n", ((CPDFButtonWidgetAnnotation *)annotation).state];
                } else if (CPDFWidgetPushButtonControl == [(CPDFButtonWidgetAnnotation *)annotation controlType]) {
                    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field PushButton Title :   %@\n", ((CPDFButtonWidgetAnnotation *)annotation).caption];
                    CPDFAction *action = ((CPDFButtonWidgetAnnotation *)annotation).action;
                    if ([action isKindOfClass:[CPDFURLAction class]]) {
                        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field PushButton Action : %@\n", ((CPDFURLAction *)action).url];
                    } else if ([action isKindOfClass:[CPDFGoToAction class]]) {
                        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field PushButton Action : Jump to page %ld of the document\n",((CPDFGoToAction *)action).destination.pageIndex];
                    }
                } else if (CPDFWidgetCheckBoxControl == [(CPDFButtonWidgetAnnotation *)annotation controlType]) {
                    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field isChecked :   %ld\n", ((CPDFButtonWidgetAnnotation *)annotation).state];
                }
            } else if ([annotation isKindOfClass:[CPDFChoiceWidgetAnnotation class]]) {
                self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Field Select Item :   %ld\n", ((CPDFChoiceWidgetAnnotation *)annotation).selectItemAtIndex];
            }
            
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"\tPosition: %d, %d, %d, %d\n", (int)annotation.bounds.origin.x,(int)annotation.bounds.origin.y, (int)annotation.bounds.size.width, (int)annotation.bounds.size.height];
            self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Widget type : %@\n", annotation.type];
            self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
            
        }
    }
}

// Dele the first form
- (void)deleteForm:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"InteractiveForms"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteInteractiveFormsTest"];
    
    // Save the document in the test PDF file
    self.deleteInteractiveFormsURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.deleteInteractiveFormsURL];
    
    // Create a new document for test PDF file
     CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteInteractiveFormsURL];
    
    // Remove the first form from document
    CPDFPage *page = [document pageAtIndex:0];

    CPDFAnnotation *annotation = [[page annotations] objectAtIndex:0];
    [page removeAnnotation:annotation];
    
    // Save the remove form action in document
    [document writeToURL:self.deleteInteractiveFormsURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DeleteInteractiveFormsTest.pdf\n"];
}

- (void)openFileWithURL:(NSURL *)url {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityVC.definesPresentationContext = YES;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        activityVC.popoverPresentationController.sourceView = self.openfileButton;
        activityVC.popoverPresentationController.sourceRect = self.openfileButton.bounds;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {

        if (completed) {
            NSLog(@"Success!");
        } else {
            NSLog(@"Failed Or Canceled!");
        }
    };
}


#pragma mark - Action

- (IBAction)buttonItemClick_openFile:(id)sender {
    // Determine whether to export the document
    if (self.isRun) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose a file to open...", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            alertController.popoverPresentationController.sourceView = self.openfileButton;
            alertController.popoverPresentationController.sourceRect = self.openfileButton.bounds;
        }
        
        UIAlertAction *createInteractiveFormsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   CreateInteractiveFormsTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open CreateInteractiveFormsTest.pdf
            [self openFileWithURL:self.interactiveFormsURL];
        }];
        
        UIAlertAction *deleteInteractiveFormsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteInteractiveFormsTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteInteractiveFormsTest.pdf
            [self openFileWithURL:self.deleteInteractiveFormsURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:createInteractiveFormsAction];
        [alertController addAction:deleteInteractiveFormsAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:NO completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose a file to open...", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            alertController.popoverPresentationController.sourceView = self.openfileButton;
            alertController.popoverPresentationController.sourceRect = self.openfileButton.bounds;
        }
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No files for this sample.", nil) style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:noAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

- (IBAction)buttonItemClick_run:(id)sender {
    if (self.document) {
        self.isRun = YES;
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running InteractiveForms sample...\n\n"];
        [self createTestForms:self.document];
        [self printFormsMessage:self.document];
        [self deleteForm:self.document];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\nDone!\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        
        // Refresh commandline message
        self.commandLineTextView.text = self.commandLineStr;
    } else {
        self.isRun = NO;
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"The document is null, can't open..\n\n"];
        self.commandLineTextView.text = self.commandLineStr;
    }
}

@end
