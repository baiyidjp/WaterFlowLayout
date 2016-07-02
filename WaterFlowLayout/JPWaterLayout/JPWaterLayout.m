//
//  JPWaterLayout.m
//  WaterFlowLayout
//
//  Created by Keep丶Dream on 16/7/2.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "JPWaterLayout.h"

@interface JPWaterLayout ()

/** 存放cell全部布局属性 */
@property(nonatomic,strong) NSMutableArray *cellAttributesArray;
/** 列数 */
@property(nonatomic,assign) NSInteger columnCount;
/** 列间距 */
@property(nonatomic,assign) CGFloat columnMargin;
/** 行间距 */
@property(nonatomic,assign) CGFloat rowMargin;
/** 四周间距 */
@property(nonatomic,assign) UIEdgeInsets edgeInsets;
/** 存储每列的最大Y值 */
@property(nonatomic,strong) NSMutableArray *columnHeights;

@end

@implementation JPWaterLayout

/**
 *  懒加载各种基础数据
 */
- (NSMutableArray *)cellAttributesArray{
    
    if (!_cellAttributesArray) {
        
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}

- (NSInteger)columnCount{
    
    if (!_columnCount) {
        if ([self.delegate respondsToSelector:@selector(columnCountInWaterLayout:)]) {
            _columnCount = [self.delegate columnCountInWaterLayout:self];
        }else{
            _columnCount = 3;
        }
    }
    return _columnCount;
}

- (CGFloat)columnMargin{
    
    if (!_columnMargin) {
        if ([self.delegate respondsToSelector:@selector(columnMarginInWaterLayout:)]) {
            _columnMargin = [self.delegate columnMarginInWaterLayout:self];
        }else{
            _columnMargin = 10;
        }
    }
    return _columnMargin;
}

- (CGFloat)rowMargin{
    
    if (!_rowMargin) {
        if ([self.delegate respondsToSelector:@selector(rowMarginInWaterLayout:)]) {
            _rowMargin = [self.delegate rowMarginInWaterLayout:self];
        }else{
            _rowMargin = 10	;
        }
    }
    return _rowMargin;
}

- (UIEdgeInsets)edgeInsets{
    

    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterLayout:)]) {
        return [self.delegate edgeInsetsInWaterLayout:self];
    }else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (NSMutableArray *)columnHeights{
    
    if (!_columnHeights) {
        
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

/**
 *  初始化layout  每次刷新都会重新调用
 */
- (void)prepareLayout{
    
    [super prepareLayout];
    
    //防止第一次引用报错 先给数组初始化赋值
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //刷新后清除所有已布局的属性 重新获取
    [self.cellAttributesArray removeAllObjects];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attibute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.cellAttributesArray addObject:attibute];
    }
}

/**
 * 返回所有的cell的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.cellAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGFloat attributeW = (collectionW - self.edgeInsets.left - self.edgeInsets.right -(self.columnCount-1)*self.columnMargin) / self.columnCount;
    //item的高度 高度不等
    CGFloat attributeH = [self.delegate waterLayout:self heightForItemAtIndexPath:indexPath itemWidth:0];
    
    //找出各列中的最小的高度(每列的最大Y值的比较,取最小那个)
    //假设第0列是最小的 先算出最小的最大Y值
    NSInteger minHeight_column = 0;
    CGFloat minHeight = [self.columnHeights[minHeight_column] floatValue];
    
    for (NSInteger i = 1; i < self.columnCount; i++) {
        NSInteger currentH = [self.columnHeights[i] floatValue];
        if (minHeight > currentH) {
            minHeight = currentH;
            minHeight_column = i;
        }
    }
    
    CGFloat attributeX = self.edgeInsets.left+minHeight_column*(attributeW+self.columnMargin);
    //第0行的Y值 是默认的top值
    CGFloat attributeY = minHeight;
    if (indexPath.item / self.columnCount) {
        attributeY += self.rowMargin;
    }
    
    attribute.frame = CGRectMake(attributeX, attributeY, attributeW, attributeH);
    
    CGFloat maxY = CGRectGetMaxY(attribute.frame);
    //将计算出来的最短的Y值 替换原先的Y值
    [self.columnHeights replaceObjectAtIndex:minHeight_column withObject:@(maxY)];
    
    return attribute;
}

- (CGSize)collectionViewContentSize{
    
    NSInteger maxHeight_column = 0;
    CGFloat maxHeight = [self.columnHeights[maxHeight_column] floatValue];
    
    for (NSInteger i = 1; i < self.columnCount; i++) {
        NSInteger currentH = [self.columnHeights[i] floatValue];
        if (maxHeight < currentH) {
            maxHeight = currentH;
            maxHeight_column = i;
        }
    }
    
    return CGSizeMake(0, maxHeight + self.edgeInsets.bottom);
}
@end
