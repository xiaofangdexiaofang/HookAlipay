//
//  CustomShowLabel.h
//  eSynchrony
//
//  Created by ESYNSZ-Limit on 2016/10/31.
//  Copyright © 2016年 eysnChrony. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 黑色背景  白色文字的  提醒视图
 
 */
@interface CustomShowLabel : UILabel

+ (CustomShowLabel *)shareShowLabel;


/*
 @param  text   文字
 @param  position   如果是1 在屏幕中间显示  如果是0  在屏幕下方显示
 */
- (void)setText:(NSString *)text position:(int)position;

/*
 
 计时器  该视图在 1秒后消失
 */

@property (nonatomic,strong) NSTimer * timer;

@end
