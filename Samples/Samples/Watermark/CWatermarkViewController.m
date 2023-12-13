//
//  CWatermarkViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//


#import "CWatermarkViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to add and remove watermarks, including text
// and image watermarks. date using API.
//-----------------------------------------------------------------------------------------

@interface CWatermarkViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *addTextWatermarkURL;

@property (nonatomic, strong) NSURL *addTilesWatermarkURL;

@property (nonatomic, strong) NSURL *addImageWatermarkURL;

@property (nonatomic, strong) NSURL *deleteWatermarkURL;

@end

@implementation CWatermarkViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to add watermarks, including text, image and tile watermarks, and delete watermarks.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)addTextWatermark:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1: Insert text watermark\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Watermark"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddTextWatermarkTest"];
    
    // Save the document in the test PDF file
    self.addTextWatermarkURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addTextWatermarkURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addTextWatermarkURL];
    
    // Create text watermark
    CPDFWatermark *watermark = [[CPDFWatermark alloc] initWithDocument:document type:CPDFWatermarkTypeText];
    
    watermark.text = @"ComPDFKit"; // The text for the watermark (image watermark does not work).
    watermark.textFont = [UIFont fontWithName:@"Helvetica" size:30]; // The text font for the watermark (image watermark does not work). Default Font : Helvetica 24.
    watermark.textColor = [UIColor redColor]; // The text color for the watermark (image watermark does not work).
    watermark.scale = 2.0; // Watermark scaling with default `1`, if it is a picture watermark `1` represents the original size of the picture, if it is a text watermark `1` represents the `textFont` font size.

    watermark.rotation = 45; // Watermark rotation angle, the range of 0~360, with the default of 0.
    watermark.opacity = 0.5; // Watermark transparency, the range of 0~1, with the default of 1.
    watermark.verticalPosition = CPDFWatermarkVerticalPositionCenter; // Vertical alignment of the watermark.
    watermark.horizontalPosition = CPDFWatermarkHorizontalPositionCenter; // Horizontal alignment of the watermark.
    watermark.tx = 0.0; // The translation relative to the horizontal position. Positive numbers are shifted to the right, negative numbers are shifted to the left.
    watermark.ty = 0.0; // The translation relative to the vertical position. Positive numbers are shifted downwards, negative numbers are shifted upwards.
    watermark.isFront = YES; // Set watermark to locate in front of the content.
    watermark.isTilePage = NO; // Set tiled watermark for the page(image watermark does not work).
    watermark.pageString = @"0-4";
    [document addWatermark:watermark];
    [document updateWatermark:watermark];
    
    [document writeToURL:self.addTextWatermarkURL];
    
    // Print text watermark object message
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text :%@", watermark.text];
    CGFloat red, green, blue, alpha;
    [watermark.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Color : red:%.1f, green:%.1f, blue:%.1f, alpha:%.1f\n", red, green, blue, alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"FontSize :%.1f\n", watermark.textFont.pointSize];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opacity :%.1f\n", watermark.opacity];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Vertalign :%@\n", [self getStringFromEnumVertalign:watermark.verticalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Horizalign :%@\n", [self getStringFromEnumHorizalign:watermark.horizontalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VertOffset :%.1f\n", watermark.tx];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizOffset :%.1f\n", watermark.ty];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages :%@\n", watermark.pageString];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VerticalSpacing :%.1f\n", watermark.verticalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizontalSpacing :%.1f\n", watermark.horizontalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddTextWatermarkTest.pdf\n"];
}

- (void)addImageWatermark:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2: Insert Image Watermark\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Watermark"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddImageWatermarkTest"];
    
    // Save the document in the test PDF file
    self.addImageWatermarkURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addImageWatermarkURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addImageWatermarkURL];
    
    // Create a image watermark
    CPDFWatermark *watermark = [[CPDFWatermark alloc] initWithDocument:document type:CPDFWatermarkTypeImage];
    
    watermark.image = [UIImage imageNamed:@"Logo"];
    watermark.scale = 2.0; // Watermark scaling with default `1`, if it is a picture watermark `1` represents the original size of the picture, if it is a text watermark `1` represents the `textFont` font size.

    watermark.rotation = 45; // Watermark rotation angle, the range of 0~360, with the default of 0.
    watermark.opacity = 0.5; // Watermark transparency, the range of 0~1, with the default of 1.
    watermark.verticalPosition = CPDFWatermarkVerticalPositionCenter; // Vertical alignment of the watermark.
    watermark.horizontalPosition = CPDFWatermarkHorizontalPositionCenter; // Horizontal alignment of the watermark.
    watermark.tx = 0.0; // The translation relative to the horizontal position. Positive numbers are shifted to the right, negative numbers are shifted to the left.
    watermark.ty = 0.0; // The translation relative to the vertical position. Positive numbers are shifted downwards, negative numbers are shifted upwards.
    watermark.isFront = YES; // Set watermark to locate in front of the content.
    watermark.pageString = @"0-4";
    [document addWatermark:watermark];
    
    [document writeToURL:self.addImageWatermarkURL];
    
    // Print text watermark object message
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opacity :%.1f\n", watermark.opacity];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Vertalign :%@\n", [self getStringFromEnumVertalign:watermark.verticalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Horizalign :%@\n", [self getStringFromEnumHorizalign:watermark.horizontalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VertOffset :%.1f\n", watermark.tx];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizOffset :%.1f\n", watermark.ty];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages :%@\n", watermark.pageString];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VerticalSpacing :%.1f\n", watermark.verticalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizontalSpacing :%.1f\n", watermark.horizontalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddImageWatermarkTest.pdf\n"];
}

- (void)addTilesWatermark:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3: Insert Text Tiles Watermark\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Watermark"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddTilesWatermarkTest"];
    
    // Save the document in the test PDF file
    self.addTilesWatermarkURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addTilesWatermarkURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addTilesWatermarkURL];
    
    // Create text tiles watermark
    CPDFWatermark *watermark = [[CPDFWatermark alloc] initWithDocument:document type:CPDFWatermarkTypeText];
    
    watermark.text = @"ComPDFKit"; // The text for the watermark (image watermark does not work).
    watermark.textFont = [UIFont fontWithName:@"Helvetica" size:30]; // The text font for the watermark (image watermark does not work). Default Font : Helvetica 24.
    watermark.textColor = [UIColor redColor]; // The text color for the watermark (image watermark does not work).
    watermark.scale = 2.0; // Watermark scaling with default `1`, if it is a picture watermark `1` represents the original size of the picture, if it is a text watermark `1` represents the `textFont` font size.

    watermark.rotation = 45; // Watermark rotation angle, the range of 0~360, with the default of 0.
    watermark.opacity = 0.5; // Watermark transparency, the range of 0~1, with the default of 1.
    watermark.verticalPosition = CPDFWatermarkVerticalPositionCenter; // Vertical alignment of the watermark.
    watermark.horizontalPosition = CPDFWatermarkHorizontalPositionCenter; // Horizontal alignment of the watermark.
    watermark.tx = 0.0; // The translation relative to the horizontal position. Positive numbers are shifted to the right, negative numbers are shifted to the left.
    watermark.ty = 0.0; // The translation relative to the vertical position. Positive numbers are shifted downwards, negative numbers are shifted upwards.
    watermark.isFront = YES; // Set watermark to locate in front of the content.
    watermark.isTilePage = YES; // Set tiled watermark for the page(image watermark does not work).
    watermark.verticalSpacing = 10; // Set the vertical spacing for the tiled watermark.
    watermark.horizontalSpacing = 10; // Set the horizontal spacing for the tiled watermark.
    watermark.pageString = @"0-4";
    [document addWatermark:watermark];
    
    [document writeToURL:self.addTilesWatermarkURL];
    
    // Print text tiles watermark message
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Text :%@\n", watermark.text];
    CGFloat red, green, blue, alpha;
    [watermark.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Color : red:%.1f, green:%.1f, blue:%f, alpha:%.1f\n", red, green, blue, alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"FontSize :%.1f\n", watermark.textFont.pointSize];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opacity :%.1f\n", watermark.opacity];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Vertalign :%@\n", [self getStringFromEnumVertalign:watermark.verticalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Horizalign :%@\n", [self getStringFromEnumHorizalign:watermark.horizontalPosition]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VertOffset :%.1f\n", watermark.tx];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizOffset :%.1f\n", watermark.ty];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages :%@\n", watermark.pageString];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VerticalSpacing :%.1f\n", watermark.verticalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizontalSpacing :%.1f\n", watermark.horizontalSpacing];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddTilesWatermarkTest.pdf\n"];
}

- (void)deletetWatermark {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 4:Delete Watermark\n"];
    
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Watermark"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"Watermark",@"AddTextWatermarkTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteWatermarkTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
    self.deleteWatermarkURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteWatermarkURL];
    
    NSArray *waterArray = [document watermarks];
    [document removeWatermark:waterArray[0]];
    
    [document writeToURL:self.deleteWatermarkURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in DeleteWatermarkTest.pdf\n"];
}

- (NSString *)getStringFromEnumVertalign:(NSInteger)enums {
    switch (enums) {
        case 0:
            return @"CPDFWatermarkVerticalPositionTop";
            break;
        case 1:
            return @"WATERMARK_VERTALIGN_CENTER";
            break;
        case 2:
            return @"CPDFWatermarkVerticalPositionBottom";
            break;
        default:
            return @" ";
            break;
    }
}

- (NSString *)getStringFromEnumHorizalign:(NSInteger)enums {
    switch (enums) {
        case 0:
            return @"CPDFWatermarkHorizontalPositionLeft";
            break;
        case 1:
            return @"CPDFWatermarkHorizontalPositionCenter";
            break;
        case 2:
            return @"CPDFWatermarkHorizontalPositionRight";
            break;
        default:
            return @" ";
            break;
    }
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
        
        UIAlertAction *textWatermarkAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddTextWatermarkTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddTextWatermarkTest.pdf
            [self openFileWithURL:self.addTextWatermarkURL];
        }];
        UIAlertAction *imageWatermarkAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddImageWatermarkTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddImageWatermarkTest.pdf
            [self openFileWithURL:self.addImageWatermarkURL];
        }];
        UIAlertAction *tilesWatermarkAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddTilesWatermarkTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddTilesWatermarkTest.pdf
            [self openFileWithURL:self.addTilesWatermarkURL];
        }];
        UIAlertAction *deleteWatermarkAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteWatermarkTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteWatermarkTest.pdf
            [self openFileWithURL:self.deleteWatermarkURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:textWatermarkAction];
        [alertController addAction:imageWatermarkAction];
        [alertController addAction:tilesWatermarkAction];
        [alertController addAction:deleteWatermarkAction];
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
        
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running Watermark sample...\n\n"];
        [self addTextWatermark:self.document];
        [self addImageWatermark:self.document];
        [self addTilesWatermark:self.document];
        [self deletetWatermark];
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
