//
//  ViewController.m
//  testCorner
//
//  Created by 李东喜 on 16/4/5.
//  Copyright © 2016年 don. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *saleDataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setupData];
    [self setupView];
}


#pragma mark Lazy loading
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)saleDataArray{
    if (!_saleDataArray) {
        _saleDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _saleDataArray;
}

- (void)setupView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    // 分组样式需要设置
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
}

- (void)setupData{
    [self.dataArray addObject:@"分区1.1"];
    [self.dataArray addObject:@"分区1.2"];
    [self.dataArray addObject:@"分区1.3"];
    [self.saleDataArray addObject:@"分区2.1"];
    [self.saleDataArray addObject:@"分区2.2"];
}

#pragma mark table view delegate and datasource
/**
 * tableview中有多少个分组
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/**
 * 每个分组header的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 44;
    }
    else if (1 == section) {
        return 22;
    }
    
    return 0;
}

/**
 *  每个section组的头部应该显示什么标题
 *
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"第一组";
    }else if (1 == section) {
        return @"第二组";
    }
    
    return @"";
}

/**
 * 每个分组footer的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 22;
    }
    else if (1 == section) {
        return 0;
    }
    
    return 20;
}

/**
 * 每个分组中有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return [self.dataArray count];
    }else if (1 == section) {
        return [self.saleDataArray count];
    }
    
    return 1;
}

/**
 * 每行应显示的内容数据设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *item = [[NSString alloc] init];
    
    if (0 == indexPath.section) {
        item = self.dataArray[indexPath.row];
    }else if (1 == indexPath.section) {
        item = self.saleDataArray[indexPath.row];
    }
    
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例，可重用cell单元
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // 对cell 进行简单地数据配置
    cell.textLabel.text = item;
    cell.detailTextLabel.text = item;
    
    return cell;
}

/**
 * 每行cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

/**
 * 点击每个cell要实现的方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 * 将要为每行row绘制cell，可自定义cell显示方法
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            // 圆角弧度半径
            CGFloat cornerRadius = 5.f;
            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
            cell.backgroundColor = UIColor.clearColor;
            
            // 创建一个shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
            CGMutablePathRef pathRef = CGPathCreateMutable();
            // 获取cell的size
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            // CGRectGetMinY：返回对象顶点坐标
            // CGRectGetMaxY：返回对象底点坐标
            // CGRectGetMinX：返回对象左边缘坐标
            // CGRectGetMaxX：返回对象右边缘坐标
            
            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
            BOOL addLine = NO;
            // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            if (indexPath.row == 0) {
                // 初始起点为cell的左下角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                // 初始起点为cell的左上角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
            layer.path = pathRef;
            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
            CFRelease(pathRef);
            // 按照shape layer的path填充颜色，类似于渲染render
           // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.fillColor = [UIColor whiteColor].CGColor;
            // 添加分隔线图层
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                // 分隔线颜色取自于原来tableview的分隔线颜色
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            // view大小与cell一致
            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
            // 添加自定义圆角后的图层到roundView中
            [roundView.layer insertSublayer:layer atIndex:0];
            roundView.backgroundColor = UIColor.clearColor;
            //cell的背景view
            //cell.selectedBackgroundView = roundView;
            cell.backgroundView = roundView;
            
        }
    }
}


@end

