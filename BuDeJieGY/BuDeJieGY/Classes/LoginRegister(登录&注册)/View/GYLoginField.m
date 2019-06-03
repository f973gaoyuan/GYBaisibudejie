//
//  GYLoginField.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/28.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYLoginField.h"

@implementation GYLoginField

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self addTarget:self action:@selector(editBegain) forControlEvents:UIControlEventEditingDidBegin];
//    [self addTarget:self action:@selector(editEnd) forControlEvents:UIControlEventEditingDidEnd];
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
//    [self setAttributedPlaceholder:attrStr];
    self.placeholderColor = [UIColor lightGrayColor];

    //UITextField *t = nil;
}
/*
- (void)editBegain {
    self.tintColor = [UIColor darkGrayColor];
    
    //NSTextAttachment *att = [[NSTextAttachment alloc] init];
    //att.image = [UIImage imageNamed:@"login_weixin_GY_icon"];
    //att.bounds = CGRectMake(0, 0, 18, 18);
    //NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:att];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [self setAttributedPlaceholder:attrStr];
}

- (void)editEnd {
    self.tintColor = [UIColor lightGrayColor];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    GYLog(@"%@", attrStr);
    [self setAttributedPlaceholder:attrStr];
}
*/
/*
- (BOOL)becomeFirstResponder {
    self.tintColor = [UIColor darkGrayColor];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [self setAttributedPlaceholder:attrStr];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.tintColor = [UIColor lightGrayColor];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [self setAttributedPlaceholder:attrStr];
    return [super resignFirstResponder];
}
*/
// 通过断点可以看到UITextField的私有属性"placeholderLabel"
- (BOOL)becomeFirstResponder {
    //UILabel *label = [self valueForKey:@"placeholderLabel"];
    //label.textColor = [UIColor darkGrayColor];
    self.placeholderColor = [UIColor darkGrayColor];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    //UILabel *label = [self valueForKey:@"placeholderLabel"];
    //label.textColor = [UIColor lightGrayColor];
    self.placeholderColor = [UIColor lightGrayColor];
    return [super resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
