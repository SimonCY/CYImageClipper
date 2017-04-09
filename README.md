# CYImageClipper（初版）

图片裁剪自定义选择框(暂时只支持缩放手势和正方形)

加了自动边缘识别和自适应

![这里写图片描述](https://github.com/SimonCY/CYImageClipper/raw/master/shortCut/shortCut.gif) 

------------------------------------------------------
## 使用

裁剪图片的ImageView直接使用，设置inputImage即可

1
```objc
    //selectedView
    CGFloat margin = 20;

    CGFloat selectViewX = margin;
    CGFloat selectViewY = 20 + margin;
    CGFloat selectViewWH = cy_SCREEN_WIDTH - margin * 2;
    CGRect  selectViewF = CGRectMake(selectViewX, selectViewY, selectViewWH, selectViewWH);
    CGRect  defaultSelectF = CGRectMake(0, 0, selectViewWH, selectViewWH);

    self.selectView = [CYClipperView selectViewWithDefaultSelectedRect:defaultSelectF inputImage:self.inputImage];
    self.selectView.frame = selectViewF;
    //可以重复设置
    self.selectView.selectRect = CGRectMake(0, 1, 100, 100);

    [self.view addSubview:self.selectView];
```

2.裁剪图片
```objc
    //可以直接使用这个方法裁剪当前图片
    self.output.image = [self.selectView clipInputImage];

    /** 如需裁剪多张图片，可以配合originalRect属性和附赠的裁剪方法自行裁剪
    @property (assign,nonatomic,readonly) CGRect originalRect;
    - (UIImage *)cutImage:(UIImage *)inputImage forRect:(CGRect)usebleRect;
    */

```
##编者注：

如果觉得好用，请右上角star,欢迎提出宝贵建议，谢谢！
