//
//  ViewController.m
//  BBAlerViewDemo
//
//  Created by 优车享 on 16/3/9.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import "ViewController.h"
#import "BBAlertView.h"
#import "BBButton.h"
#import "UIView+Category.h"

#define ShowBtnTitles     [NSArray arrayWithObjects:@"对话框",@"顶部成功",@"顶部失败",@"顶部警告",@"掉落成功",@"掉落失败",nil]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ShowBtnTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BBButton*btn=[[BBButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250*displayScale)/2, 30*(idx+1)+30*displayScale*idx, 250*displayScale, 30*displayScale)];
        btn.bgColor=[UIColor colorWithRed:18.0f/255.0f green:120.0f/255.0f blue:236.0f/255.0f alpha:1];
        btn.buttonStyle=ButtonStyleBorder;
        
        [btn setTitle:(NSString*)obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+idx;
        [self.view addSubview:btn];
    }];
}
-(void)btnPressed:(UIButton*)btn
{
    switch (btn.tag-100) {
        case 0:
        {
            [BBAlertView showDialogueWithTitle:@"提示" message:@"您确定要退出吗？" confirmBlock:^{
                NSLog(@"已退出");
            }];
        }
            break;
        case 1:
        {
            //在info.plist需要添加字体:FontAwesome.ttf
            [BBAlertView showTopSuccess:@"成功"];
        }
            break;
        case 2:
        {
            [BBAlertView showTopFailed:@"失败"];
        }
            break;
        case 3:
        {
            [BBAlertView showTopWarning:@"警告"];
        }
            break;
        case 4:
        {
            [BBAlertView showSuccessNotice:@"成功" disappearBlock:^{
                NSLog(@"已成功");
            }];
        }
            break;
        case 5:
        {
            [BBAlertView showFailedNotice:@"失败" disappearBlock:^{
                NSLog(@"已失败");
            }];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
