//
//  MenuView.h
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 Henry Lam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuView : UIView

 
+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;
-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;

-(void)show;
-(void)hidenWithoutAnimation;
-(void)hidenWithAnimation;

@end
