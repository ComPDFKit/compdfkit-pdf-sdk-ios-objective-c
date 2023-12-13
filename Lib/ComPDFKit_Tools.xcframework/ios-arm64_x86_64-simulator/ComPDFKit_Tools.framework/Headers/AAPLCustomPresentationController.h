//
//  CPDFBOTAViewController.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@import UIKit;

@class AAPLCustomPresentationController;

@protocol AAPLCustomPresentationControllerDelegate <NSObject>

@optional

- (void)AAPLCustomPresentationControllerTap:(AAPLCustomPresentationController *)AAPLCustomPresentationController;

@end

@interface AAPLCustomPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) id<AAPLCustomPresentationControllerDelegate> tapDelegate;

@end
