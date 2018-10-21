///Users/yanghq/Desktop/Test-new-1.3L/Test
//  CountVC.m
//  Test
//
//  Created by YangHQ on 2018/5/27.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "CountVC.h"
#import "SQLManager.h"
#import "FinishTaskM.h"


#define backGround_COLOR [UIColor colorWithRed:(246 / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]

@interface CountVC ()<ChartViewDelegate>
@property(nonatomic,strong)LineChartView *chartView;
@property(nonatomic,strong)PieChartView *pieChartView;

@property(nonatomic,strong)UIScrollView *mainscroview;

@property(nonatomic,strong)NSMutableArray *finishArr;

@end

@implementation CountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _finishArr = [NSMutableArray array];
    _finishArr = [[SQLManager shareManager]listAllTheFinishT];
    
    self.mainscroview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height)];
    self.mainscroview.contentSize = CGSizeMake(0, 1000);
    self.mainscroview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_mainscroview];

    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:20.f] forKey:UITextAttributeFont];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.view.backgroundColor=backGround_COLOR;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 100, self.view.bounds.size.width, 50)];
    label.text = @"今日小花数所占比重图";
    label.font = [UIFont boldSystemFontOfSize:20];
    [_mainscroview addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(24, 510, self.view.bounds.size.width, 50)];
    label2.text = @"本周小花数所占比重图";
    label2.font = [UIFont boldSystemFontOfSize:20];
    [_mainscroview addSubview:label2];
    [self setupThechartView];
    [self setupThePieChartView];
    
    
    //样式一的图表：
//    _chartViews = [[LineChartView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 167)];
//    LineChartData *data = [self dataWithCount:36 range:100];
//    [self setupChart:_chartViews data:data color:[UIColor colorWithRed:137/255.f green:230/255.f blue:81/255.f alpha:1]];
//    [self.view addSubview:_chartViews];
    //样式二的图表：
    
}
-(void)setupThechartView{
    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, 250)]; //0, 600, self.view.frame.size.width, 250
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:0.0 label:@"Lower Limit"];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    [leftAxis addLimitLine:ll2];
    leftAxis.axisMaximum = 100.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.xAxis.axisMaximum = 7.0;
    _chartView.xAxis.axisMinimum = 0.0;
    
    
    _chartView.rightAxis.enabled = NO;
    
    
    _chartView.legend.form = ChartLegendFormLine;
    [_chartView animateWithXAxisDuration:2.5];
    [self setDataCount:8 range:20.0];
    [_mainscroview addSubview:_chartView];
}
-(void)setupThePieChartView{
    _pieChartView = [[PieChartView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 250)];//0, 200, self.view.frame.size.width, 250
    _pieChartView.legend.enabled = NO;
    _pieChartView.delegate = self;
    [_pieChartView setExtraOffsetsWithLeft:20.f top:0.f right:20.f bottom:0.f];
    [_pieChartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseInBack];
    [_mainscroview addSubview:_pieChartView];
    [self setPieDataCount];
}
-(void)setPieDataCount{
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    FinishTaskM *finishM = [[FinishTaskM alloc]init];
    if (self.finishArr.count == 0) {
        finishM.flowerNum = @"10";
        finishM.finishiTask = @"测试数据";
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:[finishM.flowerNum intValue] label:finishM.finishiTask]];
    }
    for (int i = 0; i < _finishArr.count; i++)
    {
        finishM = self.finishArr[i];
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:[finishM.flowerNum intValue] label:finishM.finishiTask]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" 朵";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _pieChartView.data = data;
    [_pieChartView highlightValues:nil];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"6"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"小红花数量"];
        
        set1.drawIconsEnabled = NO;
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.blackColor];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
