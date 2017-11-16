//
//  REPagedScrollView.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REPagedScrollView : UIView <UIScrollViewDelegate>

@property (strong, readonly, nonatomic) UIScrollView *scrollView;
@property (strong, readonly, nonatomic) UIPageControl *pageControl;
@property (assign, readonly, nonatomic) NSUInteger numberOfPages;
@property (strong, readonly, nonatomic) NSArray *pages;
@property (weak, readwrite, nonatomic) id<UIScrollViewDelegate> delegate;

- (void)addPage:(UIView *)pageView;
- (void)scrollToPageWithIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end
