//
//  CAnnotaitonViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

#import "CAnnotaitonViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to create new annotation and delete anntation,
// get anntation information list using API.
//-----------------------------------------------------------------------------------------

@interface CAnnotaitonViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *anntationURL;

@property (nonatomic, strong) NSURL *deleteAnntationURL;

@end

@implementation CAnnotaitonViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to print the annotation list information, set the annotations (including markup, note, ink, freetext, circle, square, line, stamp, and sound annotations), and delete the annotations.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

// Create all type annotation using API
- (void)createTestAnnots:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Annoation"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"CreateAnnotationTest"];
    
    // Save the document in the test PDF file
    self.anntationURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.anntationURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.anntationURL];
    
    //-----------------------------------------------------------------------------------------
    // Test of a free text annotation and ink annotation.
    CPDFPage *page1 = [document pageAtIndex:0];

    {
        //  Create a freetext annotation
        CPDFFreeTextAnnotation *freeText1 = [[CPDFFreeTextAnnotation alloc] initWithDocument:document];
        freeText1.contents = @"\n\nSome swift brown fox snatched a gray hare out of the air by freezing it with an angry glare."
        "\n\nAha!\n\nAnd there was much rejoicing!";
        freeText1.bounds = CGRectMake(10, 200, 160, 570);
        freeText1.font = [UIFont fontWithName:@"Helvetica" size:12];
        freeText1.fontColor = [UIColor redColor];
        freeText1.alignment = NSTextAlignmentLeft;
        //  add a freetext annotation for page
        [page1 addAnnotation:freeText1];
    }
    
    {
        // Create a ink annotation
        CPDFInkAnnotation *ink = [[CPDFInkAnnotation alloc] initWithDocument:document];
        CGPoint startPoint = CGPointMake(220, 505);
        CGPoint point1 = CGPointMake(100, 490);
        CGPoint point2 = CGPointMake(120, 410);
        CGPoint point3 = CGPointMake(100, 400);
        CGPoint point4 = CGPointMake(180, 490);
        CGPoint endPoint = CGPointMake(140, 440);
        ink.color = [UIColor redColor];
        ink.opacity = 0.5;
        ink.borderWidth = 2.0;
        ink.paths = @[@[[NSValue valueWithCGPoint:startPoint],[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3],[NSValue valueWithCGPoint:point4],[NSValue valueWithCGPoint:endPoint]]];
        [page1 addAnnotation:ink];
    }
    
    //-----------------------------------------------------------------------------------------
    // Test of line annotaiton
    // Set line with and Dotted line
    CPDFBorder *border1 = [[CPDFBorder alloc] initWithStyle:CPDFBorderStyleDashed
                                                    lineWidth:1
                                                  dashPattern:@[@(2), @(1)]];
    CPDFBorder *border2 = [[CPDFBorder alloc] initWithStyle:CPDFBorderStyleDashed
                                                    lineWidth:1
                                                  dashPattern:@[@(2), @(0)]];
    CPDFPage *page2 = [document pageAtIndex:1];
    {
        // Create a Line annotations.
        CPDFLineAnnotation *line1 = [[CPDFLineAnnotation alloc] initWithDocument:document];
        line1.startPoint = CGPointMake(350, 270);
        line1.endPoint = CGPointMake(260, 370);
        line1.startLineStyle = CPDFLineStyleSquare;
        line1.endLineStyle = CPDFLineStyleCircle;
        line1.color = [UIColor redColor];
        line1.interiorColor = [UIColor yellowColor];
        line1.opacity = 0.5;
        line1.interiorOpacity = 0.5;
        line1.border = border1;
        [line1 setContents:@"Dashed Captioned"];
        [page2 addAnnotation:line1];
    }
    
    {
        CPDFLineAnnotation *line2 = [[CPDFLineAnnotation alloc] initWithDocument:document];
        line2.startPoint = CGPointMake(385, 480);
        line2.endPoint = CGPointMake(540, 555);
        line2.startLineStyle = CPDFLineStyleCircle;
        line2.endLineStyle = CPDFLineStyleOpenArrow;
        line2.color = [UIColor redColor];
        line2.interiorColor = [UIColor yellowColor];
        line2.opacity = 0.5;
        line2.interiorOpacity = 0.5;
        line2.border = border2;
        [line2 setContents:@"Inline Caption"];
        [page2 addAnnotation:line2];
    }
        
    {
        CPDFLineAnnotation *line3 = [[CPDFLineAnnotation alloc] initWithDocument:document];
        line3.startPoint = CGPointMake(25, 426);
        line3.endPoint = CGPointMake(180, 555);
        line3.startLineStyle = CPDFLineStyleCircle;
        line3.endLineStyle = CPDFLineStyleSquare;
        line3.color = [UIColor greenColor];
        line3.interiorColor = [UIColor yellowColor];
        line3.opacity = 0.5;
        line3.interiorOpacity = 0.5;
        line3.border = border2;
        [line3 setContents:@"Offset Caption"];
        [page2 addAnnotation:line3];
    }
    
    //-----------------------------------------------------------------------------------------
    // Test of circle and square annotation
    CPDFPage *page3 = [document pageAtIndex:2];
    {
        // Create a circle annotations.
        CPDFCircleAnnotation *circle1 = [[CPDFCircleAnnotation alloc] initWithDocument:document];
        circle1.bounds = CGRectMake(300, 300, 100, 100);
        circle1.color = [UIColor redColor];
        circle1.interiorColor = [UIColor yellowColor];
        circle1.opacity = 0.5;
        circle1.interiorOpacity = 0.5;
        circle1.border = border1;
        [page3 addAnnotation:circle1];
    }
        
    {
        CPDFCircleAnnotation *circle2 = [[CPDFCircleAnnotation alloc] initWithDocument:document];
        circle2.bounds = CGRectMake(100, 100, 200, 200);
        circle2.color = [UIColor greenColor];
        circle2.interiorColor = [UIColor purpleColor];
        circle2.opacity = 1.0;
        circle2.interiorOpacity = 1.0;
        circle2.border = border2;
        [page3 addAnnotation:circle2];
    }
        
    {
        // Create a sqaure annotations.
        CPDFSquareAnnotation *square1 = [[CPDFSquareAnnotation alloc] initWithDocument:document];
        square1.bounds = CGRectMake(10, 200, 80, 150);
        square1.color = [UIColor redColor];
        square1.interiorColor = [UIColor yellowColor];
        square1.opacity = 0.5;
        square1.interiorOpacity = 0.5;
        square1.border = border1;
        [page3 addAnnotation:square1];
    }
    
    {
        CPDFSquareAnnotation *square2 = [[CPDFSquareAnnotation alloc] initWithDocument:document];
        square2.bounds = CGRectMake(400, 200, 80, 300);
        square2.color = [UIColor greenColor];
        square2.interiorColor = [UIColor purpleColor];
        square2.opacity = 1.0;
        square2.interiorOpacity = 1.0;
        square2.border = border2;
        [page3 addAnnotation:square2];
    }
    
    //-----------------------------------------------------------------------------------------
    // Test of markup, note, link and sound anntation
    CPDFPage *page4 = [document pageAtIndex:3];
    {
        // Get array of search result
        NSArray *resultArray = [document findString:@"Page" withOptions:CPDFSearchCaseInsensitive];
        
        // Get the first page of search resultsGet the first page of search results
        NSArray *selections = [resultArray objectAtIndex:3];
        
        // Get the first search result on the first page
        CPDFSelection *selection = [selections objectAtIndex:0];
        
        NSMutableArray *quadrilateralPoints = [NSMutableArray array];
        
        CGRect bounds = selection.bounds;
        [quadrilateralPoints addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))]];
        [quadrilateralPoints addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))]];
        [quadrilateralPoints addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds))]];
        [quadrilateralPoints addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))]];
        
        
        // Create a highlight annotations.
        CPDFMarkupAnnotation *highlight = [[CPDFMarkupAnnotation alloc] initWithDocument:document markupType:CPDFMarkupTypeHighlight];
        highlight.color = [UIColor yellowColor];
        highlight.quadrilateralPoints = quadrilateralPoints;
        [page4 addAnnotation:highlight];
    }
    
    {
        // Create a note annotation
        CPDFTextAnnotation *text = [[CPDFTextAnnotation alloc] initWithDocument:document];
        text.contents = @"test";
        text.bounds = CGRectMake(50, 200, 50, 50);
        text.color = [UIColor yellowColor];
        [page4 addAnnotation:text];
    }
    
    {
        // Create a link annotation
        CPDFDestination *dest = [[CPDFDestination alloc] initWithDocument:document pageIndex:1];
        CPDFLinkAnnotation *link = [[CPDFLinkAnnotation alloc] initWithDocument:document];
        link.bounds = CGRectMake(50, 100, 50, 50);
        link.destination = dest; //    link.URL = @"https://www.";
        [page4 addAnnotation:link];
    }
    
    {
        // Create a sound annotation
        // need import a recording file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bird" ofType:@"wav"];
        CPDFSoundAnnotation *soundAnnotation = [[CPDFSoundAnnotation alloc] initWithDocument:document];
        if ([soundAnnotation setMediaPath:filePath]) {
            soundAnnotation.bounds = CGRectMake(100, 200, 50, 50);
            [page4 addAnnotation:soundAnnotation];
        }
    }
    
    //-----------------------------------------------------------------------------------------
    // Test of stamp annotation
    CPDFPage *page5 = [document pageAtIndex:4];
    CGSize size5 = [document pageSizeAtIndex:4];
    CGFloat height5 = size5.height;
    
    {
        // Create a all standard annotation
        for (int i = 1; i <= 23; i++) {
            CPDFStampAnnotation *standard = [[CPDFStampAnnotation alloc] initWithDocument:document type:i];
            standard.bounds = CGRectMake(50, height5 - i*30, 50, 30);
            [page5 addAnnotation:standard];
        }
    }
    
    {
        // Create a text stamp annotation
        NSTimeZone* timename = [NSTimeZone systemTimeZone];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init ];
        [outputFormatter setTimeZone:timename ];
        
        // Get date
        NSString *tDate = nil;
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        
        tDate = [outputFormatter stringFromDate:[NSDate date]];
        CPDFStampAnnotation *text = [[CPDFStampAnnotation alloc] initWithDocument:document text:@"ComPDFKit" detailText:tDate style:CPDFStampStyleRed shape:CPDFStampShapeArrowLeft];
        text.bounds = CGRectMake(150, height5-50, 80, 50);
        [page5 addAnnotation:text];
    }
    
    {
        // Create a text stamp annotation
        CPDFStampAnnotation *image = [[CPDFStampAnnotation alloc] initWithDocument:document image:[UIImage imageNamed:@"Logo"]];
        image.bounds = CGRectMake(150, height5-120, 50, 50);
        [page5 addAnnotation:image];
    }
    
    // Save the create annotation action in document
    [document writeToURL:self.anntationURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in CreateAnnotationTest.pdf\n"];
    
    // Refresh the document
    self.document = [[CPDFDocument alloc] initWithURL:self.anntationURL];
}

// Print annotation list information
- (void)printAnnotationList:(CPDFDocument *)document {
    NSMutableArray *annotations = [NSMutableArray array];
      for (int i=0; i<document.pageCount; i++) {
          // Loop through all anntation
          CPDFPage *page = [document pageAtIndex:i];
          [annotations addObjectsFromArray:[page annotations]];
          for (CPDFAnnotation *annotation in annotations) {
              self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
              self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Page: %d\n", i+1];
              self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Annot Type: %@\n", annotation.type];
              self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"\tPosition: %d, %d, %d, %d\n\n", (int)annotation.bounds.origin.x,(int)annotation.bounds.origin.y, (int)annotation.bounds.size.width, (int)annotation.bounds.size.height];
          }
    }
}

// Dele the first annotation
- (void)deleteTestAnnot:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Annoation"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteAnnotationTest"];
    
    // Save the document in the PDF file
    self.deleteAnntationURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.deleteAnntationURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteAnntationURL];
    
    // Remove the fisrt annotation from document
    CPDFPage *page = [document pageAtIndex:0];

    CPDFAnnotation *annotation = [[page annotations] objectAtIndex:0];
    [page removeAnnotation:annotation];
    
    // Save the remove the fisrt annotation action in document
    [document writeToURL:self.deleteAnntationURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DeleteAnnotationTest.pdf\n"];
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
        
        UIAlertAction *createAnnotationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"     CreateAnnotationTest.pdf      ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open CreateAnnotationTest.pdf
            [self openFileWithURL:self.anntationURL];
        }];
        
        UIAlertAction *deleteAnnotationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"     DeleteAnnotationTest.pdf      ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteAnnotationTest.pdf
            [self openFileWithURL:self.deleteAnntationURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:createAnnotationAction];
        [alertController addAction:deleteAnnotationAction];
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
        
        // Create bookmark and go to the page
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running CreateAnnotationTest sample...\n\n"];
        
        [self createTestAnnots:self.document];
        
        [self printAnnotationList:self.document];
        
        [self deleteTestAnnot:self.document];
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\nDone!\n"];
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
        self.commandLineTextView.text = self.commandLineStr;
    } else {
        self.isRun = NO;
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"The document is null, can't open..\n\n"];
        self.commandLineTextView.text = self.commandLineStr;
    }
}

@end
