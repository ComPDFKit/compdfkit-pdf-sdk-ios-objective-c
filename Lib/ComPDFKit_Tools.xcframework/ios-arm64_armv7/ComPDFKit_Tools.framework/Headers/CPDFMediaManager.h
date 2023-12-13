//
//  CPDFMediaManager.h
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
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPDFMediaState) {
    CPDFMediaStateStop = 0,
    CPDFMediaStateRedayRecord,
    CPDFMediaStateAudioRecord,
    CPDFMediaStateVedioPlaying
};

@interface CPDFMediaManager : NSObject

+ (CPDFMediaManager*)shareManager;

@property (nonatomic, assign)CPDFMediaState mediaState;

@property (nonatomic, assign)NSInteger pageNum;

@property (nonatomic, assign)CGPoint ptInPdf;

@end
