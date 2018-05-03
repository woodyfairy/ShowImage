//
//  ViewController.h
//  ShowImage
//
//  Created by 吴冬炀 on 2018/4/17.
//  Copyright © 2018年 吴冬炀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController

-(instancetype)initWithImageArray:(NSMutableArray <UIImage *>*)array;
@property (strong, nonatomic) NSMutableArray <UIImage *>*arrayImages;
@property (assign, nonatomic, readonly) long currentIndex;
@property (assign, nonatomic) float timeInterval;
@property (assign, nonatomic) float animTime;

@end

