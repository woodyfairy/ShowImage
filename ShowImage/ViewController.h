//
//  ViewController.h
//  ShowImage
//
//  Created by 吴冬炀 on 2018/4/17.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Pre;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Cur;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Nex;

@property (strong, nonatomic) NSMutableArray <UIImage *>*arrayImages;
@property (assign, nonatomic) long currentIndex;

@property (strong, nonatomic) NSTimer *timer;

@end

