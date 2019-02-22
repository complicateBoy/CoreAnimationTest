//
//  ViewController.m
//  CoreAnimationTest
//
//  Created by ZS on 2018/4/17.
//  Copyright © 2018年 ZS. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+cropRect.h"


#define screenW self.view.frame.size.width
#define screenH self.view.frame.size.height

@interface ViewController ()<CALayerDelegate>

@property (nonatomic,strong) UIView *layerView;
@property (nonatomic,strong) CALayer *blueLayer;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSMutableArray *viewArr;
@property (nonatomic,strong) UILabel *clockLabel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(screenW/2 - 100, screenH / 2 - 100, 200, 200)];
    self.layerView.backgroundColor = [UIColor whiteColor];
    
    //图片自适应
    /*
    kCAGravityCenter
    kCAGravityTop
    kCAGravityBottom
    kCAGravityLeft
    kCAGravityRight
    kCAGravityTopLeft
    kCAGravityTopRight
    kCAGravityBottomLeft
    kCAGravityBottomRight
    kCAGravityResize
    kCAGravityResizeAspect
    kCAGravityResizeAspectFill
    */
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    
    //是否允许超出边界,图层内子图层被截取;阴影通常就是在layer边界之外，开启后会被剪掉
    self.layerView.layer.masksToBounds = YES;
    
    UIImage *image = [UIImage imageNamed:@"sticker"];
    self.layerView.layer.contents = (__bridge id)image.CGImage;
    
    //子图层将会沿着底部排版而不是顶部，position由父图层的左上角变为左下角
    self.layerView.layer.geometryFlipped = YES;
    
//    self.layerView.layer.contentsScale = image.scale;
    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
//    self.layerView.layer.contentsScale = 2.5;
    
    self.layerView.layer.cornerRadius = 20;
    
    //边框
    self.layerView.layer.borderColor = [UIColor blueColor].CGColor;
    self.layerView.layer.borderWidth = 4.0f;

    //阴影
    self.layerView.layer.shadowOpacity = 0.6f;
    self.layerView.layer.shadowRadius = 5.0f;
    self.layerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layerView.layer.shadowOffset = CGSizeMake(0, 3);
    
    [self.view addSubview:self.layerView];
    
    
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(75, 75, 50, 50);
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.blueLayer.delegate = self;
    self.blueLayer.shadowOpacity = 0.6f;
    
    //指定阴影的形状大小
    //方形阴影
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.blueLayer.bounds);
    self.blueLayer.shadowPath = squarePath;
    
    //圆型阴影
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.blueLayer.bounds);
    self.blueLayer.shadowPath = squarePath;
    
    
    [self.layerView.layer addSublayer:self.blueLayer];

    
    // force layer to redraw
    [self.blueLayer display];
    
    //改变锚点，并旋转
    [UIView animateWithDuration:0.5 animations:^{
        self.layerView.layer.anchorPoint = CGPointMake(0.5, 0.9);
        self.layerView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    }];
    
    [self customCronerRadius];
    
    [self customAlpha];
    
    [self customMaskLayer];
    
    [self customNumberClock];
    
    [self customClockCount];
    
    
    [self setChangeColorView];
    
    
    [self customShapeLayer];
   
}

- (void)customCronerRadius
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenW - 100, 200, 100, 100)];
    [self.view addSubview:imageView];
    UIImage *image = [UIImage imageNamed:@"十二生肖"];
    imageView.image = [image cropImageWithRect:CGRectMake(-10, -10, 100, 100)];
}

//设置视图图层组透明
- (void)customAlpha{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screenW /2 - 80, 100, 160, 50)];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor whiteColor];
    btn.alpha = 0.5;
    //shouldRasterize设置为YES
    //在应用透明之前，图层及其自图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了
    btn.layer.shouldRasterize = YES;
    //默认情况图层拉伸都是1.0，确保设置rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题
    btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 30)];
    NSString * testNumber = @"3.1400000";
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    label.text = outNumber;
    label.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:label];
    
}

//为图层添加蒙版
- (void)customMaskLayer
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 100, 100)];
    self.imageView.image = [UIImage imageNamed:@"乌龟"];
    [self.view addSubview:self.imageView];
    
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.layerView.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"sticker"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    self.imageView.layer.mask = maskLayer;
    
}

- (void)customClockCount
{
    self.clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW/2 - 120, screenH - 50, 240, 50)];
    self.clockLabel.backgroundColor = [UIColor whiteColor];
    self.clockLabel.textColor = [UIColor blueColor];
    self.clockLabel.font = [UIFont systemFontOfSize:16];
    self.clockLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.clockLabel];
    
    //活动开始时间
    self.startDate = [NSDate dateWithTimeIntervalSinceNow:60*1];
    //活动结束时间
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*12];
   
    //启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
}
- (void)run
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *startDateComponent = [calendar components:unitFlags fromDate:self.startDate];
    NSInteger year = [startDateComponent year];
    NSInteger month = [startDateComponent month];
    NSInteger day = [startDateComponent day];
    
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSInteger nowYear = [dateComponent year];
    NSInteger nowMonth = [dateComponent month];
    NSInteger nowDay = [dateComponent day];
    //活动开始时间
    double startDistance = [nowDate timeIntervalSinceReferenceDate] - [self.startDate timeIntervalSinceReferenceDate];
    //活动结束时间
    double endDistance = [nowDate timeIntervalSinceReferenceDate] - [self.endDate timeIntervalSinceReferenceDate];
    
    //这种判断太复杂低效
    //使用下面的判断更高效和简介
    if (year == nowYear) {
        if (month == nowMonth) {
            if (day == nowDay) {
                if (startDistance > 0 && endDistance < 0) {
                    //在募集期
                    [self hadArrivedDate:endDistance];
                }else if (startDistance <= 0){
                    //募集前
                    [self notArriveDate:startDistance];
                }else if (endDistance >= 0){
                    //募集结束
                    self.clockLabel.text = @"项目已锁定";
                }
            }
            else{
                [self.timer invalidate];
                self.timer = nil;
                self.clockLabel.text = @"项目未开始/已锁定";
            }
        }
        else{
            [self.timer invalidate];
            self.timer = nil;
            self.clockLabel.text = @"项目未开始/已锁定";
        }
    }
    else{
        [self.timer invalidate];
        self.timer = nil;
        self.clockLabel.text = @"项目未开始/已锁定";
    }
}
- (void)notArriveDate:(double)dTime
{
    NSInteger ltime = ceil(fabs(dTime));
    NSInteger seconds = ltime % 60;
    NSInteger minutes = (ltime / 60) % 60;
    NSInteger hours = (ltime / 3600);
    self.clockLabel.text = [NSString stringWithFormat:@"距离开始还剩 %02ld:%02ld:%02ld",hours,minutes,seconds];
}
- (void)hadArrivedDate:(double)dTime
{
    NSInteger lTime = ceil(fabs(dTime));
    NSInteger seconds = lTime % 60;
    NSInteger minutes = (lTime / 60) % 60;
    NSInteger hours = (lTime / 3600);
    self.clockLabel.text = [NSString stringWithFormat:@"距离结束还剩 %02ld:%02ld:%02ld",hours,minutes,seconds];
}

//制作LCD时钟
- (void)customNumberClock
{
    self.viewArr = [NSMutableArray arrayWithCapacity:6];
    UIImage *digits = [UIImage imageNamed:@"number"];
    for (int i = 0; i < 6; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6*i, 0, self.view.frame.size.width/6, self.view.frame.size.width/6)];
        view.layer.contents = (__bridge id)digits.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
        //kCAFilterNearest
        view.layer.magnificationFilter = kCAFilterLinear;
        [self.view addSubview:view];
        [self.viewArr addObject:view];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}
- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    //adjust contentsRect to select correct digit
    view.layer.contentsRect = CGRectMake(digit*0.1, 0, 0.1, 1.0);
}
- (void)tick
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    [self setDigit:hour/10 forView:self.viewArr[0]];
    [self setDigit:hour%10 forView:self.viewArr[1]];
    
    [self setDigit:minute/10 forView:self.viewArr[2]];
    [self setDigit:minute%10 forView:self.viewArr[3]];
    
    [self setDigit:second/10 forView:self.viewArr[4]];
    [self setDigit:second%10 forView:self.viewArr[5]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //get touch positon relative to main view
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
    if ([self.layerView.layer containsPoint:point]) {
        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
        if ([self.blueLayer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        }
        else{
           [[[UIAlertView alloc] initWithTitle:@"Inside white Layer" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        }
    }
    
    //hit testing
    CGPoint point2 = [[touches anyObject] locationInView:self.view];
    CALayer *layer = [self.layerView.layer hitTest:point2];
    if (layer == self.blueLayer) {
        [[[UIAlertView alloc] initWithTitle:@"触点在蓝色图层" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
    else if (layer == self.layerView.layer){
        [[[UIAlertView alloc] initWithTitle:@"触点在白色图层" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }

}


- (void)setChangeColorView
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(__bridge id)[[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor,(__bridge id)[[UIColor orangeColor] colorWithAlphaComponent:0.1].CGColor];
    
    gradientLayer.locations = @[@0.1,@0.5];
    
    gradientLayer.startPoint = CGPointMake(1, 0);
    
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    
}

- (void)customShapeLayer
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];


    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    
    [self.view.layer addSublayer:shapeLayer];
    
    
}


#pragma mark - calayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 5.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
    
}




@end







