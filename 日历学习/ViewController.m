//
//  ViewController.m
//  日历学习
//
//  Created by fly on 16/8/10.
//  Copyright © 2016年 fly. All rights reserved.
//

#import "ViewController.h"
#import "CollectionCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kDay 24*60*60

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *numberCellArray; // cell的个数
@property (nonatomic, strong) NSMutableArray *selectedCellColorMArray; // 储存选中cell的的颜色
@property (nonatomic, strong) NSString *dateStr; // 今天的日期
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, strong) UIView *view1;

@end

@implementation ViewController{
    UILabel *headlabel;

}


-(NSMutableArray *)numberCellArray
{
    if (!_numberCellArray)
    {
        _numberCellArray = [[NSMutableArray array]init];
    }
    return _numberCellArray;
}


-(NSMutableArray *)selectedCellColorMArray{
    
    if (!_selectedCellColorMArray) {
        
        _selectedCellColorMArray = [[NSMutableArray alloc]init];
    }
    return _selectedCellColorMArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createCollectionView];
    [self createCellNumber:[NSDate date]];
    _year = [self year:[NSDate date]];
    _month = [self month:[NSDate date]];
    _day = 0;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-M"];
    _dateStr = [formatter stringFromDate:date];


    headlabel = [[UILabel alloc] init];
    headlabel.text   = [NSString stringWithFormat:@"%ld年%02ld月",_year,_month];;
    headlabel.font   = [UIFont systemFontOfSize:14];
    headlabel.textColor = [UIColor blueColor];
    headlabel.frame = CGRectMake(0, 191, self.collectionView.frame.size.width, 38/2);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    headlabel.userInteractionEnabled = YES;
    [self.view addSubview:headlabel];



    //2.1 上月下月按钮
    //创建左右按钮 选择月份
    NSArray * arraytitle = @[@"上月",@"下月"];
    for (int i = 0; i < 2; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.collectionView. frame.size.width - 60)*i, 0, 60, 38/2);
        [headlabel addSubview:btn];
        btn.tag = 20 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitle:arraytitle[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [headlabel addSubview:btn];
    }

    NSArray *array = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor yellowColor];
    weekBg.frame = CGRectMake(13, 220, kWidth - 26, 52/2);
    [self.view addSubview:weekBg];

    CGFloat itemW = (kWidth - 26) / 7;

    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.textColor = [UIColor blackColor];
        week.frame    = CGRectMake(itemW * i-1, 0, itemW, 52/2);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        [weekBg addSubview:week];
    }

    for (int i = 1; i < 7; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame    = CGRectMake(itemW * i-1, 6, 1, 30/2);
        lineView.backgroundColor = [UIColor blackColor];
        [weekBg addSubview:lineView];
    }

}


// 集合视图的创建
- (void)createCollectionView
{
    UICollectionViewFlowLayout *viewFL = [[UICollectionViewFlowLayout alloc]init];
    viewFL.itemSize = CGSizeMake((kWidth-26)/7, 52/2);
    viewFL.minimumLineSpacing = 0;
    viewFL.minimumInteritemSpacing = 0;
    viewFL.sectionInset = UIEdgeInsetsMake(0,0, 0,0);
    
    self.automaticallyAdjustsScrollViewInsets=false;
     _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(13, 246, kWidth - 26, 156) collectionViewLayout:viewFL];

    [_collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"item"];
    _collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
}
#pragma mark ---左右按钮的点击方法
- (void)lastMonth
{
    _month = _month - 1;
    _day = _day - 1;
    if (_month == 0)
    {
        _month = 12;
        _year = _year - 1;
    }
    headlabel.text   = [NSString stringWithFormat:@"%ld年%02ld月",_year,_month];;
    NSDate *lastDate = [[NSDate date] dateByAddingTimeInterval:_day*kDay * [self totaldaysInMonth:[NSDate date]]];
    [self createCellNumber:lastDate];
    [_collectionView reloadData];
}
- (void)nextMonth
{
    _month = _month + 1;
    _day = _day + 1;
    if (_month == 13)
    {
        _month = 1;
        _year = _year + 1;
    }
    headlabel.text = [NSString stringWithFormat:@"%ld年%02ld月",_year,_month];;

    NSDate *nextDate = [[NSDate date] dateByAddingTimeInterval:_day*kDay * [self totaldaysInMonth:[NSDate date]]];
    [self createCellNumber:nextDate];
    [_collectionView reloadData];
}


#pragma mark UICollectionView的代理方法
//分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回分区下，单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberCellArray.count;
}



-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 20) {
        NSLog(@"上");
        [self lastMonth];
    }else{
        NSLog(@"下");
        [self nextMonth];
    }
}



//cell的编辑,定义item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    从重用队列中取出注册的cell
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[CollectionCell alloc]init];
    }
    cell.lable.backgroundColor = [UIColor orangeColor];
    cell.lable.text = self.numberCellArray[indexPath.row];
    cell.bgView.backgroundColor = [UIColor blueColor];
    // 今天是否等于对应的日期
    if ([[NSString stringWithFormat:@"%ld-%ld",_year,_month] isEqualToString:_dateStr])
    {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];

        if ([self day:yesterday] == [self.numberCellArray[indexPath.row] integerValue])
        {
            cell.lable.backgroundColor = [UIColor redColor];
        }

    }

    return cell;
}


//每个cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kWidth - 26)/7, 52/2);
}



// 点击cell的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.selectedCellColorMArray removeAllObjects];
    for (int i = 0; i < self.numberCellArray.count; i++) {
        
        if (i == indexPath.row) {
            
            [self.selectedCellColorMArray addObject:@"1"];
        }else{
            
            [self.selectedCellColorMArray addObject:@"0"];
        }
    }
    [collectionView reloadData];
}
#pragma mark --- 本类调用 ---
// 要创建的cell的个数
- (void)createCellNumber:(NSDate *)date
{
    [self.numberCellArray removeAllObjects];
    NSInteger days = [self totaldaysInMonth:date];
    NSDate *date1 = [date dateByAddingTimeInterval:-([self day:date] - 1)*kDay];
    NSInteger severalDayOfWeek = [self severalWeeks:date1];
    for (int i = 0; i < severalDayOfWeek - 1; i++)
    {
        [self.numberCellArray addObject:@""];
    }
    for (int i = 0; i < days; i++)
    {
        [self.numberCellArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    NSInteger num = severalDayOfWeek + days - 1;
    NSInteger rowNum;
    if (num%7) {
        rowNum = num/7 + 1;
        NSLog(@"%ld",rowNum );
    }else{
        rowNum = num/7;
    }

    if (rowNum == 5) {
//        _collectionView.frame = CGRectMake(0, 247, kWidth, 130);


    }else if (rowNum == 6) {
//        _collectionView.frame = CGRectMake(0, 247, kWidth, 156);


    }

}

// 今天是哪一天
- (NSInteger)day:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
// 今天是周几
- (NSInteger)severalWeeks:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    return [components weekday];
}

// 本月是那一月
- (NSInteger)month:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
// 今年是那一年
- (NSInteger)year:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}
// 这个月共有几天
- (NSInteger)totaldaysInMonth:(NSDate *)date
{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

@end












