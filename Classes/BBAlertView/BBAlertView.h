//
//  BBAlertView.h
//  BBAlerViewDemo
//
//  Created by 优车享 on 16/3/9.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Success,
    Fail,
    Warning
}NoticeType;


@interface BBAlertView : UIView

@property(nonatomic,strong)UIView   * bgView;
@property(nonatomic,strong)UIView   * contentView;
@property(nonatomic,strong)UILabel  * titleLabel;
@property(nonatomic,strong)UILabel  * messageLabel;
@property(nonatomic,strong)NSString * state;
@property(nonatomic,strong)UIColor  * infoColor;

+(void) showDialogueWithTitle:(NSString*)title
                     message:(NSString*)message
                confirmBlock:(dispatch_block_t)confirmBlock;

+(void) showTopSuccess:(NSString*)successInfo;

+(void) showTopFailed:(NSString*)failedInfo;

+(void) showTopWarning:(NSString*)warningInfo;

+(void) showSuccessNotice:(NSString*)successInfo
          disappearBlock:(dispatch_block_t)disappearBlock;

+(void) showFailedNotice:(NSString*)failInfo
         disappearBlock:(dispatch_block_t)disappearBlock;

-(void)addToWindow;
-(void)show;
-(void)dismiss;
-(void)createBgView;
-(void)createContentView;

-(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width;


@end


@interface BBTopView : BBAlertView

@end


@interface BBNoticeView : BBAlertView

@end

@interface BBDialogueView : BBAlertView

@end
