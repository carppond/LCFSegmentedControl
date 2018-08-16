//
//  LCFSegmentedControl.h
//  sSegment
//
//  Created by lichengfu on 2018/8/9.
//  Copyright © 2018年 lichengfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCFSegmentedControl;

typedef void (^IndexChangeBlock)(NSInteger index);

typedef NSAttributedString *(^LCFTitleFormatterBlock)(LCFSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected);


typedef NS_ENUM (NSInteger, LCFSegmentedControlType) {
    LCFSegmentedControlTypeText                         =  1 << 0,
    LCFSegmentedControlTypeImages                       =  1 << 1,
    LCFSegmentedControlTypeTextImages                   =  1 << 2
};

typedef NS_ENUM (NSInteger, LCFSegmentedControlSelectionStyle) {
    LCFSegmentedControlSelectionStyleTextWidthStripe    =  1 << 0,
    LCFSegmentedControlSelectionStyleFullWidthStripe    =  1 << 1,
    LCFSegmentedControlSelectionStyleBox                =  1 << 2,
    LCFSegmentedControlSelectionStyleArrow              =  1 << 3,
};

typedef NS_ENUM(NSInteger, LCFSegmentedControlSelectionIndicatorLocation) {
    LCFSegmentedControlSelectionIndicatorLocationUp,
    LCFSegmentedControlSelectionIndicatorLocationDown,
    LCFSegmentedControlSelectionIndicatorLocationNone // No selection indicator
};

typedef NS_ENUM(NSInteger, LCFSegmentedControlSegmentWidthStyle) {
    LCFSegmentedControlSegmentWidthStyleFixed, // Segment width is fixed
    LCFSegmentedControlSegmentWidthStyleDynamic, // Segment width will only be as big as the text width (including inset)
};

typedef NS_OPTIONS(NSInteger, LCFSegmentedControlBorderType) {
    LCFSegmentedControlBorderTypeNone                   = 0,
    LCFSegmentedControlBorderTypeTop                    = (1 << 0),
    LCFSegmentedControlBorderTypeLeft                   = (1 << 1),
    LCFSegmentedControlBorderTypeBottom                 = (1 << 2),
    LCFSegmentedControlBorderTypeRight                  = (1 << 3)
};

typedef NS_ENUM(NSInteger, LCFSegmentedControlImagePosition) {
    LCFSegmentedControlImagePositionBehindText,
    LCFSegmentedControlImagePositionLeftOfText,
    LCFSegmentedControlImagePositionRightOfText,
    LCFSegmentedControlImagePositionAboveText,
    LCFSegmentedControlImagePositionBelowText
};

enum {
    LCFSegmentedControlNoSegment = -1   // Segment index for no selected segment
};

@interface LCFSegmentedControl : UIControl

/*!
 *  sectionTitles
 */
@property (nonatomic, copy) NSArray<NSString *> *sectionTitles;

/*!
 *  sectionImages
 */
@property (nonatomic, copy) NSArray<UIImage *> *sectionImages;

/*!
 *  sectionSelectedImages
 */
@property (nonatomic, copy) NSArray<UIImage *> *sectionSelectedImages;

/*!
 *  Provide a block to be executed when selected index is changed.
 *
 *  Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/*
 *  Text attributes to apple to item title text.
 */
@property (nonatomic, copy) NSDictionary *titleTextAttributes;

/*!
 *  Used to apply custom text styling to titles when set.
 *
 *  When this block is set, no additional styling is applied to the `NSAttributedString` object returned from this block.
 */
@property (nonatomic, copy) LCFTitleFormatterBlock titleFormatter;
/*!
 *  Text attributes to apply to selected item title text.
 *
 *  Attributes not set in this dictionary are inherited from `titleTextAttributes`.
 */
@property (nonatomic, copy) NSDictionary *selectedTitleTextAttributes;

/*!
 *  Segmented control background color.
 *
 *  Default is '[UIColor whiteColor]'.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/*!
 *  Specifies the border color.
 *
 *  Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *borderColor;

/*!
 *  Specifies the border width.
 *
 *  Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat borderWidth;

/*!
 *  Default is YES. Set to NO to deny scrolling by dragging the scrollView by the user.
 */
@property(nonatomic, getter = isUserDraggable) BOOL userDraggable;

/*!
 *  Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled) BOOL touchEnabled;

/*!
 *  Default is NO. Set to YES to show a vertical divider between the segments.
 */
@property(nonatomic, getter = isVerticalDividerEnabled) BOOL verticalDividerEnabled;

/*!
 *  Width for the vertical divider between segments When `verticalDividerEnabled` is set to YES.
 *
 *  Default is '1.0f'.
 */
@property (nonatomic, assign) CGFloat verticalDividerWidth;

@property (nonatomic, getter=shouldStretchSegmentsToScreenSize) BOOL stretchSegmentsToScreenSize;

/*!
 *  Color for the vertical divider between segments.
 *
 *  Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *verticalDivderColor;

/*!
 *  Color for the selection indicator stripe.
 *
 *  Default is `R:52, G:181, B:229`.
 */

@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/*!
 *  Color for the selection indicator box.
 *
 *  Default is selectionIndicatorColor.
 */
@property (nonatomic, strong) UIColor *selectionIndicatorBoxColor;

/*!
 *  Specifies the style of the control.
 *
 *  Default is 'LCFSegmentedControlTypeText'.
 */
@property (nonatomic, assign) LCFSegmentedControlType type;

/*!
 *  Specifies the style of the selection indicator.
 *
 *  Default is `LCFSegmentedControlSelectionStyleTextWidthStripe`
 */
@property (nonatomic, assign) LCFSegmentedControlSelectionStyle selectionStyle;

/*!
 *  Specifies the location of the selection indicator.
 *
 *  Default is `LCFSegmentedControlSelectionIndicatorLocationUp`
 */
@property (nonatomic, assign) LCFSegmentedControlSelectionIndicatorLocation selectionIndicatorLocation;

/*!
 *  Specifies the border type.
 *
 *  Default is `LCFSegmentedControlBorderTypeNone`
 */
@property (nonatomic, assign) LCFSegmentedControlBorderType borderType;

/*!
 *  Specifies the style of the segment's width.
 *
 *  Default is `LCFSegmentedControlSegmentWidthStyleFixed`
 */
@property (nonatomic, assign) LCFSegmentedControlSegmentWidthStyle segmentWidthStyle;

/*!
 *  Specifies the image position relative to the text. Only applicable for LCFSegmentedControlTypeTextImages
 *
 *  Default is `LCFSegmentedControlImagePositionBehindText`
 */
@property (nonatomic) LCFSegmentedControlImagePosition imagePosition;

/**
 *  Specifies the distance between the text and the image. Only applicable for HMSegmentedControlTypeTextImages
 *
 *  Default is `0,0`
 */
@property (nonatomic) CGFloat textImageSpacing;

/*!
 *  Index of the currently selected segement.
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/*!
 *  Inset left and right edges of segments.
 *
 *  Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

@property (nonatomic, readwrite) UIEdgeInsets enlargeEdgeInset;

/*!
 *  Height of the selection indicator. Only effective when `LCFSegmentedControlSelectionStyle` is either
 *    `LCFSegmentedControlSelectionStyleTextWidthStripe` or `LCFSegmentedControlSelectionStyleFullWidthStripe`.
 *
 *  Default is 5.0
 */
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight;

/*!
 *  Edge insets for the selection indicator.
 *  NOTE: This does not affect the bounding box of LCFSegmentedControlSelectionStyleBox
 *
 *  When LCFSegmentedControlSelectionIndicatorLocationUp is selected, bottom edge insets are not used
 *
 *  When LCFSegmentedControlSelectionIndicatorLocationDown is selected, top edge insets are not used
 *
 *  Defaults are top: 0.0f
 *  left: 0.0f
 *  bottom: 0.0f
 *  right: 0.0f
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;

/**
 *  Default is YES. Set to NO to disable animation during user selection.
 */
@property (nonatomic) BOOL shouldAnimateUserSelection;

/**
 *  Opacity for the seletion indicator box.
 *
 *  Default is `0.2f`
 */
@property (nonatomic) CGFloat selectionIndicatorBoxOpacity;

- (id)initWithSectionTitles:(NSArray<NSString *> *)sectiontitles;


- (id)initWithSectionImages:(NSArray<UIImage *> *)sectionImages
      sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages;
- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages titlesForSections:(NSArray<NSString *> *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;
- (void)setTitleFormatter:(LCFTitleFormatterBlock)titleFormatter;

@end













