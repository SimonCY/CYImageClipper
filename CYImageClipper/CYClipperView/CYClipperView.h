//
//  CYEditCutSelectView.h
//  LightBox
//
//  Created by RRTY on 17/4/8.
//  Copyright © 2017年 deepAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYClipperView : UIView

@property (nonatomic,strong) UIImage* inputImage;

/** 注意此处的selctRect获取到的仅仅是相对于控件的Rect，图片裁剪时需要确定的是图片的真实宽高 */
@property (nonatomic,assign) CGRect selectRect;

/** 裁剪图片的真实尺寸数据 */
@property (assign,nonatomic,readonly) CGRect originalRect;

+ (instancetype)selectViewWithDefaultSelectedRect:(CGRect)selectRect inputImage:(UIImage *)image;

/** 内部根据已获得的尺寸信息自动裁剪当前inputImage,如需裁剪多张图片可以用originalRect自行裁剪,末尾附赠裁剪图片的方法 */
- (UIImage *)clipInputImage;
- (UIImage *)cutImage:(UIImage *)inputImage forRect:(CGRect)usebleRect;
@end
