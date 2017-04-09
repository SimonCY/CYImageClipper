# CYImageClipper
图片裁剪自定义选择框(暂时只支持缩放手势和正方形)
![这里写图片描述](https://github.com/SimonCY/CYImageClipper/raw/master/shortCut/shortCut.GIF) 
------------------------------------------------------
##使用

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
##编者注：
如果觉得好用，请右上角sta
