//
//  CPDFListView.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <ComPDFKit/ComPDFKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CToolModel) {
    CToolModelViewer,
    CToolModelEdit,
    CToolModelAnnotation,
    CToolModelForm,
    CToolModelPageEdit
};

typedef NS_ENUM(NSInteger, CPDFViewAnnotationMode) {
    CPDFViewAnnotationModeNone = 0,
    CPDFViewAnnotationModeNote,
    CPDFViewAnnotationModeHighlight,
    CPDFViewAnnotationModeUnderline,
    CPDFViewAnnotationModeStrikeout,
    CPDFViewAnnotationModeSquiggly,
    CPDFViewAnnotationModeCircle,
    CPDFViewAnnotationModeSquare,
    CPDFViewAnnotationModeArrow,
    CPDFViewAnnotationModeLine,
    CPDFViewAnnotationModeInk,
    CPDFViewAnnotationModePencilDrawing, // API_AVAILABLE(ios(13.0))
    CPDFViewAnnotationModeFreeText,
    CPDFViewAnnotationModeSignature,
    CPDFViewAnnotationModeStamp,
    CPDFViewAnnotationModeImage,
    CPDFViewAnnotationModeLink,
    CPDFViewAnnotationModeSound,
    
    CPDFViewFormModeText = 1000,
    CPDFViewFormModeCheckBox,
    CPDFViewFormModeRadioButton,
    CPDFViewFormModeCombox,
    CPDFViewFormModeList,
    CPDFViewFormModeButton,
    CPDFViewFormModeSign
};


extern NSNotificationName const CPDFListViewToolModeChangeNotification;

extern NSNotificationName const CPDFListViewAnnotationModeChangeNotification;

extern NSNotificationName const CPDFListViewActiveAnnotationsChangeNotification;

extern NSNotificationName const CPDFListViewAnnotationsOperationChangeNotification;

#pragma mark - CPDFListViewDelegate

@class CPDFListView;
@class CPDFSlider;

@protocol CPDFListViewDelegate <NSObject>

@optional

- (NSArray<UIMenuItem *> *)PDFListView:(CPDFListView *)pdfListView customizeMenuItems:(NSArray <UIMenuItem *>*)menuItems forPage:(CPDFPage *)page forPagePoint:(CGPoint)pagePoint;

- (void)PDFListViewPerformTouchEnded:(CPDFListView *)pdfListView;

- (void)PDFListViewChangedToolMode:(CPDFListView *)pdfListView forToolMode:(CToolModel)toolMode;

- (void)PDFListViewChangedAnnotationType:(CPDFListView *)pdfListView forAnnotationMode:(CPDFViewAnnotationMode)annotationMode;

- (void)PDFListViewChangeatioActiveAnnotations:(CPDFListView *)pdfListView forActiveAnnotations:(NSArray<CPDFAnnotation *> *)annotations;

- (void)PDFListViewAnnotationsOperationChange:(CPDFListView *)pdfListView;

- (void)PDFListViewEditNote:(CPDFListView *)pdfListView forAnnotation:(CPDFAnnotation *)annotation;

- (void)PDFListViewEditProperties:(CPDFListView *)pdfListView forAnnotation:(CPDFAnnotation *)annotation;

- (void)PDFListViewPerformPlay:(CPDFListView *)pdfView forAnnotation:(CPDFSoundAnnotation *)annotation;

- (void)PDFListViewPerformCancelMedia:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page;

- (void)PDFListViewPerformRecordMedia:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page;

- (BOOL)PDFListViewerTouchEndedIsAudioRecordMedia:(CPDFListView *)pdfListView;

- (void)PDFListViewPerformAddStamp:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page;

- (void)PDFListViewPerformAddImage:(CPDFListView *)pdfView atPoint:(CGPoint)point forPage:(CPDFPage *)page;

- (void)PDFListViewPerformSignatureWidget:(CPDFListView *)pdfView forAnnotation:(CPDFSignatureWidgetAnnotation *)annotation;

- (void)PDFListViewContentEditProperty:(CPDFListView *)pdfListView point:(CGPoint)point;

@end

#pragma mark - CPDFListView

@interface CPDFListView : CPDFView

@property (nonatomic, weak) id<CPDFListViewDelegate> performDelegate;

@property (nonatomic, strong) CPDFSlider *pageSliderView;

@property (nonatomic, assign) CToolModel toolModel;

@property (nonatomic, assign) CPDFViewAnnotationMode annotationMode;

@property (nonatomic, strong) NSUndoManager *undoPDFManager;

@property (nonatomic, readonly) NSMutableArray <CPDFAnnotation *>*activeAnnotations;

- (void)addAnnotation:(CPDFAnnotation *)annotation;

- (void)updateActiveAnnotations:(NSArray <CPDFAnnotation *> *)activeAnnotations;

- (void)addAnnotation:(CPDFAnnotation *)annotation forPage:(CPDFPage *)page;

- (void)stopRecord;

- (void)registerAsObserver;

- (void)stopObservingNotes:(NSArray *)oldNotes;

- (BOOL)canUndo;

- (BOOL)canRedo;

- (void)stopObserving;

@end

NS_ASSUME_NONNULL_END
