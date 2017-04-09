//
//  DXEditGridView.m
//  CameraBox
//
//  Created by Chenyan on 16/6/1.
//  Copyright © 2016年 chenyan. All rights reserved.
//

#import "CYClipperGridView.h"

@interface CYClipperGridView ()
@property (weak,nonatomic) UIView *vertical0;
@property (weak,nonatomic) UIView *vertical1;
@property (weak,nonatomic) UIView *horizontal0;
@property (weak,nonatomic) UIView *horizontal1;
@end

@implementation CYClipperGridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor blackColor];
        self.lineWidth = 0.4;
        self.vertical0 = [self creatGrid];
        self.vertical1 = [self creatGrid];
        self.horizontal0 = [self creatGrid];
        self.horizontal1 = [self creatGrid];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineW = self.lineWidth;
    self.horizontal0.frame = CGRectMake(0, self.frame.size.width / 3 - lineW / 2, self.frame.size.width, lineW);
    self.horizontal1.frame = CGRectMake(0, self.frame.size.width / 3 * 2 - lineW / 2,self.frame.size.width, lineW);
    self.vertical0.frame = CGRectMake(self.frame.size.height / 3 - lineW / 2, 0, lineW, self.frame.size.height);
    self.vertical1.frame = CGRectMake(self.frame.size.height / 3 * 2 - lineW / 2, 0, lineW, self.frame.size.height);
}

#pragma mark - pravite
- (UIView *)creatGrid {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.lineColor;
    [self addSubview:view];
    return view;
}

#pragma mark - setter

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    _vertical0.backgroundColor = lineColor;
    _vertical1.backgroundColor = lineColor;
    _horizontal0.backgroundColor = lineColor;
    _horizontal1.backgroundColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsLayout];
}
@end
