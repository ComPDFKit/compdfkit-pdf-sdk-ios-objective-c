//
//  ComPDFKit_Tools.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#if __has_include(<ComPDFKit_Tools/ComPDFKit_Tools.h>)

#import <ComPDFKit_Tools/CPDFConfiguration.h>
#import <ComPDFKit_Tools/CPDFViewBaseController.h>

#import <ComPDFKit_Tools/CPDFColorUtils.h>

// Navigtion
#import <ComPDFKit_Tools/CNavigationController.h>
#import <ComPDFKit_Tools/CNavigationBarTitleButton.h>
#import <ComPDFKit_Tools/CPDFPopMenu.h>
#import <ComPDFKit_Tools/CPDFPopMenuView.h>

// Search
#import <ComPDFKit_Tools/CPDFSearchResultsViewController.h>
#import <ComPDFKit_Tools/CSearchToolbar.h>

// Outline
#import <ComPDFKit_Tools/CPDFOutlineViewController.h>

// Thumbnail
#import <ComPDFKit_Tools/CPDFThumbnailViewController.h>

// PDF Display
#import <ComPDFKit_Tools/CPDFDisplayViewController.h>

// Navigation RightView

// BOTA
#import <ComPDFKit_Tools/CPDFBOTAViewController.h>

#import <ComPDFKit_Tools/CNavigationRightView.h>

#import <ComPDFKit_Tools/CActivityIndicatorView.h>

// ListView
#import <ComPDFKit_Tools/CPDFListView.h>

#import <ComPDFKit_Tools/CPDFSlider.h>

// PDFInfo
#import <ComPDFKit_Tools/CPDFInfoViewController.h>

// Annotation
#import <ComPDFKit_Tools/CPDFAnnotationToolBar.h>
#import <ComPDFKit_Tools/CPDFAnnotationBaseViewController.h>
#import <ComPDFKit_Tools/CPDFNoteViewController.h>
#import <ComPDFKit_Tools/CPDFHighlightViewController.h>
#import <ComPDFKit_Tools/CPDFUnderlineViewController.h>
#import <ComPDFKit_Tools/CPDFStrikeoutViewController.h>
#import <ComPDFKit_Tools/CPDFSquigglyViewController.h>
#import <ComPDFKit_Tools/CPDFInkTopToolBar.h>
#import <ComPDFKit_Tools/CPDFDrawPencilKitFuncView.h>
#import <ComPDFKit_Tools/CAnnotationManage.h>
#import <ComPDFKit_Tools/CPDFNoteOpenViewController.h>
#import <ComPDFKit_Tools/CPDFSignatureViewController.h>
#import <ComPDFKit_Tools/AAPLCustomPresentationController.h>
#import <ComPDFKit_Tools/CAnnotStyle.h>

//Edit
#import <ComPDFKit_Tools/CPDFEditToolBar.h>
#import <ComPDFKit_Tools/CPDFEditViewController.h>
#import <ComPDFKit_Tools/CPDFToolsViewController.h>
#import <ComPDFKit_Tools/CPDFSoundPlayBar.h>

// Sound Manager
#import <ComPDFKit_Tools/CPDFMediaManager.h>


// Form
#import <ComPDFKit_Tools/CPDFFormToolBar.h>
#import <ComPDFKit_Tools/CPDFFormListOptionVC.h>

// Digital Signature
#import <ComPDFKit_Tools/CPDFDigitalSignatureToolBar.h>
#import <ComPDFKit_Tools/CDigitalTypeSelectView.h>
#import <ComPDFKit_Tools/CImportCertificateViewController.h>
#import <ComPDFKit_Tools/CCreateCertificateInfoViewController.h>

// Page Edit
#import <ComPDFKit_Tools/CPDFPageEditViewController.h>

// KeyboardToolbar
#import <ComPDFKit_Tools/CPDFKeyboardToolbar.h>
#import <ComPDFKit_Tools/CPDFTextProperty.h>

#import <ComPDFKit_Tools/CPDFSigntureViewController.h>
#import <ComPDFKit_Tools/CPDFSigntureVerifyViewController.h>
#import <ComPDFKit_Tools/CPDFSigntureVerifyDetailsViewController.h>
#import <ComPDFKit_Tools/CSignatureTypeSelectView.h>

#else
#import "CPDFViewBaseController.h"

#import "CPDFColorUtils.h"

// Navigtion
#import "CNavigationController.h"
#import "CNavigationBarTitleButton.h"
#import "CPDFPopMenu.h"
#import "CPDFPopMenuView.h"

// Search
#import "CPDFSearchResultsViewController.h"
#import "CSearchToolbar.h"

// Outline
#import "CPDFOutlineViewController.h"

// Thumbnail
#import "CPDFThumbnailViewController.h"

// PDF Display
#import "CPDFDisplayViewController.h"

// Navigation RightView

// BOTA
#import "CPDFBOTAViewController.h"

#import "CNavigationRightView.h"

#import "CActivityIndicatorView.h"

// ListView
#import "CPDFListView.h"

#import "CPDFSlider.h"

// PDFInfo
#import "CPDFInfoViewController.h"

// Annotation
#import "CPDFAnnotationToolBar.h"
#import "CPDFAnnotationBaseViewController.h"
#import "CPDFNoteViewController.h"
#import "CPDFHighlightViewController.h"
#import "CPDFUnderlineViewController.h"
#import "CPDFStrikeoutViewController.h"
#import "CPDFInkTopToolBar.h"
#import "CPDFDrawPencilKitFuncView.h"
#import "CAnnotationManage.h"
#import "CPDFNoteOpenViewController.h"
#import "CPDFSignatureViewController.h"
#import "AAPLCustomPresentationController.h"
//Edit
#import "CPDFEditToolBar.h"
#import "CPDFEditViewController.h"
#import "CPDFToolsViewController.h"
#import "CPDFSoundPlayBar.h"

// Sound Manager
#import "CPDFMediaManager.h"


// Form
#import "CPDFFormToolBar.h"
#import "CPDFFormListOptionVC.h"

// Digital Signature
#import "CPDFDigitalSignatureToolBar.h"
#import "CDigitalTypeSelectView.h"
#import "CImportCertificateViewController.h"
#import "CCreateCertificateInfoViewController.h"
#import "CSignatureTypeSelectView.h"

// Page Edit
#import "CPDFPageEditViewController.h"

// KeyboardToolbar
#import "CPDFKeyboardToolbar.h"
#import "CPDFTextProperty.h"

#import "CPDFSigntureViewController.h"
#import "CPDFSigntureVerifyViewController.h"
#import "CPDFSigntureVerifyDetailsViewController.h"
#endif
