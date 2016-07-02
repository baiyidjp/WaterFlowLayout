//
//  ViewController.m
//  WaterFlowLayout
//
//  Created by Keep丶Dream on 16/7/2.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "ViewController.h"
#import "JPWaterLayout.h"

static NSString * const cellID = @"waterCollectionViewCell";

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JPWaterLayoutDelegate>

@property(nonatomic,weak)UICollectionView *waterCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setCollectionViewLayout];
}

- (void)setCollectionViewLayout{
    
    JPWaterLayout *layout = [[JPWaterLayout alloc]init];
    layout.delegate = self;
    
    UICollectionView *waterCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    waterCollectionView.delegate = self;
    waterCollectionView.dataSource = self;
    waterCollectionView.backgroundColor = [UIColor whiteColor];
    [waterCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:waterCollectionView];
    self.waterCollectionView = waterCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 150;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor orangeColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.text = [NSString stringWithFormat:@"%zd",indexPath.item];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark <JPWaterLayoutDelegate>

#warning 必须实现的代理
- (CGFloat)waterLayout:(JPWaterLayout *)waterLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    
    return 50+arc4random_uniform(100);
}
#warning 选择实现的代理
- (NSInteger)columnCountInWaterLayout:(JPWaterLayout *)waterLayout{
    return 3;
}

- (CGFloat)columnMarginInWaterLayout:(JPWaterLayout *)waterLayout{
    return 20;
}

- (CGFloat)rowMarginInWaterLayout:(JPWaterLayout *)waterLayout{
    
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterLayout:(JPWaterLayout *)waterLayout{
    
    return UIEdgeInsetsMake(20, 30, 10, 30);
}

@end
