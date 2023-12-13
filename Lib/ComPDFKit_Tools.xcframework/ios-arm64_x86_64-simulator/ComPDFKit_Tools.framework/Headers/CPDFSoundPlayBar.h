//
//  CPDFSoundPlayBar.h
//  ComPDFKit_Tools
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPDFSoundState) {
    CPDFSoundStateRecord = 0,
    CPDFSoundStatePlay
};

@class CPDFSoundPlayBar;
@class CAnnotStyle;

NS_ASSUME_NONNULL_BEGIN

@protocol CPDFSoundPlayBarDelegate <NSObject>

@optional

- (void)soundPlayBarRecordFinished:(CPDFSoundPlayBar *)soundPlayBar withFile:(NSString *)filePath;

- (void)soundPlayBarRecordCancel:(CPDFSoundPlayBar *)soundPlayBar;

- (void)soundPlayBarPlayClose:(CPDFSoundPlayBar *)soundPlayBar;

@end

@interface CPDFSoundPlayBar : UIView

@property (nonatomic, readonly) CAnnotStyle *annotStyle;

@property (nonatomic, readonly) CPDFSoundState soundState;

@property (nonatomic, weak) id<CPDFSoundPlayBarDelegate> delegate;

- (instancetype)initWithStyle:(CAnnotStyle *)annotStyle;

- (void)showInView:(UIView *)subView soundState:(CPDFSoundState)soundState;

- (void)setURL:(NSURL *)url;

- (void)startAudioRecord;

- (void)stopRecord;

- (void)startAudioPlay;

- (void)stopAudioPlay;

@end

NS_ASSUME_NONNULL_END
