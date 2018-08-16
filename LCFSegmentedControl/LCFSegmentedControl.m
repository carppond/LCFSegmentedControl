//
//  LCFSegmentedControl.m
//  sSegment
//
//  Created by lichengfu on 2018/8/9.
//  Copyright © 2018年 lichengfu. All rights reserved.
//

#import "LCFSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@interface  LCFScrollView : UIScrollView
@end

@interface  LCFSegmentedControl ()

@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, strong) LCFScrollView *scrollView;
@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorArrowLayer;
@property (nonatomic, readwrite) NSArray<NSNumber *> *segmentWidthsArray;
@end

@implementation LCFScrollView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else{
        [super touchesBegan:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
    else{
        [super touchesMoved:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    else{
        [super touchesEnded:touches withEvent:event];
    }
}
@end

@implementation LCFSegmentedControl
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lcf_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self lcf_commonInit];
    }
    return self;
}
- (instancetype)initWithSectionTitles:(NSArray<NSString *> *)sectionTitles
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self lcf_commonInit];
        self.sectionTitles = sectionTitles;
        self.type = LCFSegmentedControlTypeText;
    }
    return self;
}

- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages
                sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self lcf_commonInit];
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.type = LCFSegmentedControlTypeImages;
    }
    return self;
}

- (instancetype)initWithSectionImages:(NSArray<UIImage *> *)sectionImages sectionSelectedImages:(NSArray<UIImage *> *)sectionSelectedImages titlesForSections:(NSArray<NSString *> *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self lcf_commonInit];
        
        if (sectionImages.count != sectiontitles.count) {
            [NSException raise:NSRangeException format:@"***%s: Images bounds (%ld) Don't match Title bounds (%ld)", sel_getName(_cmd), (unsigned long)sectionImages.count, (unsigned long)sectiontitles.count];
        }
        
        self.sectionImages = sectionImages;
        self.sectionSelectedImages = sectionSelectedImages;
        self.sectionTitles = sectiontitles;
        self.type = LCFSegmentedControlTypeTextImages;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.segmentWidth = 0.0f;
}
- (void)lcf_commonInit
{
    self.scrollView = [[LCFScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    _backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    _selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0 alpha:1.0f];
    _selectionIndicatorBoxColor = self.selectionIndicatorColor;
    
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.selectionStyle = LCFSegmentedControlSelectionStyleTextWidthStripe;
    self.selectionIndicatorLocation = LCFSegmentedControlSelectionIndicatorLocationUp;
    self.segmentWidthStyle = LCFSegmentedControlSegmentWidthStyleFixed;
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.verticalDividerEnabled = NO;
    self.type = LCFSegmentedControlTypeText;
    self.verticalDividerWidth = 1.0f;
    self.verticalDivderColor = [UIColor blackColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1.0f;
    
    self.shouldAnimateUserSelection = YES;
    
    self.selectionIndicatorStripLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer.opacity = self.selectionIndicatorBoxOpacity;
    self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
    self.selectionIndicatorBoxOpacity = 0.2;
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self lcf_updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self lcf_updateSegmentsRects];
}

- (void)setSectionTitles:(NSArray<NSString *> *)sectionTitles
{
    _sectionTitles = sectionTitles;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSectionImages:(NSArray<UIImage *> *)sectionImages
{
    _sectionImages = sectionImages;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSelectionIndicatorLocation:(LCFSegmentedControlSelectionIndicatorLocation)selectionIndicatorLocation
{
    _selectionIndicatorLocation = selectionIndicatorLocation;
    
    if (selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationNone) {
        self.selectionIndicatorHeight = 0.0f;
    }
}

- (void)setSelectionIndicatorBoxOpacity:(CGFloat)selectionIndicatorBoxOpacity
{
    _selectionIndicatorBoxOpacity = selectionIndicatorBoxOpacity;
    
    self.selectionIndicatorBoxLayer.opacity = selectionIndicatorBoxOpacity;
}

- (void)setSegmentWidthStyle:(LCFSegmentedControlSegmentWidthStyle)segmentWidthStyle
{
    if (self.type == LCFSegmentedControlTypeImages) {
        _segmentWidthStyle = LCFSegmentedControlSegmentWidthStyleFixed;
    } else {
        _segmentWidthStyle = segmentWidthStyle;
    }
}

- (void)setBorderType:(LCFSegmentedControlBorderType)borderType
{
    _borderType = borderType;
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing

/*!
 *  @method sectionTitles
 *
 *  Size to measure the currently title text
 */
- (CGSize)lcf_measureTitleAtIndex:(NSUInteger)index
{
    if (index >= self.sectionTitles.count) {
        return CGSizeZero;
    }
    id title = self.sectionTitles[index];
    CGSize size = CGSizeZero;
    BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
    if ([title isKindOfClass:[NSString class]] && !self.titleFormatter) {
        NSDictionary *titleAttrs = selected ? [self lcf_resultingSelectedTitleTextAttributes] : [self lcf_resultingTitleTextAttributes];
        size = [(NSString *)title sizeWithAttributes:titleAttrs];
        UIFont *font = titleAttrs[@"NSFont"];
        size = CGSizeMake(ceil(size.width), ceil(size.height - font.descender));
    } else if ([title isKindOfClass:[NSString class]] && self.titleFormatter){
        size = [self.titleFormatter(self, title, index, selected) size];
    } else if ([title isKindOfClass:[NSAttributedString class]]) {
        size = [(NSAttributedString *)title size];
    } else {
        NSAssert(title == nil, @"Unexpected type of segment title: %@", [title class]);
        size = CGSizeZero;
    }
    return CGRectIntegral((CGRect){CGPointZero,size}).size;
}

- (NSAttributedString *)lcf_attributedTitleAtIndex:(NSUInteger)index
{
    id title = self.sectionTitles[index];
    BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
    
    if ([title isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)title;
    } else if (!self.titleFormatter){
        NSDictionary *titleAttrrs = selected ? [self lcf_resultingSelectedTitleTextAttributes] : [self lcf_resultingTitleTextAttributes];
        
        // the color should be cast to CGColor in order to avoid invalid context on iOS7
        UIColor *titleColor = titleAttrrs[NSForegroundColorAttributeName];
        if (titleColor) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:titleAttrrs];
            dict[NSForegroundColorAttributeName] = titleColor;
            titleAttrrs = [NSDictionary dictionaryWithDictionary:dict];
        }
        return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:titleAttrrs];
    } else {
        return self.titleFormatter(self, title, index, selected);
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    
    self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorBoxColor.CGColor;
    self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorBoxColor.CGColor;
    
    /// Remove all sublayers to avoid drawing images over existing ones.
    self.scrollView.layer.sublayers = nil;
    
    CGRect oldRect = rect;
    
    if (self.type == LCFSegmentedControlTypeText) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat stringWidth = 0.0f;
            CGFloat stringHeight = 0.0f;
            CGSize size = [self lcf_measureTitleAtIndex:idx];
            stringWidth = size.width;
            stringHeight = size.height;
            CGRect rectDiv = CGRectZero;
            CGRect fullRect = CGRectZero;
            
            // Text inside the CATextLayer will appear blurry unless the rect values are rounded
            BOOL locationUp = (self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationUp);
            BOOL selectionStyleNotBox = (self.selectionStyle != LCFSegmentedControlSelectionStyleBox);
            
            CGFloat y = roundf(CGRectGetHeight(self.frame) - selectionStyleNotBox * self.selectionIndicatorHeight) / 2 - stringHeight / 2 + self.selectionIndicatorHeight * locationUp;
            CGRect rect;
            if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
                rect = CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - stringWidth) / 2, y, stringWidth, stringHeight);
                rectDiv = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height - (self.selectionIndicatorHeight * 4));
                fullRect = CGRectMake(self.segmentWidth * idx, 0, self.segmentWidth, oldRect.size.height);
            } else {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i)
                        break;
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                CGFloat widthForIndex = [[self.segmentWidthsArray objectAtIndex:idx] floatValue];
                rect = CGRectMake(xOffset, y, widthForIndex, stringHeight);
                fullRect = CGRectMake(self.segmentWidth * idx, 0, widthForIndex, oldRect.size.height);
                rectDiv = CGRectMake(xOffset - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height - (self.selectionIndicatorHeight * 4));
            }
            
            // Fix rect positions/size to avoid blurry labels
            rect = CGRectMake(ceil(rect.origin.x), ceil(rect.origin.y), ceil(rect.size.width), ceil(rect.size.height));
            
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = rect;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
                titleLayer.truncationMode = kCATruncationEnd;
            }
            titleLayer.string = [self lcf_attributedTitleAtIndex:idx];
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            
            [self.scrollView.layer addSublayer:titleLayer];
            
            // Vertical Divider
            if (self.isVerticalDividerEnabled && idx > 0) {
                CALayer *verticalDividerLayer = [CALayer layer];
                verticalDividerLayer.frame = rectDiv;
                verticalDividerLayer.backgroundColor = self.verticalDivderColor.CGColor;
                
                [self.scrollView.layer addSublayer:verticalDividerLayer];
            }
            [self lcf_addBackgroundAndBorderLayerWithRect:fullRect];
        }];
    } else if (self.type == LCFSegmentedControlTypeImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            CGFloat y = roundf(CGRectGetHeight(self.frame) - self.selectionIndicatorHeight) / 2 - imageHeight / 2 + ((self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationUp) ? self.selectionIndicatorHeight : 0);
            CGFloat x = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
            CGRect rect = CGRectMake(x, y, imageWidth, imageHeight);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = rect;
            
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
            // Vertical Divider
            if (self.isVerticalDividerEnabled && idx>0) {
                CALayer *verticalDividerLayer = [CALayer layer];
                verticalDividerLayer.frame = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.selectionIndicatorHeight * 2, self.verticalDividerWidth, self.frame.size.height-(self.selectionIndicatorHeight * 4));
                verticalDividerLayer.backgroundColor = self.verticalDivderColor.CGColor;
                
                [self.scrollView.layer addSublayer:verticalDividerLayer];
            }
            
            [self lcf_addBackgroundAndBorderLayerWithRect:rect];
        }];
    } else if (self.type == LCFSegmentedControlTypeTextImages) {
        [self.sectionImages enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
            UIImage *icon = iconImage;
            CGFloat imageWidth = icon.size.width;
            CGFloat imageHeight = icon.size.height;
            
            CGSize stringSize = [self lcf_measureTitleAtIndex:idx];
            CGFloat stringHeight = stringSize.height;
            CGFloat stringWidth = stringSize.width;
            
            CGFloat imageXOffset = self.segmentWidth * idx; // Start with edge inset
            CGFloat textXOffset  = self.segmentWidth * idx;
            CGFloat imageYOffset = ceilf((self.frame.size.height - imageHeight) / 2.0); // Start in center
            CGFloat textYOffset  = ceilf((self.frame.size.height - stringHeight) / 2.0);
            
            
            if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
                BOOL isImageInLineWidthText = self.imagePosition == LCFSegmentedControlImagePositionLeftOfText || self.imagePosition == LCFSegmentedControlImagePositionRightOfText;
                if (isImageInLineWidthText) {
                    CGFloat whitespace = self.segmentWidth - stringSize.width - imageWidth - self.textImageSpacing;
                    if (self.imagePosition == LCFSegmentedControlImagePositionLeftOfText) {
                        imageXOffset += whitespace / 2.0;
                        textXOffset = imageXOffset + imageWidth + self.textImageSpacing;
                    } else {
                        textXOffset += whitespace / 2.0;
                        imageXOffset = textXOffset + stringWidth + self.textImageSpacing;
                    }
                } else {
                    imageXOffset = self.segmentWidth * idx + (self.segmentWidth - imageWidth) / 2.0f; // Start with edge inset
                    textXOffset  = self.segmentWidth * idx + (self.segmentWidth - stringWidth) / 2.0f;
                    
                    CGFloat whitespace = CGRectGetHeight(self.frame) - imageHeight - stringHeight - self.textImageSpacing;
                    if (self.imagePosition == LCFSegmentedControlImagePositionAboveText) {
                        imageYOffset = ceilf(whitespace / 2.0);
                        textYOffset = imageYOffset + imageHeight + self.textImageSpacing;
                    } else if (self.imagePosition == LCFSegmentedControlImagePositionBelowText) {
                        textYOffset = ceilf(whitespace / 2.0);
                        imageYOffset = textYOffset + stringHeight + self.textImageSpacing;
                    }
                }
            } else if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic) {
                // When we are drawing dynamic widths, we need to loop the widths array to calculate the xOffset
                CGFloat xOffset = 0;
                NSInteger i = 0;
                
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (idx == i) {
                        break;
                    }
                    
                    xOffset = xOffset + [width floatValue];
                    i++;
                }
                
                BOOL isImageInLineWidthText = self.imagePosition == LCFSegmentedControlImagePositionLeftOfText || self.imagePosition == LCFSegmentedControlImagePositionRightOfText;
                if (isImageInLineWidthText) {
                    if (self.imagePosition == LCFSegmentedControlImagePositionLeftOfText) {
                        imageXOffset = xOffset;
                        textXOffset = imageXOffset + imageWidth + self.textImageSpacing;
                    } else {
                        textXOffset = xOffset;
                        imageXOffset = textXOffset + stringWidth + self.textImageSpacing;
                    }
                } else {
                    imageXOffset = xOffset + ([self.segmentWidthsArray[i] floatValue] - imageWidth) / 2.0f; // Start with edge inset
                    textXOffset  = xOffset + ([self.segmentWidthsArray[i] floatValue] - stringWidth) / 2.0f;
                    
                    CGFloat whitespace = CGRectGetHeight(self.frame) - imageHeight - stringHeight - self.textImageSpacing;
                    if (self.imagePosition == LCFSegmentedControlImagePositionAboveText) {
                        imageYOffset = ceilf(whitespace / 2.0);
                        textYOffset = imageYOffset + imageHeight + self.textImageSpacing;
                    } else if (self.imagePosition == LCFSegmentedControlImagePositionBelowText) {
                        textYOffset = ceilf(whitespace / 2.0);
                        imageYOffset = textYOffset + stringHeight + self.textImageSpacing;
                    }
                }
            }
            
            CGRect imageRect = CGRectMake(imageXOffset, imageYOffset, imageWidth, imageHeight);
            CGRect textRect = CGRectMake(ceilf(textXOffset), ceilf(textYOffset), ceilf(stringWidth), ceilf(stringHeight));
            
            CATextLayer *titleLayer = [CATextLayer layer];
            titleLayer.frame = textRect;
            titleLayer.alignmentMode = kCAAlignmentCenter;
            titleLayer.string = [self lcf_attributedTitleAtIndex:idx];
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
                titleLayer.truncationMode = kCATruncationEnd;
            }
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = imageRect;
            
            if (self.selectedSegmentIndex == idx) {
                if (self.sectionSelectedImages) {
                    UIImage *highlightIcon = [self.sectionSelectedImages objectAtIndex:idx];
                    imageLayer.contents = (id)highlightIcon.CGImage;
                } else {
                    imageLayer.contents = (id)icon.CGImage;
                }
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
            
            [self.scrollView.layer addSublayer:imageLayer];
            titleLayer.contentsScale = [[UIScreen mainScreen] scale];
            [self.scrollView.layer addSublayer:titleLayer];
            
            [self lcf_addBackgroundAndBorderLayerWithRect:imageRect];
        }];
    }
    // Add the selection indicators
    if (self.selectedSegmentIndex != LCFSegmentedControlNoSegment) {
        if (self.selectionStyle == LCFSegmentedControlSelectionStyleArrow) {
            if (!self.selectionIndicatorArrowLayer.superlayer) {
                [self lcf_setArrowFrame];
                [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
            }
        } else {
            if (!self.selectionIndicatorStripLayer.superlayer) {
                self.selectionIndicatorStripLayer.frame = [self lcf_frameForSelectionIndicator];
                [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == LCFSegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
                    self.selectionIndicatorBoxLayer.frame = [self lcf_frameForFillerSelectionIndicator];
                    [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                }
            }
        }
    }
}

- (void)lcf_addBackgroundAndBorderLayerWithRect:(CGRect)fullRect
{
    /// Background layer
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = fullRect;
    [self.layer insertSublayer:backgroundLayer atIndex:0];
    
    /// Border layer
    if (self.borderType & LCFSegmentedControlBorderTypeTop) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, 0, fullRect.size.width, self.borderWidth);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer:borderLayer];
    }
    if (self.borderType & LCFSegmentedControlBorderTypeLeft) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, 0, self.borderWidth, fullRect.size.height);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer:borderLayer];
    }
    if (self.borderType & LCFSegmentedControlBorderTypeBottom) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0, fullRect.size.height - self.borderWidth, fullRect.size.width, self.borderWidth);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer:borderLayer];
    }
    if (self.borderType & LCFSegmentedControlBorderTypeRight) {
        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(fullRect.size.width - self.borderWidth, 0, self.borderWidth, fullRect.size.height);
        borderLayer.backgroundColor = self.borderColor.CGColor;
        [backgroundLayer addSublayer:borderLayer];
    }
}

- (void)lcf_setArrowFrame {
    self.selectionIndicatorArrowLayer.frame = [self lcf_frameForSelectionIndicator];
    
    self.selectionIndicatorArrowLayer.mask = nil;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGPoint p3 = CGPointZero;
    
    if (self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationDown) {
        p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, 0);
        p2 = CGPointMake(0, self.selectionIndicatorArrowLayer.bounds.size.height);
        p3 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, self.selectionIndicatorArrowLayer.bounds.size.height);
    }
    
    if (self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationUp) {
        p1 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, self.selectionIndicatorArrowLayer.bounds.size.height);
        p2 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, 0);
        p3 = CGPointMake(0, 0);
    }
    
    [arrowPath moveToPoint:p1];
    [arrowPath addLineToPoint:p2];
    [arrowPath addLineToPoint:p3];
    [arrowPath closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.selectionIndicatorArrowLayer.bounds;
    maskLayer.path = arrowPath.CGPath;
    self.selectionIndicatorArrowLayer.mask = maskLayer;
}

- (CGRect)lcf_frameForSelectionIndicator {
    CGFloat indicatorYOffset = 0.0f;
    
    if (self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationDown) {
        indicatorYOffset = self.bounds.size.height - self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom;
    }
    
    if (self.selectionIndicatorLocation == LCFSegmentedControlSelectionIndicatorLocationUp) {
        indicatorYOffset = self.selectionIndicatorEdgeInsets.top;
    }
    
    CGFloat sectionWidth = 0.0f;
    
    if (self.type == LCFSegmentedControlTypeText) {
        CGFloat stringWidth = [self lcf_measureTitleAtIndex:self.selectedSegmentIndex].width;
        sectionWidth = stringWidth;
    } else if (self.type == LCFSegmentedControlTypeImages) {
        UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
        CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = imageWidth;
    } else if (self.type == LCFSegmentedControlTypeTextImages) {
        CGFloat stringWidth = [self lcf_measureTitleAtIndex:self.selectedSegmentIndex].width;
        UIImage *sectionImage = [self.sectionImages objectAtIndex:self.selectedSegmentIndex];
        CGFloat imageWidth = sectionImage.size.width;
        sectionWidth = MAX(stringWidth, imageWidth);
    }
    
    if (self.selectionStyle == LCFSegmentedControlSelectionStyleArrow) {
        CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
        
        CGFloat x = widthToStartOfSelectedIndex + ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) - (self.selectionIndicatorHeight/2);
        return CGRectMake(x - (self.selectionIndicatorHeight / 2), indicatorYOffset, self.selectionIndicatorHeight * 2, self.selectionIndicatorHeight);
    } else {
        if (self.selectionStyle == LCFSegmentedControlSelectionStyleTextWidthStripe &&
            sectionWidth <= self.segmentWidth &&
            self.segmentWidthStyle != LCFSegmentedControlSegmentWidthStyleDynamic) {
            CGFloat widthToEndOfSelectedSegment = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
            CGFloat widthToStartOfSelectedIndex = (self.segmentWidth * self.selectedSegmentIndex);
            
            CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - sectionWidth / 2);
            return CGRectMake(x + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, sectionWidth - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
        } else {
            if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic) {
                CGFloat selectedSegmentOffset = 0.0f;
                
                NSInteger i = 0;
                for (NSNumber *width in self.segmentWidthsArray) {
                    if (self.selectedSegmentIndex == i)
                        break;
                    selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
                    i++;
                }
                return CGRectMake(selectedSegmentOffset + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom);
            }
            
            return CGRectMake((self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * self.selectedSegmentIndex, indicatorYOffset, self.segmentWidth - self.selectionIndicatorEdgeInsets.right, self.selectionIndicatorHeight);
        }
    }
}

- (CGRect)lcf_frameForFillerSelectionIndicator {
    if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat selectedSegmentOffset = 0.0f;
        
        NSInteger i = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == i) {
                break;
            }
            selectedSegmentOffset = selectedSegmentOffset + [width floatValue];
            
            i++;
        }
        
        return CGRectMake(selectedSegmentOffset, 0, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue], CGRectGetHeight(self.frame));
    }
    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}


#pragma mark - Scrolling

- (CGFloat)lcf_totalSegmentedControlWidth{
    if (self.type == LCFSegmentedControlTypeText && self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
        return self.sectionTitles.count * self.segmentWidth;
    } else if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic){
        return [[self.segmentWidthsArray valueForKeyPath:@"@sum.self"] floatValue];
    } else {
        return self.sectionImages.count * self.segmentWidth;
    }
}

- (void)lcf_scrollToSelectedSegmentIndex:(BOOL)animated {
    CGRect rectForSelectedIndex = CGRectZero;
    CGFloat selectedSegmentOffset = 0;
    if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
        rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                          0,
                                          self.segmentWidth,
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    } else {
        NSInteger i = 0;
        CGFloat offsetter = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == i)
                break;
            offsetter = offsetter + [width floatValue];
            i++;
        }
        
        rectForSelectedIndex = CGRectMake(offsetter,
                                          0,
                                          [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue],
                                          self.frame.size.height);
        
        selectedSegmentOffset = (CGRectGetWidth(self.frame) / 2) - ([[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] / 2);
    }
    
    
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selectedSegmentOffset;
    rectToScrollTo.size.width += selectedSegmentOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    CGRect enlargeRect =   CGRectMake(self.bounds.origin.x - self.enlargeEdgeInset.left,
                                      self.bounds.origin.y - self.enlargeEdgeInset.top,
                                      self.bounds.size.width + self.enlargeEdgeInset.left + self.enlargeEdgeInset.right,
                                      self.bounds.size.height + self.enlargeEdgeInset.top + self.enlargeEdgeInset.bottom);
    
    if (CGRectContainsPoint(enlargeRect, touchLocation)) {
        NSInteger segment = 0;
        if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        } else if (self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic) {
            // To know which segment the user touched, we need to loop over the widths and substract it from the x position.
            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
            for (NSNumber *width in self.segmentWidthsArray) {
                widthLeft = widthLeft - [width floatValue];
                
                // When we don't have any width left to substract, we have the segment index.
                if (widthLeft <= 0)
                    break;
                
                segment++;
            }
        }
        
        NSUInteger sectionsCount = 0;
        
        if (self.type == LCFSegmentedControlTypeImages) {
            sectionsCount = [self.sectionImages count];
        } else if (self.type == LCFSegmentedControlTypeTextImages || self.type == LCFSegmentedControlTypeText) {
            sectionsCount = [self.sectionTitles count];
        }
        
        if (segment != self.selectedSegmentIndex && segment < sectionsCount) {
            // Check if we have to do anything with the touch event
            if (self.isTouchEnabled)
                [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }
    }
}

#pragma mark - Index Change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedSegmentIndex = index;
    [self setNeedsDisplay];
    
    if (index == LCFSegmentedControlNoSegment) {
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        [self lcf_scrollToSelectedSegmentIndex:animated];
        
        if (animated) {
            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new
            // segment index without animating.
            if(self.selectionStyle == LCFSegmentedControlSelectionStyleArrow) {
                if ([self.selectionIndicatorArrowLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }else {
                if ([self.selectionIndicatorStripLayer superlayer] == nil) {
                    [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                    
                    if (self.selectionStyle == LCFSegmentedControlSelectionStyleBox && [self.selectionIndicatorBoxLayer superlayer] == nil)
                        [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                    
                    [self setSelectedSegmentIndex:index animated:NO notify:YES];
                    return;
                }
            }
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
            
            // Restore CALayer animations
            self.selectionIndicatorArrowLayer.actions = nil;
            self.selectionIndicatorStripLayer.actions = nil;
            self.selectionIndicatorBoxLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [self lcf_setArrowFrame];
            self.selectionIndicatorBoxLayer.frame = [self lcf_frameForSelectionIndicator];
            self.selectionIndicatorStripLayer.frame = [self lcf_frameForSelectionIndicator];
            self.selectionIndicatorBoxLayer.frame = [self lcf_frameForFillerSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectionIndicatorArrowLayer.actions = newActions;
            [self lcf_setArrowFrame];
            
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self lcf_frameForSelectionIndicator];
            
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self lcf_frameForFillerSelectionIndicator];
            
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

#pragma mark - Private Method

/*!
 Text attributes to item normal title text.
 */
- (NSDictionary *)lcf_resultingTitleTextAttributes
{
    NSDictionary *defaults = @{NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
                      NSForegroundColorAttributeName : [UIColor blackColor]
                                };
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    if (self.titleTextAttributes) {
        [resultingAttrs addEntriesFromDictionary:self.titleTextAttributes];
    }
    return resultingAttrs.copy;
}

/*!
 Text attributes to item selected title text.
 */
- (NSDictionary *)lcf_resultingSelectedTitleTextAttributes
{
    NSMutableDictionary *resultingAttris = [NSMutableDictionary dictionaryWithDictionary:[self lcf_resultingTitleTextAttributes]];
    if (self.selectedTitleTextAttributes) {
        [resultingAttris addEntriesFromDictionary:self.selectedTitleTextAttributes];
    }
    return resultingAttris.copy;
}

- (void)lcf_updateSegmentsRects
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    if ([self lcf_sectionCount] > 0) {
        self.segmentWidth = CGRectGetWidth(self.frame) / [self lcf_sectionCount];
    }
    
    if (self.type == LCFSegmentedControlTypeText && self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed) {
        [self.sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat stringWidth = [self lcf_measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }];
    } else if (self.type == LCFSegmentedControlTypeText &&
               self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic){
        NSMutableArray *mutableSegmentWithds = [NSMutableArray array];
        __block CGFloat totoalWidth = 0.0f;
        [self.sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat stringWidth = [self lcf_measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            totoalWidth += stringWidth;
            [mutableSegmentWithds addObject:[NSNumber numberWithFloat:stringWidth]];
        }];
        if (self.shouldStretchSegmentsToScreenSize && totoalWidth < self.bounds.size.width) {
            CGFloat whitespace = self.bounds.size.width - totoalWidth;
            CGFloat whitespaceForSegment = whitespace / [mutableSegmentWithds count];
            [mutableSegmentWithds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat extendedWidth = whitespaceForSegment + [obj floatValue];
                [mutableSegmentWithds replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:extendedWidth]];
            }];
        }
        self.segmentWidthsArray = [mutableSegmentWithds copy];
    } else if (self.type == LCFSegmentedControlTypeImages){
        for (UIImage *sectionImage in self.sectionImages) {
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(imageWidth, self.segmentWidth);
        }
    } else if (self.type == LCFSegmentedControlTypeImages &&
               self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleFixed){
        [self.sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat stringWidth = [self lcf_measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }];
    } else if (self.type == LCFSegmentedControlTypeImages &&
               self.segmentWidthStyle == LCFSegmentedControlSegmentWidthStyleDynamic){
        NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
        __block CGFloat totalWidth = 0.0f;
        int i = 0;
        [self.sectionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat stringWidth = [self lcf_measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            UIImage *sectionImage = [self.sectionImages objectAtIndex:i];
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            
            CGFloat combinedWidth = 0.0f;
            if (self.imagePosition == LCFSegmentedControlImagePositionLeftOfText || self.imagePosition == LCFSegmentedControlImagePositionRightOfText) {
                combinedWidth = imageWidth + stringWidth + self.textImageSpacing;
            } else {
                combinedWidth = MAX(imageWidth, stringWidth);
            }
            totalWidth += combinedWidth;
            [mutableSegmentWidths addObject:[NSNumber numberWithFloat:totalWidth]];
        }];
        if (self.shouldStretchSegmentsToScreenSize && totalWidth < self.bounds.size.width) {
            CGFloat whiteSpace = self.bounds.size.width - totalWidth;
            CGFloat whiteSpaceForSegment = whiteSpace / [mutableSegmentWidths count];
            [mutableSegmentWidths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat extendedWidth = whiteSpaceForSegment + [obj floatValue];
                [mutableSegmentWidths replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:extendedWidth]];
            }];
        }
        self.segmentWidthsArray = [mutableSegmentWidths copy];
    }
    self.scrollView.scrollEnabled = self.isUserDraggable;
    self.scrollView.contentSize = CGSizeMake([self lcf_totalSegmentedControlWidth], CGRectGetHeight(self.frame));
    
}

- (NSUInteger)lcf_sectionCount
{
    if (self.type == LCFSegmentedControlTypeText) {
        return self.sectionTitles.count;
    } else {
        return self.sectionImages.count;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil) {
        return;
    }
    
    if (self.sectionTitles || self.sectionImages) {
        [self lcf_updateSegmentsRects];
    }
}

@end





























