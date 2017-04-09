//
//  ViewController.m
//  CYImageClipper
//
//  Created by Chenyan on 2017/4/9.
//  Copyright © 2017年 chenyan. All rights reserved.
//

#import "ViewController.h"
#import "iPhoneMacro.h"
#import "CYClipperView.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)imageBtnClicked:(UIButton *)sender;
- (IBAction)cutBtnClicked:(UIButton *)sender;

@property (nonatomic,strong) CYClipperView* selectView;

@property (weak, nonatomic) IBOutlet UIImageView *output;

@property (strong,nonatomic) UIImage *inputImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}

#pragma mark - setter
- (void)setInputImage:(UIImage *)inputImage {
    _inputImage = inputImage;

    self.selectView.inputImage = inputImage;
}

#pragma mark - btnEvents

- (IBAction)imageBtnClicked:(UIButton *)sender {

    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)cutBtnClicked:(UIButton *)sender {

    CYLog(@"cut rect is %@",[NSValue valueWithCGRect:self.selectView.originalRect]);

    self.output.image = [self.selectView clipInputImage];
}

#pragma mark - pickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    CYLog(@"info is :\n%@",info);
    self.inputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
