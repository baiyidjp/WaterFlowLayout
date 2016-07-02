//
//  JPWaterLayout.h
//  WaterFlowLayout
//
//  Created by Keep丶Dream on 16/7/2.
//  Copyright © 2016年 dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JPWaterLayout;

@protocol JPWaterLayoutDelegate <NSObject>

@required
//必须实现 返回item的高度 (可根据图片给定的宽高 计算比例 拿到高度 防止图片因为给定固定宽度变形)
- (CGFloat)waterLayout:(JPWaterLayout *)waterLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional //选择实现 不实现代理则使用默认值
/** 代理返回列数 默认3 */
- (NSInteger)columnCountInWaterLayout:(JPWaterLayout *)waterLayout;
/** 代理返回列间距 默认10 */
- (CGFloat)columnMarginInWaterLayout:(JPWaterLayout *)waterLayout;
/** 代理返回行间距 默认10 */
- (CGFloat)rowMarginInWaterLayout:(JPWaterLayout *)waterLayout;
/** 代理返回四周间距 默认{10,10,10,10} */
- (UIEdgeInsets)edgeInsetsInWaterLayout:(JPWaterLayout *)waterLayout;

@end

@interface JPWaterLayout : UICollectionViewLayout

@property(nonatomic,weak)id<JPWaterLayoutDelegate> delegate;

@end
