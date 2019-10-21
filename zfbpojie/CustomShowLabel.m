//
//  CustomShowLabel.m
//  eSynchrony
//
//  Created by ESYNSZ-Limit on 2016/10/31.
//  Copyright © 2016年 eysnChrony. All rights reserved.
//

#import "CustomShowLabel.h"

@implementation CustomShowLabel

+ (CustomShowLabel *)shareShowLabel{

    static CustomShowLabel * showLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showLabel = [[CustomShowLabel alloc] init];
    });
    
    return showLabel;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16];
    }
    
    return self;
}

- (void)setText:(NSString *)text position:(int)position{

    [super setText:text];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, [self getLableMessageSizeWidth: text font:[UIFont systemFontOfSize:24]], [self getLableMessageSizeHeight:text font:[UIFont systemFontOfSize:20]]);
    
    if (position == 1){
        self.center = CGPointMake(320/2, 568/2);
    }else if (position == -1){
        self.center = CGPointMake(320/2, 140);
    }else{
        self.center = CGPointMake(320/2, 568-70);
    }
    
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeSelf:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeSelf:(NSTimer *)timer{

    [self removeFromSuperview];
    [self.timer invalidate];
}

#pragma mark float计算文字长度
- (CGFloat) getLableMessageSizeWidth:(NSString *) strMsg font:(UIFont*)font
{
    CGSize size = CGSizeMake(320,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size =[strMsg boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
           |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    //根据计算结果重新设置UILabel的尺寸
    return size.width;
}

#pragma mark float计算文字高度
- (CGFloat) getLableMessageSizeHeight:(NSString *) strMsg font:(UIFont*)font
{
    CGSize size = CGSizeMake(260,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size =[strMsg boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
           |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    //根据计算结果重新设置UILabel的尺寸
    return size.height;
}
@end
