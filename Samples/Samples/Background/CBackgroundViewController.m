//
//  CBackgroundViewController.m
//  Samples
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "CBackgroundViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to add and remove background, including text
// and image background. date using API.
//-----------------------------------------------------------------------------------------

@interface CBackgroundViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *addColorBackgroundURL;

@property (nonatomic, strong) NSURL *addImageBackgroundURL;

@property (nonatomic, strong) NSURL *deleteBackgroundURL;

@end

@implementation CBackgroundViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to add color and picture backs and delete backgrounds.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

- (void)addColorBackground:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 1 : Set the document background color\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Background"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddColorBackgroundTest"];
    
    // Save the document in the test PDF file
    self.addColorBackgroundURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addColorBackgroundURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addColorBackgroundURL];
    
    // Create color background
    CPDFBackground *background = document.background;
    background.type = CPDFBackgroundTypeColor;
    background.color = [CPDFKitPlatformColor redColor]; // Background color (image background does not work).
    background.opacity = 1.0; // Background transparency, the range of 0~1, with the default of 1.
    background.scale = 1.0; // Background tiling scale.
    background.rotation = 0; // Background rotation angle, the range of 0~360, the default is 0 (rotate at the centre of the page).
    background.horizontalAlignment = 1; // Background vertical alignment. `0` for top alignment, `1` for centre alignment, `1` for bottom alignment.
    background.verticalAlignment = 1; // Horizontal alignment of the background. `0` for left alignment, `1` for centre alignment, `1` for right alignment.
    background.xOffset = 0; // The horizontal offset of the background. Positive numbers are shifted to the right, negative numbers are shifted to the left.
    background.yOffset = 0; // The vertical offset of the background. Positive numbers are shifted downwards, negative numbers are shifted upwards.

    background.pageString = @"0,1,2,3,4"; // Background page range, such as "0,3,5-7".

    [background update];
    
    [document writeToURL:self.addColorBackgroundURL];
    
    // Print color background object message
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Type : Color"];
    CGFloat red, green, blue, alpha;
    [background.color getRed:&red green:&green blue:&blue alpha:&alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Color : red:%.1f, green:%.1f, blue:%.1f, alpha:%.1f\n", red, green, blue, alpha];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opacity :%.1f\n", background.opacity];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Rotation :%.1f\n", background.rotation];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Vertalign :%@\n", [self getStringFromEnumVertalign:background.verticalAlignment]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Horizalign :%@\n", [self getStringFromEnumHorizalign:background.horizontalAlignment]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VertOffset :%.1f\n", background.xOffset];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizOffset :%.1f\n", background.yOffset];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages :%@\n", background.pageString];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddColorBackgroundTest.pdf\n"];
}

- (void)addImageBackground:(CPDFDocument *)oldDocument {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 2 : Set the document background image\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Background"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"AddImageBackgroundTest"];
    
    // Save the document in the test PDF file
    self.addImageBackgroundURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.addImageBackgroundURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.addImageBackgroundURL];
    
    // Create image background
    CPDFBackground *background = document.background;
    background.type = CPDFBackgroundTypeImage;
    [background setImage:[UIImage imageNamed:@"Logo"]];
    background.opacity = 1.0; // Background transparency, the range of 0~1, with the default of 1.
    background.scale = 1.0; // Background tiling scale.
    background.rotation = 0; // Background rotation angle, the range of 0~360, the default is 0 (rotate at the centre of the page).
    background.horizontalAlignment = 1; // Background vertical alignment. `0` for top alignment, `1` for centre alignment, `1` for bottom alignment.
    background.verticalAlignment = 1; // Horizontal alignment of the background. `0` for left alignment, `1` for centre alignment, `1` for right alignment.
    background.xOffset = 0; // The horizontal offset of the background. Positive numbers are shifted to the right, negative numbers are shifted to the left.
    background.yOffset = 0; // The vertical offset of the background. Positive numbers are shifted downwards, negative numbers are shifted upwards.

    background.pageString = @"0,1,2,3,4"; // Background page range, such as "0,3,5-7".

    [background update];
    
    [document writeToURL:self.addImageBackgroundURL];
    
    // Print image background object message
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Type : Image\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Opacity :%.1f\n", background.opacity];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Rotation :%.1f\n", background.rotation];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Vertalign :%@\n", [self getStringFromEnumVertalign:background.verticalAlignment]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Horizalign :%@\n", [self getStringFromEnumHorizalign:background.horizontalAlignment]];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"VertOffset :%.1f\n", background.xOffset];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"HorizOffset :%.1f\n", background.yOffset];
    self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"Pages :%@\n", background.pageString];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddImageBackgroundTest.pdf\n"];
}

- (void)deleteColorBackground {
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"-------------------------------------\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Samples 3 :  Delete document background\n"];
    
    // Get Sandbox path for saving the PDFFile
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Background"];
    NSString *documentFolder = [NSHomeDirectory() stringByAppendingFormat:@"/%@/%@/%@.pdf", @"Documents",@"Background",@"AddColorBackgroundTest"];
    
    // Copy file
    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"DeleteBackgroundTest"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentFolder])
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:documentFolder] toURL:[NSURL fileURLWithPath:writeFilePath] error:nil];
   
    
    self.deleteBackgroundURL = [NSURL fileURLWithPath:writeFilePath];
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.deleteBackgroundURL];
    
    CPDFBackground *pageBackground = [document background];
    
    [pageBackground clear];
    
    [document writeToURL:self.deleteBackgroundURL];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in AddImageBackgroundTest.pdf\n"];
}

- (NSString *)getStringFromEnumVertalign:(NSInteger)enums {
    switch (enums) {
        case 0:
            return @"top alignment";
            break;
        case 1:
            return @"center alignment";
            break;
        case 2:
            return @"button alignment";
            break;
        default:
            return @" ";
            break;
    }
}

- (NSString *)getStringFromEnumHorizalign:(NSInteger)enums {
    switch (enums) {
        case 0:
            return @"left alignment";
            break;
        case 1:
            return @"center alignment";
            break;
        case 2:
            return @"right alignment";
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
        
        UIAlertAction *colorBackgroundAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddColorBackgroundTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddColorBackgroundTest.pdf
            [self openFileWithURL:self.addColorBackgroundURL];
        }];
        UIAlertAction *imageBackgroundAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   AddImageBackgroundTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open AddImageBackgroundTest.pdf
            [self openFileWithURL:self.addImageBackgroundURL];
        }];
        UIAlertAction *deleteBackgroundAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"   DeleteBackgroundTest.pdf   ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open DeleteBackgroundTest.pdf
            [self openFileWithURL:self.deleteBackgroundURL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:colorBackgroundAction];
        [alertController addAction:imageBackgroundAction];
        [alertController addAction:deleteBackgroundAction];
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
        [self addColorBackground:self.document];
        [self addImageBackground:self.document];
        [self deleteColorBackground];
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
