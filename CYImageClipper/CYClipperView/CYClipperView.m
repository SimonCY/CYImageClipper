//
//  CYEditCutSelectView.m
//  LightBox
//
//  Created by RRTY on 17/4/8.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import "CYClipperView.h"
#import "CYClipperGridView.h"
#import "UIImage+CYExtension.h"

// Debug Log
#ifdef DEBUG
#define CYLog(...) NSLog(__VA_ARGS__)
#else
#define CYLog(...)
#endif

@interface CYClipperView ()
@property (nonatomic,strong) CYClipperGridView* gridView;
//后期想扩展手势的功能  所以四个顶点暂时放在这里
@property (nonatomic,strong) UIView* LTBtn;
@property (nonatomic,strong) UIView* LBBtn;
@property (nonatomic,strong) UIView* RTBtn;
@property (nonatomic,strong) UIView* RBBtn;

//内部使用_中间变量
@property (nonatomic,assign) CGPoint lastPoint;
@property (nonatomic,assign) CGFloat lastWH;

@end

#define pointWH 20
#define borderW 5

@implementation CYClipperView

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {

    [self.inputImage drawInRect:self.bounds];

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    UIBezierPath *path0 = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor colorWithWhite:200/255.0 alpha:0.7] setFill];
    [path0 fill];

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:self.selectRect];
    [[UIColor clearColor] setFill];
    [path1 fillWithBlendMode:kCGBlendModeClear alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [newImage drawInRect:self.bounds];
}

#pragma mark - init
+ (instancetype)selectViewWithDefaultSelectedRect:(CGRect)selectRect inputImage:(UIImage *)image {
    CYClipperView *selectedView = [[CYClipperView alloc] init];
    selectedView.selectRect = selectRect;
    if (image == nil) {
        image = [UIImage createImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, 1)];
    }
    selectedView.inputImage = image;
    return selectedView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        //gridView
        self.gridView = [[CYClipperGridView alloc] init];
        self.gridView.lineColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        self.gridView.lineWidth = 3;
        self.gridView.layer.borderColor = self.gridView.lineColor.CGColor;
        self.gridView.layer.borderWidth = borderW;
        [self addSubview:self.gridView];
        
        //four Points
        self.LTBtn = [self addPointBtn];
        self.LBBtn = [self addPointBtn];
        self.RTBtn = [self addPointBtn];
        self.RBBtn = [self addPointBtn];
        
        //defultSetting
        self.selectRect = CGRectZero;
        
        //panGesture
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        pan.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gridView.frame = self.selectRect;
    
    self.LTBtn.center = CGPointMake(self.gridView.frame.origin.x + borderW / 2, self.gridView.frame.origin.y + borderW / 2);
    self.LBBtn.center = CGPointMake(self.gridView.frame.origin.x + borderW / 2, CGRectGetMaxY(self.gridView.frame) - borderW / 2);
    self.RTBtn.center = CGPointMake(CGRectGetMaxX(self.gridView.frame) - borderW / 2, self.gridView.frame.origin.y + borderW / 2);
    self.RBBtn.center = CGPointMake(CGRectGetMaxX(self.gridView.frame) - borderW / 2, CGRectGetMaxY(self.gridView.frame) - borderW / 2);
    
}

#pragma mark - setter
- (void)setInputImage:(UIImage *)inputImage {
    _inputImage = inputImage;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSelectRect:(CGRect)selectRect {

    _selectRect = selectRect;
    [self setNeedsLayout];
    [self setNeedsDisplay];

    //根据比例计算图片裁剪真实数据
    CGFloat originalX = selectRect.origin.x / self.bounds.size.width * self.inputImage.size.width;
    CGFloat originalY = selectRect.origin.y / self.bounds.size.height * self.inputImage.size.height;
    CGFloat originalW = selectRect.size.width / self.bounds.size.width * self.inputImage.size.width;
    CGFloat originalH = selectRect.size.height / self.bounds.size.height * self.inputImage.size.height;

    _originalRect = CGRectMake(originalX, originalY, originalW,originalH);
}

#pragma mark - public
- (UIImage *)clipInputImage {
    return [self cutImage:self.inputImage forRect:self.originalRect];
}

#pragma mark - pravite
- (UIImage *)cutImage:(UIImage *)inputImage forRect:(CGRect)usebleRect {
    // CGImageCreateWithImageInRect只认像素
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat newX = usebleRect.origin.x ;
    CGFloat newY = usebleRect.origin.y ;
    CGFloat newW = usebleRect.size.width ;
    CGFloat newH = usebleRect.size.height ;

    CYLog(@"imageSize is %@",[NSValue valueWithCGSize:inputImage.size]);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(inputImage.CGImage, CGRectMake(newX,newY, newW , newH));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CYLog(@"newImage size is %@ ,scale is %f",[NSValue valueWithCGSize:newImage.size],scale);

    if (newImage == nil) {
        CYLog(@"裁图失败");
    }
    return newImage;
}

- (UIView *)addPointBtn {

    UIView *btn = [[UIView alloc] init];
    btn.layer.cornerRadius = pointWH / 2;
    btn.clipsToBounds = YES;
    btn.backgroundColor = self.gridView.lineColor;
    [self addSubview:btn];
    btn.frame = CGRectMake(0, 0, pointWH, pointWH);
    return btn;
}

#pragma mark - gestureEvent
- (void)pinchEvent:(UIPinchGestureRecognizer *)pinch {

    CGFloat scale = pinch.scale;
    CGFloat selectX = self.selectRect.origin.x;
    CGFloat selectY = self.selectRect.origin.y;
    CGFloat selectWH;

    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
            _lastWH = self.selectRect.size.width;
            break;
            
        case UIGestureRecognizerStateChanged:
            selectWH = _lastWH * scale;
            selectX += (self.selectRect.size.width - selectWH) / 2;
            selectY += (self.selectRect.size.width - selectWH) / 2;

            if (selectWH < self.bounds.size.width * 0.5) {
                selectWH = self.bounds.size.width * 0.5;
                return;
            }
            
            if (selectWH > self.bounds.size.width) {
                selectWH = self.bounds.size.width;
            }
            
            if (selectX + selectWH > self.bounds.size.width) {
                selectX = self.bounds.size.width - selectWH;
            }
            if (selectY + selectWH > self.bounds.size.width) {
                selectY = self.bounds.size.width - selectWH;
            }
            
            if (selectX < 0) {
                selectX = 0;
                
            }
            if (selectY < 0) {
                selectY = 0;
            }
            
            self.selectRect = CGRectMake(selectX, selectY, selectWH, selectWH);
            break;
        default:
            break;
    }
}
- (void)panEvent:(UIPanGestureRecognizer *)pan {
    
    CGPoint translation = CGPointZero;
    CGFloat selectX = self.selectRect.origin.x;
    CGFloat selectY = self.selectRect.origin.y;
    CGFloat selectWH = self.selectRect.size.width;
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            _lastPoint = [pan locationInView:self];
            break;
        }

        case UIGestureRecognizerStateChanged: {
            
            translation = CGPointMake([pan locationInView:self].x - _lastPoint.x, [pan locationInView:self].y - _lastPoint.y);
            
            selectX += translation.x;
            selectY += translation.y;
            
            if (selectX < 0) {
                selectX = 0;
                
            }
            if (selectY < 0) {
                selectY = 0;
            }
            
            if (selectX + selectWH > self.bounds.size.width) {
                selectX = self.bounds.size.width - selectWH;
            }
            if (selectY + selectWH > self.bounds.size.width) {
                selectY = self.bounds.size.width - selectWH;
            }
            
            self.selectRect = CGRectMake(selectX, selectY, selectWH, selectWH);
            _lastPoint = [pan locationInView:self];
            break;
        }
        default:
            break;
    }
}

@end
