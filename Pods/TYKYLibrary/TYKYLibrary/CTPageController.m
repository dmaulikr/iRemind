//
//  TJPageController.m
//
//

#import "CTPageController.h"

#define  DEVICE_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define  DEVICE_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define  HEAD_HEIGHT 45.0

#define  TITILE_FONT  DEVICE_WIDTH==320?13:15

@interface CTPageController ()<UIScrollViewDelegate>
@property (assign, nonatomic) CGFloat titleWidth;           //标题按钮宽度
@property (strong, nonatomic) UIScrollView *contentScrView; //内容底部滚动视图
@property (strong, nonatomic) UIScrollView *headScrView;    //头部按钮底部视图
@property (strong, nonatomic) UIButton *curruntBtn;         //当前选中按钮
@property (strong, nonatomic) NSArray *RGBArray;            //按钮选中颜色RGB
@end

@implementation CTPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleWidth = DEVICE_WIDTH/_viewControllers.count;

    if (!_lineHeight) {
        _lineHeight = 2;
    }
    if (!_selectedColor) {
        _selectedColor = [UIColor redColor];
    }
    if (!_headBackColor) {
        _headBackColor = [UIColor whiteColor];
    }
    
    if (_selectedIndex>_viewControllers.count-1) {
        _selectedIndex = 0;
    }
    
    self.RGBArray = [self getRGBWithColor:_selectedColor];
    [self initUI];
}

#pragma mark 界面布局
- (void)initUI{
    
    CGFloat W = self.view.frame.size.width;
    CGFloat H = self.view.frame.size.height;
    
    //头部标题
    UIScrollView *headScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W, HEAD_HEIGHT)];
    headScrView.backgroundColor = _headBackColor;
    for (int i = 0; i <_viewControllers.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_titleWidth*i, 0, _titleWidth, HEAD_HEIGHT)];
        btn.tag = i;
        [btn addTarget:self action:@selector(switchViewControllers:) forControlEvents:UIControlEventTouchUpInside];
        UIViewController *vc = _viewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:TITILE_FONT];
        if (i==_selectedIndex) {
            _curruntBtn = btn;
            [self setButScale:_curruntBtn withScale:1];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        [headScrView addSubview:btn];

    }
    //添加底部线条
    if (_lineShowMode!=UnDisplayMode) {
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_HEIGHT-_lineHeight/2, W, _lineHeight/2)];
        bottom.backgroundColor = [UIColor lightGrayColor];
        [headScrView addSubview:bottom];
        UIView *line = [UIView new];
        line.tag = 891101;
        line.backgroundColor = _selectedColor;
        if (_lineShowMode == AboveShowMode) {
            line.frame = CGRectMake(0, 0, _titleWidth, _lineHeight);
        }else{
            line.frame = CGRectMake(0, HEAD_HEIGHT-_lineHeight, _titleWidth, _lineHeight);
            
        }
        [headScrView addSubview:line];
    }

    self.headScrView = headScrView;
    [self.view addSubview:headScrView];
    //内容
    UIScrollView *pageScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEAD_HEIGHT, W , H-HEAD_HEIGHT-64)];
    pageScrView.contentSize = CGSizeMake(W*_viewControllers.count, pageScrView.frame.size.height);
    pageScrView.pagingEnabled = YES;
    pageScrView.showsHorizontalScrollIndicator = NO;
    pageScrView.directionalLockEnabled = YES;
    
    pageScrView.delegate = self;
    self.contentScrView = pageScrView;
    [self.view addSubview:pageScrView];
    
    for (UIViewController *vc in _viewControllers) {
        [self addChildViewController:vc];
    }
    
    // 定位到指定位置
    CGPoint offset = self.contentScrView.contentOffset;
    
    offset.x = _selectedIndex * DEVICE_WIDTH;
    [self.contentScrView setContentOffset:offset animated:NO];

    [self scrollViewDidEndScrollingAnimation: self.contentScrView];

}

#pragma mark - <UIScrollViewDelegate>

/**
 *  当scrollView进行动画结束的时候会调用这个方法, 例如调用[self.contentScrollView setContentOffset:offset animated:YES];方法的时候
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / width;
    
    _curruntBtn = self.headScrView.subviews[index];
    
    UIViewController *willShowVc = self.childViewControllers[index];
    
    if([willShowVc isViewLoaded]) return;
    
    willShowVc.view.frame = CGRectMake(index * width, 0, width, height);
    
    [scrollView addSubview:willShowVc.view];
    
}

/**
 *  当手指抬起停止减速的时候会调用这个方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 *  scrollView滚动时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale<0||scale>_viewControllers.count-1) {
        return;
    }
    // 获取需要操作的的左边的button
    NSInteger leftIndex = scale;
    UIButton *leftBtn = self.headScrView.subviews[leftIndex];
  
    // 获取需要操作的右边的button
    NSInteger rightIndex = scale+1;
    UIButton *rightBtn = (rightIndex == _viewControllers.count) ?  nil : self.headScrView.subviews[rightIndex];


    // 右边的比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1- rightScale;
    
    // 设置比例
    [self setButScale:leftBtn withScale:leftScale];
    [self setButScale:rightBtn withScale:rightScale];
    
    if (_lineShowMode!=UnDisplayMode) {
       
        UIView *line = (UIView *)[self.headScrView viewWithTag:891101];
        line.center = CGPointMake(_titleWidth*scale+_titleWidth/2, line.center.y);
    }
}

#pragma mark 切换视图控制器
- (void)switchViewControllers:(UIButton *)btn{
    if (btn==_curruntBtn) {
        return;
    }
    _curruntBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);

    [_curruntBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _curruntBtn = btn;;

    // 定位到指定位置
    CGPoint offset = self.contentScrView.contentOffset;
    
    offset.x = btn.tag * DEVICE_WIDTH;
    [self.contentScrView setContentOffset:offset animated:NO];

    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[btn.tag];
    if([willShowVc isViewLoaded]) return;
    willShowVc.view.frame = CGRectMake(btn.tag * DEVICE_WIDTH, 0, DEVICE_WIDTH, self.contentScrView.frame.size.height);
    [self.contentScrView addSubview:willShowVc.view];
}

#pragma mark 设置头部按钮大小渐变
- (void)setButScale:(UIButton *)btn withScale:(CGFloat)scale {
    
    CGFloat red = [self.RGBArray[0] floatValue];
    CGFloat green = [self.RGBArray[1] floatValue];
    CGFloat blue = [self.RGBArray[2] floatValue];

    // 颜色渐变
    CGFloat red1 = scale*red;
    CGFloat green1 = green*scale;
    CGFloat blue1 = blue*scale;
    [btn setTitleColor:[UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:1.0] forState:UIControlStateNormal];
    
    // 大小缩放比例
    CGFloat transformScale = 1 + (scale * 0.1);
    btn.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}


#pragma mark 获取RGB颜色数值
- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
