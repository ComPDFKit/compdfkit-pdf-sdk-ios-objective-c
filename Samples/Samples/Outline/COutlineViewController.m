//
//  COutlineViewController.m
//  Samples
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//


#import "COutlineViewController.h"

#import <ComPDFKit/ComPDFKit.h>

//-----------------------------------------------------------------------------------------
// The sample code illustrates how to create outline and obtain document outline
// information using API.
//-----------------------------------------------------------------------------------------

@interface COutlineViewController ()

@property (nonatomic, strong) CPDFDocument *document;

@property (nonatomic, assign) BOOL isRun;

@property (nonatomic, strong) NSString *commandLineStr;

@property (nonatomic, strong) NSURL *outlineURL;

@end

@implementation COutlineViewController

#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.explainLabel.text = NSLocalizedString(@"This sample shows how to create an outline and get existing outline information.", nil);
    
    self.commandLineTextView.text = @"";
    self.isRun = NO;
    self.commandLineStr = @"";
}

#pragma mark - Samples Methods

// Create outline
- (void)createOutline:(CPDFDocument *)oldDocument {
    // Get Sandbox path for saving the PDF File
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *writeDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, @"Outline"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:writeDirectoryPath])
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:writeDirectoryPath] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@.pdf",writeDirectoryPath,@"CreateOutlineTest"];
    
    // Save the document in the test PDF file
    self.outlineURL = [NSURL fileURLWithPath:writeFilePath];
    [oldDocument writeToURL:self.outlineURL];
    
    // Create a new document for test PDF file
    CPDFDocument *document = [[CPDFDocument alloc] initWithURL:self.outlineURL];
    
    // Create outline root
    [document setNewOutlineRoot];
    
    // Get root from PDF document
    CPDFOutline *outline = [document outlineRoot];
    
    // Insert a new outline node and set the outline title
    CPDFOutline *outlinePage1 = [outline insertChildAtIndex:0];
    outlinePage1.label = @"1. page1";
    
    CPDFOutline *outlinePage2 = [outline insertChildAtIndex:1];
    outlinePage2.label = @"2. page2";
    
    CPDFOutline *outlinePage3 = [outline insertChildAtIndex:2];
    outlinePage3.label = @"3. page3";
    
    CPDFOutline *outlinePage4 = [outline insertChildAtIndex:3];
    outlinePage4.label = @"4. page4";
    
    CPDFOutline *outlinePage5 = [outline insertChildAtIndex:4];
    outlinePage5.label = @"5. page5";
    
    // Insert secondary directory and set outline text
    CPDFOutline *outlinePage1_1 = [outlinePage1 insertChildAtIndex:0];
    outlinePage1_1.label = @"1.1 page1_1";
    
    // Save the create outline action in document
    [document writeToURL:self.outlineURL];
    
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done.\n"];
    self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Done. Results saved in CreateOutlineTest.pdf\n"];
    
    // Refresh document
    self.document = [[CPDFDocument alloc] initWithURL:self.outlineURL];
}
    

// Print document outline information
- (void)printOutline:(CPDFDocument *)document {
    // Get root from PDF document
    CPDFOutline *outline = [document outlineRoot];
    
    // Get subdirectory from root
    [self loadOutline:outline level:0];
}

// Get subdirectory from root
- (void)loadOutline:(CPDFOutline *)outline level:(NSInteger)level {
    
    for (int i=0; i<[outline numberOfChildren]; i++) {
        CPDFOutline *data = [outline childAtIndex:i];
        CPDFDestination *destination = [data destination];
        if (!destination) {
            CPDFAction *action = [data action];
            if (action && [action isKindOfClass:[CPDFGoToAction class]]) {
                destination = [(CPDFGoToAction *)action destination];
            }
        }
        
        // The previous level directory will be one \t away from the previous level directory
        NSString *intervalStr = @"";
        for (int j = 0; j < level; j++) {
            self.commandLineStr = [self.commandLineStr stringByAppendingString:@"\t"];
        }
        self.commandLineStr = [self.commandLineStr stringByAppendingFormat:@"%@->%@\n", intervalStr, data.label];

        [self loadOutline:data level:level+1];
    }
}

- (void)openFile {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:@[self.outlineURL] applicationActivities:nil];
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
        
        UIAlertAction *textSearchAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"     CreateOutlineTest.pdf      ", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // Open CreateOutlineTest.pdf
            [self openFile];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:textSearchAction];
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
        self.commandLineStr = [self.commandLineStr stringByAppendingString:@"Running OutlineText sample...\n\n"];
        [self createOutline:self.document];
        [self printOutline:self.document];
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
