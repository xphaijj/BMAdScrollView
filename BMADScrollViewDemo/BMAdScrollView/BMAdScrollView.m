//
//  BMAdScrollView.m
//  UIPageController
//
//  Created by skyming on 14-5-31.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "BMAdScrollView.h"

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define PAGE_HEIGHT 37
#define rightDirection 1
#define zeroDirection 0
#define INTERVALE 8

// 广告位标题高度
static CGFloat const TitleHeight = 30.0f;
static CGFloat const BannerHeight = 180.0f;

@implementation BMButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end


@implementation BMBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            
    }
    return self;
}


//新定义初始化视图方法
-(id)initWithFrame:(CGRect)frame ImageName:(NSString *)imageName title:(NSString *)titleStr {
    
    self = [super initWithFrame:frame];
    if (self) {

        //设置图片视图
        CGRect imageFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - TitleHeight);
        UIButton *imageButton = [self imageViewForBanner:imageFrame imageURL:imageName];
        [self addSubview:imageButton];
        
        //设置背景条
        CGRect titleFrame = CGRectMake(0, frame.size.height-TitleHeight, frame.size.width, TitleHeight);
        UIView *titleView = [self titleViewForBanner:titleFrame title:titleStr];
        [self addSubview:titleView];
        
        // 默认显示标题
        _titleHidden = NO;
    }
    return self;
}

// 广告位图片
- (BMButton *)imageViewForBanner:(CGRect)frame imageURL:(NSString *)imageURL {
   
    BMButton *imageButton = [[BMButton alloc]initWithFrame:frame];

    // 本地资源
    [imageButton setImage:[UIImage imageNamed:imageURL] forState:UIControlStateNormal];

    //给定网络图片路径
    if ([imageURL hasPrefix:@"http://"] || [imageURL hasPrefix:@"https://"]) {
        // [imageView setImageFromUrl:YES withUrl:imageName];
    }
    
    //设置点击方法
    [imageButton addTarget:self action:@selector(bannerClick) forControlEvents:UIControlEventTouchUpInside];

    return imageButton;
}

// 广告栏标题
- (UIView *)titleViewForBanner:(CGRect)frame  title:(NSString *)title {
 
    // 标题背景
    UIView *titleView = [[UIView alloc]initWithFrame:frame];
    titleView.backgroundColor =[UIColor whiteColor];
    titleView.alpha = 1.0;
    
    // 设置标题文字
    CGRect titleRect = CGRectMake(10, 0, frame.size.width-20, TitleHeight);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleRect];
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.alpha = 0.8;
    [titleView addSubview:titleLabel];
    
    return titleView;
}

// 隐藏标题
- (void)setTitleHidden:(BOOL)titleHidden {

    if (_titleHidden == titleHidden) {
        return ;
    }
    
    CGRect frame = self.frame;

    if (titleHidden) {
        frame.size.height -= TitleHeight;
    }else{
        frame.size.height += TitleHeight;
    }
    self.frame = frame;
}

// 点击事件
-(void)bannerClick{
    NSLog(@"Button 点击事件");
    [self.delegate bannerClickAt:self.tag];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end




@interface BMAdScrollView()<UIScrollViewDelegate,BannerClickEventDelegate>
{
    int switchDirection;//方向
//    CGFloat offsetY;
    NSMutableArray *imageArray;//图片数组
    NSMutableArray *titleArray;//标题数组
    
    UIScrollView *imageSV;//滚动视图
    UIPageControl *pageControl;
    BMBannerView *bannerView;
}
@end
static  int pageNumber;//页码

@implementation BMAdScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//自定义实例化方法
- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)imageURLs titles:(NSMutableArray *)titles {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        pageNumber=0; //设置当前页为1
       
        imageArray = imageURLs;
        titleArray = titles;

        [self addADScrollView:imageArray.count height:frame.size.height];
        
        [self addImages:imageArray titles:titleArray];
        
        [self addPageControl:imageURLs.count];
        
      //设置NSTimer
        _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void)addADScrollView:(NSInteger)count height:(CGFloat)heightValue
{
    //初始化scrollView
    imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, heightValue)];
  
    //设置sview属性
    imageSV.directionalLockEnabled = YES;//锁定滑动的方向
    imageSV.pagingEnabled = YES; //滑到subview的边界
    imageSV.bounces = NO;
    imageSV.delegate = self;
    imageSV.showsVerticalScrollIndicator = NO;//不显示垂直滚动条
    imageSV.showsHorizontalScrollIndicator = NO;//不显示水平滚动条
    imageSV.userInteractionEnabled = YES;
    CGSize newSize = CGSizeMake(WIDTH * (count + 2),  imageSV.bounds.size.height);//设置scrollview的大小
    [imageSV setContentSize:newSize];
    [self addSubview:imageSV];

}


- (void)addImages:(NSArray *)imageArr titles:(NSArray *)titleArr
{
    // 添加 Banner
    for (int i = 0; i <= imageArr.count +1; i++) {
        
        NSString *title = @"";
        NSString *imageURL = @"";
        
        if (i != titleArray.count + 1 && i != 0) {
            title = titleArr[i - 1];
            imageURL = imageArr[i - 1];
        }
        
        if (i == 0) {
            title = titleArr[titleArr.count - 1];
            imageURL = imageArr[imageArr.count - 1];
        }else if(i == titleArr.count +1)
        {
            title = titleArr[0];
            imageURL = imageArr[0];
        }
        
        //创建内容对象
        CGRect bannerFrame = CGRectMake(WIDTH * i, 0, WIDTH, BannerHeight);
        
        bannerView = [[BMBannerView alloc]initWithFrame:bannerFrame ImageName:imageURL title:title];
        bannerView.titleHidden = NO;
        //制定AOView委托
        
        bannerView.delegate = self;
        
        //设置视图标示
        bannerView.tag = i;
        
        //添加视图
        [imageSV addSubview:bannerView];
    }
    
    [imageSV setContentOffset:CGPointMake(0, 0)];
    [imageSV scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页

}
- (void)addPageControl:(NSInteger)count
{
    CGRect rect =  CGRectMake(0, 180, 120, PAGE_HEIGHT);
    pageControl = [[UIPageControl alloc]initWithFrame:rect];
    
    if (_pageCenter.y == 0.0) {
        _pageCenter.y = self.frame.size.height - 15;
        _pageCenter.x = pageControl.center.x;
    }
    pageControl.center = _pageCenter;
    pageControl.numberOfPages = count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageControl];
    
}

- (void)setPageCenter:(CGPoint)pageCenter
{
    pageControl.center = pageCenter;
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int page = floor((imageSV.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int currentPage = floor((imageSV.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [imageSV scrollRectToVisible:CGRectMake(WIDTH * [imageArray count],0,WIDTH,HEIGHT) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageArray count]+1))
    {
        [imageSV scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,HEIGHT) animated:NO]; // 最后+1,循环第1页
    }
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    [imageSV scrollRectToVisible:CGRectMake(WIDTH*(page+1),0,WIDTH,HEIGHT) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

// 定时器 绑定的方法
- (void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > imageArray.count-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma UBdelegate

- (void)bannerClickAt:(NSInteger)idx{
    NSLog(@"-----Bannder 事件收到了");
    if ([self.delegate respondsToSelector:@selector(imageClickAt:)]) {
        [self.delegate imageClickAt:idx];
    }
}

@end
