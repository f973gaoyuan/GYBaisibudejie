//
//  GYBlockCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/29.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYBlockCell.h"
#import "../Model/GYSquareItem.h"

@interface GYBlockCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation GYBlockCell
- (void)setItem:(GYSquareItem *)item {
    _item = item;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _label.text = item.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 8;
    CGFloat space = 0;//5;
    
    /////////////////////////////////////
    
    CGRect bounds = self.bounds;
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    
    CGFloat labelH = 20;
    CGRect labelF = CGRectZero;
    //if(self.label == nil || [self.label.text isEqualToString:@""]) {
    if(self.label.text.length == 0) {
        labelH = 0;
    } else {
        labelF = self.label.frame;
        labelF.origin.x = bounds.origin.x + margin;
        labelF.origin.y = height - labelH - margin;
        labelF.size.width = width - 2 * margin;
        labelF.size.height = labelH;
    }
    
    CGFloat x = margin;
    CGFloat y = margin;
    CGFloat wf = width - 2*margin;
    CGFloat hf = height - 2*margin - labelH - space;
    
    if(wf < hf) {
        y += (hf - wf) / 2.0;
        hf = wf;
    } if(wf > hf) {
        x += (wf - hf) / 2.0;
        wf = hf;
    }
    
    CGRect imageF = CGRectMake(x, y, wf, hf);
    
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:(labelH - 8)];
    
    self.label.frame = labelF;
    self.imageView.frame = imageF;}

@end
