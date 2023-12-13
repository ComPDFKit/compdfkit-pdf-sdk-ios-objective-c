//
//  CPDFPopMenu.h
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

@class CPDFPopMenu;

@protocol CPDFPopMenuDelegate <NSObject>

- (void)menuDidClosedIn:(CPDFPopMenu *)menu isClosed:(BOOL)isClosed;

@end

@interface CPDFPopMenu : UIView

@property(nonatomic, strong) UIImageView *backgroundContainer;

@property(nonatomic, strong) UIButton *coverLayer;

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, assign, getter=isDimCoverLayer) BOOL dimCoverLayer;

@property (nonatomic,assign) id<CPDFPopMenuDelegate> delegate;


- (instancetype) initWithContentView:(UIView *) contentView;
+ (instancetype) popMenuWithContentView:(UIView *) contentView;
- (void) showMenuInRect:(CGRect) rect;

- (void) hideMenu;

@end
