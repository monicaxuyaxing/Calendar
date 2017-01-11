//
//  CollectionCell.m
//  日历学习
//
//  Created by fly on 16/8/11.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "CollectionCell.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation CollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kWidth - 26)/7,26)];
        self.bgView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.bgView];

        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(((kWidth - 26)/7 - 20)/2, 3, 20, 20)];
        self.lable.textAlignment  = NSTextAlignmentCenter;
        self.lable.font = [UIFont systemFontOfSize:12];
        self.lable.layer.masksToBounds = YES;
        self.lable.layer.cornerRadius = 10;
        [self addSubview:self.lable];


    }
    return self;
}
@end
