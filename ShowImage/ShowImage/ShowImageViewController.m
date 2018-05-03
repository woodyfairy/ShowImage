//
//  ViewController.m
//  ShowImage
//
//  Created by 吴冬炀 on 2018/4/17.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import "ShowImageViewController.h"

//#define timeInterval 8
//#define animTime 0.6

@interface ShowImageViewController ()<UIScrollViewDelegate>
//UI
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Pre;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Cur;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Nex;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ShowImageViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)initWithImageArray:(NSMutableArray<UIImage *> *)array{
    if ([self initWithNibName:@"ShowImageViewController" bundle:nil]) {
        _arrayImages = array;
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _timeInterval = 0;//8
        _animTime = 0.6f;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = 0;
    
    [self.scrollView setDelegate:self];
    [self.scrollView setDecelerationRate: 0.999];
    
    //[self refreshCurrentImage]; //viewDidLayoutSubviews中会调用，这里调用在加载view之前，offset会被xib中替代
    
    //定时
    [self startTimer];
}
-(void)setArrayImages:(NSMutableArray<UIImage *> *)arrayImages{
    _arrayImages = arrayImages;
    _currentIndex = 0;
    [self refreshCurrentImage];
}
-(void)setTimeInterval:(float)timeInterval{
    _timeInterval = timeInterval;
    [self startTimer];
}
-(void)startTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.timeInterval > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self next];
        }];
    }
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)refreshCurrentImage{
    self.scrollView.userInteractionEnabled = YES;
    float offsetX = self.scrollView.contentOffset.x;
    if (offsetX < 0) {
        _currentIndex --;
        if (_currentIndex < 0) {
            _currentIndex = self.arrayImages.count - 1;
        }
    }
    else if (offsetX > 0){
        _currentIndex ++;
        if (_currentIndex > self.arrayImages.count - 1) {
            _currentIndex = 0;
        }
    }
    
    
    [self.scrollView setContentOffset : CGPointZero];
    
    makeTransform(self.imageView_Cur, 1, 1);
    self.imageView_Cur.layer.zPosition = -1000;
    
    if (self.arrayImages && self.arrayImages.count > 0) {
        self.imageView_Cur.image = self.arrayImages[_currentIndex];
        
        long prv = _currentIndex - 1;
        if (prv < 0) {
            prv = self.arrayImages.count - 1;
        }
        self.imageView_Pre.image = self.arrayImages[prv];
        
        long nxt = _currentIndex + 1;
        if (nxt > self.arrayImages.count - 1) {
            nxt = 0;
        }
        self.imageView_Nex.image = self.arrayImages[nxt];
    }
}

-(void)viewDidLayoutSubviews{
    //旋转之后
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, self.scrollView.frame.size.width, 0, 0)];
    [self.scrollView setContentOffset:CGPointZero];//用在第一次启动，否则refresh时相当于向前移动了一次
    //NSLog(@"offset:%@", NSStringFromCGPoint(self.scrollView.contentOffset));
    [self refreshCurrentImage];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self refreshCurrentImage];
    [self startTimer];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self refreshCurrentImage];
    [self startTimer];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.scrollView.userInteractionEnabled = NO;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x = scrollView.contentOffset.x;
    if (x < 0) {
        float leftPercent = -x / scrollView.frame.size.width;
        makeTransform(self.imageView_Pre, -1, leftPercent);
        makeTransform(self.imageView_Cur, 1, 1 - leftPercent);
    }else if (x > 0){
        float rightPercent = x / scrollView.frame.size.width;
        makeTransform(self.imageView_Nex, 1, rightPercent);
        makeTransform(self.imageView_Cur, -1, 1 - rightPercent);
    }
}

-(void)next{
    if (self.scrollView.contentOffset.x == 0 && self.scrollView.isDragging == false && self.scrollView.isDecelerating == false && self.scrollView.userInteractionEnabled) {
        self.scrollView.userInteractionEnabled = NO;
        //[self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
        makeTransform(self.imageView_Pre, -1, 0);
        makeTransform(self.imageView_Nex, 1, 0);
        makeTransform(self.imageView_Cur, 1, 1);
        [UIView animateWithDuration:self.animTime animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
            makeTransform(self.imageView_Pre, -1, 1);
            makeTransform(self.imageView_Nex, 1, 1);
            makeTransform(self.imageView_Cur, -1, 0);//往左走
        } completion:^(BOOL finished) {
            [self refreshCurrentImage];
        }];
    }
}



void makeTransform(UIView *view , float right, float ratio){ //right=1, left = -1;
    float s = 0.5 + 0.5 * ratio;
    float r = 0.3 + 0.7 * ratio;
    float a = 0.3 + 0.7 * ratio;
    //view.transform = CGAffineTransformMakeScale(s, s);
    CATransform3D trans = CATransform3DMakeRotation((1-r) * 90.f * M_PI/180.f * right, 0, 1, 0);
    trans = CATransform3DPerspect(trans, CGPointMake(0, 0), 1000);
    trans = CATransform3DScale(trans, s, s, 1);
    
    view.layer.transform = trans;
    view.alpha = a;
}
//获得正交投影
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ){
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ){
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

@end
