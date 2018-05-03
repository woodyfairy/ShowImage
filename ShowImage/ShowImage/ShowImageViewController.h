//
//  ViewController.h
//  ShowImage
//
//  Created by 吴冬炀 on 2018/4/17.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowImageDelegate<NSObject>
-(void)showImageViewDidRefreshImage:(UIImage *)image;
@end

@interface ShowImageViewController : UIViewController
@property (weak, nonatomic) id<ShowImageDelegate>delegate;
-(instancetype)initWithImageArray:(NSMutableArray <UIImage *>*)array;
@property (strong, nonatomic) NSMutableArray <UIImage *>*arrayImages;
-(instancetype)initWithImagePath:(NSMutableArray <NSString *>*)array;
@property (strong, nonatomic) NSMutableArray <NSString *>*arrayPaths;
@property (assign, nonatomic, readonly) long total;
@property (assign, nonatomic) long currentIndex;
@property (assign, nonatomic) float timeInterval;
@property (assign, nonatomic) float animTime;

@end

