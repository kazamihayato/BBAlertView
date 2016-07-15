//
//  BBAlertView.m
//  BBAlerViewDemo
//
//  Created by 优车享 on 16/3/9.
//  Copyright © 2016年 youchexiang. All rights reserved.
//

#import "BBAlertView.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

#define SCREEN_WIDTH                 [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                [[UIScreen mainScreen] bounds].size.height
#define AlertViewTitles     [NSArray arrayWithObjects:@"取消",@"确定",nil]
#define Text_DarkGray_Color [UIColor colorWithWhite:0.322 alpha:1.000]
#define SuccessColor        [UIColor colorWithRed:47/255.0f green:204/255.0f blue:112/255.0f alpha:1]
#define FailColor           [UIColor colorWithRed:232/255.0f green:78/255.0f blue:60/255.0f alpha:1]
#define WaringColor         [UIColor colorWithRed:230.0f/255.0f green:95.0f/255.0f blue:7.0f/255.0f alpha:1]

#define AlertWidth      270.0f
#define AlertGap        10.0f
#define BtnViewHeight   55.0f
#define BtnWidth        110.0f
#define BtnHeight       28.0f
#define TapWidth        250.0f
#define NoticeWidth     180.0f

static const CGFloat waringHeight       =64.0f;

/**
 *  垂直掉落提示框
 */
#pragma mark-垂直掉落提示框
@implementation BBNoticeView
{
    dispatch_block_t _disappearBlock;
    UIDynamicAnimator * _animator;
}
-(instancetype)initNoticeViewWithNoticeType:(NoticeType)noticeType
                                       info:(NSString*)info
                             disappearBlock:(dispatch_block_t)disappearBlock
{
    self=[super init];
    if (self) {
        _disappearBlock=disappearBlock;
        switch (noticeType) {
            case Success:
            {
                self.state     = [NSString fontAwesomeIconStringForEnum:FACheckCircle];
                self.infoColor = SuccessColor;
            }
                break;
            case Fail:
            {
                self.state     = [NSString fontAwesomeIconStringForEnum:FATimesCircle];
                self.infoColor = FailColor;
            }
                break;
            default:
                break;
        }
        [self createBgView];
        [self createContentView];
        [self createNoticeViewWithMessage:info];
    }
    return self;
    
}
-(void)createNoticeViewWithMessage:(NSString*)message
{
    //title
    CGFloat titleHeight  =[self createTitle];
    
    //信息
    CGFloat messageHeight=[self createMessageWith:message titlePart:titleHeight];
    
    //按钮栏
    CGFloat btnView      =[self createBtnView:messageHeight];
    
    //设置alert最终高度
    self.contentView.frame   =CGRectMake((SCREEN_WIDTH-NoticeWidth)/2, (SCREEN_HEIGHT-btnView)/2, NoticeWidth, btnView);
}
-(CGFloat)createTitle
{
    self.titleLabel                =[[UILabel alloc] initWithFrame:CGRectMake((NoticeWidth-35)/2, AlertGap,35,35)];
    self.titleLabel.backgroundColor= [UIColor clearColor];
    [self.titleLabel setTextColor:self.infoColor];
    self.titleLabel.font           = [UIFont fontAwesomeFontOfSize:40];
    self.titleLabel.textAlignment  = NSTextAlignmentCenter;
    self.titleLabel.text           = self.state;
    [self.contentView addSubview:self.titleLabel];
    
    return CGRectGetMaxY(self.titleLabel.frame);
}

-(CGFloat)createMessageWith:(NSString*)message titlePart:(CGFloat)titleHight
{
    CGFloat messageHeight           = [self heightWithString:message fontSize:14 width:NoticeWidth-2*AlertGap];
    self.messageLabel               = [[UILabel alloc] initWithFrame:CGRectMake(AlertGap, titleHight+AlertGap, NoticeWidth-2*AlertGap, messageHeight)];
    self.messageLabel.font          = [UIFont boldSystemFontOfSize:14];
    self.messageLabel.textColor     = [UIColor grayColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.text          = message;
    self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.messageLabel];
    
    return CGRectGetMaxY(self.messageLabel.frame);
}
-(CGFloat)createBtnView:(CGFloat)messageHeight
{
    UIView*btnView      = [[UIView alloc] initWithFrame:CGRectMake(0, messageHeight, NoticeWidth, BtnViewHeight)];
    [self.contentView addSubview:btnView];
    
    CGFloat sheetHeight = [self heightWithString:@"点击以关闭" fontSize:12 width:TapWidth];
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake((NoticeWidth-TapWidth)/2, AlertGap,TapWidth, sheetHeight)];
    label.text          = @"点击以关闭";
    label.textColor     = [UIColor grayColor];
    label.font          = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:label];
    btnView.frame       = CGRectMake(0, messageHeight, AlertWidth, CGRectGetMaxY(label.frame)+AlertGap/2);
    
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.contentView addGestureRecognizer:tap];
    
    return CGRectGetMaxY(btnView.frame);
}
-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0.5;
    }];
    [self addToWindow];
    
    self.contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) - self.contentView.frame.size.height);
    _animator               = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.contentView]];
    
    [_animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *groundCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.contentView]];
    [groundCollisionBehavior addBoundaryWithIdentifier:@"floor"
                                             fromPoint:CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame)+self.contentView.frame.size.height/2)
                                               toPoint:CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame)+self.contentView.frame.size.height/2)];
    [_animator addBehavior:groundCollisionBehavior];
    
//    UIPushBehavior *pushBehavior             = [[UIPushBehavior alloc] initWithItems:@[self.contentView] mode:UIPushBehaviorModeInstantaneous];
//    pushBehavior.pushDirection               = CGVectorMake(0,15);
//    pushBehavior.active                      = YES;
//    
//    [_animator addBehavior:pushBehavior];
    
    UIDynamicItemBehavior *alertViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    alertViewBehavior.elasticity             = 0.1;
    CGFloat angularVelocity                  = (((float)rand() / RAND_MAX)-0.5)*0.4;
    [alertViewBehavior addAngularVelocity:angularVelocity forItem:self.contentView];
    [_animator addBehavior:alertViewBehavior];
}
-(void)dismiss
{
    for (id behavior in [_animator behaviors]) {
        if ([behavior isKindOfClass:[UICollisionBehavior class]]){
            [_animator removeBehavior:behavior];
        }
    }
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    if (_disappearBlock)
    {
        _disappearBlock();
    }
}
-(void)dealloc
{
    _disappearBlock=nil;
}
@end

/**
 *  顶部条形提示框
 */
#pragma mark-顶部条形提示框
@implementation BBTopView

-(instancetype)initTopViewWithNoticeType:(NoticeType)noticeType
                              noticeInfo:(NSString *)noticeInfo
{
    self=[super init];
    if (self) {
       
        switch (noticeType) {
            case Success:
            {
                self.state     = [NSString fontAwesomeIconStringForEnum:FACheckCircle];
                self.infoColor = SuccessColor;
                
            }
                break;
            case Fail:
            {
                self.state     = [NSString fontAwesomeIconStringForEnum:FATimesCircle];
                self.infoColor = FailColor;
            }
                break;
            case Warning:
            {
                self.state     = [NSString fontAwesomeIconStringForEnum:FAExclamationCircle];
                self.infoColor = WaringColor;
            }
                break;
            default:
                break;
        }
        [self createTopViewWithNoticeInfo:noticeInfo];
        
    }
    return self;
}
-(void)createTopViewWithNoticeInfo:(NSString *)noticeInfo

{
    self.frame                      = CGRectMake(0, -waringHeight, SCREEN_WIDTH,waringHeight);
    self.backgroundColor            = self.infoColor;
    self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(2*AlertGap, 4, waringHeight-30, waringHeight)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor       = [UIColor whiteColor];
    self.titleLabel.textAlignment   = NSTextAlignmentCenter;
    self.titleLabel.font            = [UIFont fontAwesomeFontOfSize:40];
    self.titleLabel.text            = self.state;
    self.titleLabel.layer.opacity   = 0;
    
    [self addSubview:self.titleLabel];
    
    CGFloat infoHeight              = [self heightWithString:noticeInfo fontSize:15 width:AlertWidth];
    self.messageLabel               = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), (waringHeight-infoHeight)/2+5, SCREEN_WIDTH-CGRectGetMaxX(self.titleLabel.frame)*2, infoHeight)];
    self.messageLabel.text          = noticeInfo;
    self.messageLabel.textColor     = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font          = [UIFont boldSystemFontOfSize:15];
    
    [self addSubview:self.messageLabel];
}
-(void)show
{
    [self addToWindow];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.frame                    =    CGRectMake(0, 0, SCREEN_WIDTH,waringHeight);
        
    } completion:^(BOOL finished) {
        
        self.titleLabel.layer.opacity = 1;
        self.titleLabel.transform     = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.titleLabel.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.5];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.center=CGPointMake(CGRectGetMidX(self.frame), self.frame.origin.y-waringHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

/**
 *  对话提示框
 */
@implementation BBDialogueView
{
    dispatch_block_t _confirmBlock;
}
-(instancetype)initDialogueWithTitle:(NSString *)title
                             message:(NSString *)message
                        confirmBlock:(dispatch_block_t)confirmBlock
{
    self=[super init];
    if (self) {
        _confirmBlock=confirmBlock;
        
        [self createBgView];
        [self createContentView];
        [self createDialogueViewWithTitle:title message:message];
    }
    return self;
}
-(void)createDialogueViewWithTitle:(NSString*)title message:(NSString*)message
{
    //title
    CGFloat titleHeight    = [self createTitleWith:title];
    
    //信息
    CGFloat messageHeight  = [self createMessageWith:message titlePart:titleHeight];
    
    //按钮栏
    CGFloat btnView        = [self createBtnView:messageHeight];
    
    //设置alert最终高度
    self.contentView.frame = CGRectMake((SCREEN_WIDTH-AlertWidth)/2, (SCREEN_HEIGHT-btnView)/2, AlertWidth, btnView);
}
-(CGFloat)createTitleWith:(NSString*)title
{
    CGFloat height                  = [self heightWithString:title fontSize:17 width:AlertWidth-2*AlertGap];
    self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(AlertGap, AlertGap,AlertWidth-2*AlertGap,height)];
    self.titleLabel.text            = title;
    self.titleLabel.textColor       = Text_DarkGray_Color;
    self.titleLabel.font            = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment   = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.titleLabel];
    
    return CGRectGetMaxY(self.titleLabel.frame);
    
}
-(CGFloat)createMessageWith:(NSString*)message titlePart:(CGFloat)titleHeight
{
    CGFloat height                  = [self heightWithString:message fontSize:14 width:AlertWidth-2*AlertGap];
    self.messageLabel               = [[UILabel alloc] initWithFrame:CGRectMake(AlertGap, height+AlertGap+titleHeight, AlertWidth-2*AlertGap, height)];
    self.messageLabel.text          = message;
    self.messageLabel.textColor     = [UIColor grayColor];
    self.messageLabel.font          = [UIFont systemFontOfSize:14];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.messageLabel];
    
    return CGRectGetMaxY(self.messageLabel.frame);
    
}
-(CGFloat)createBtnView:(CGFloat)messageHeight
{
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, messageHeight+10, AlertWidth, BtnViewHeight)];
    [self.contentView addSubview:btnView];
    
    CGFloat x=(AlertWidth/2-BtnWidth)/2;
    for (int i=0; i<2; i++) {
        
        UIButton*btn          = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame             = CGRectMake(x*(2*i+1)+BtnWidth*i, AlertGap, BtnWidth, BtnHeight);
        btn.tag               = 221+i;
        btn.layer.borderColor = [UIColor blueColor].CGColor;
        btn.layer.borderWidth = 0.5f;
        btn.titleLabel.font   = [UIFont systemFontOfSize:15];
        
        [btn setTitle :AlertViewTitles[i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:btn];
    }
    return CGRectGetMaxY(btnView.frame);
}
-(void)btnPressed:(UIButton*)btn
{
    switch (btn.tag-221) {
        case 0:
        {
            [self dismiss];
        }
            break;
        case 1:
        {
            if (_confirmBlock) {
                _confirmBlock();
            }
            [self dismiss];
        }
            break;
        default:
            break;
    }
}

-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.5;
    }];
    
    [self addToWindow];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.contentView layer] addAnimation:popAnimation forKey:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.center = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+40);
        self.bgView.alpha       = 0.0;
        self.contentView.alpha  = 0.0;
        
    } completion:^(BOOL finished){
        
         [self removeFromSuperview];
        
     }];
}
-(void)dealloc
{
    _confirmBlock=nil;
}
@end

@implementation BBAlertView

-(void)createContentView
{
    self.contentView                     = [[UIView alloc]init];
    self.contentView.layer.cornerRadius  = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor     = [UIColor whiteColor];
    [self addSubview:self.contentView];
}

-(void)createBgView
{
    self.frame                  = [UIScreen mainScreen].bounds;
    self.bgView                 = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha           = 0.0f;
    [self addSubview:self.bgView];
}

-(void) addToWindow
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

//计算文字高度 传入字体号与宽度
-(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

+(void)showDialogueWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(dispatch_block_t)confirmBlock
{
    BBDialogueView*dialogue=[[BBDialogueView alloc] initDialogueWithTitle:title message:message confirmBlock:confirmBlock];
    [dialogue show];
}

+(void)showTopSuccess:(NSString *)successInfo
{
    BBTopView*topView=[[BBTopView alloc] initTopViewWithNoticeType:Success noticeInfo:successInfo];
    [topView show];
}

+(void)showTopFailed:(NSString *)failedInfo
{
    BBTopView*topView=[[BBTopView alloc] initTopViewWithNoticeType:Fail noticeInfo:failedInfo];
    [topView show];
}

+(void)showTopWarning:(NSString *)warningInfo
{
    BBTopView*topView=[[BBTopView alloc] initTopViewWithNoticeType:Warning noticeInfo:warningInfo];
    [topView show];
}

+(void)showSuccessNotice:(NSString*)successInfo
          disappearBlock:(dispatch_block_t)disappearBlock
{
    BBNoticeView*successNotice=[[BBNoticeView alloc] initNoticeViewWithNoticeType:Success info:Success disappearBlock:disappearBlock];
    [successNotice show];
}

+(void)showFailedNotice:(NSString *)failInfo
         disappearBlock:(dispatch_block_t)disappearBlock
{
    BBNoticeView*failNotice=[[BBNoticeView alloc] initNoticeViewWithNoticeType:Fail info:failInfo disappearBlock:disappearBlock];
    [failNotice show];
}
@end
