//
//  GYTopicCellMode.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTopicCellMode.h"


@implementation GYTopicCellMode
- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    
    CGFloat cellHeight = 0;
    
    CGFloat margin = 10;
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat contentLabelX = margin;
    CGFloat contentLabelY = 53;
    CGFloat contentLabelW = GYScreenW - 2 * contentLabelX;
    CGFloat contentLabelH = 0;
    NSString *text = topicItem.text;
    if(text.length > 0) {
        if(topicItem.status == GYTopicStatusEssence) {
            text = [text stringByAppendingString:@"精华帖"];
        }
        //contentLabelH = [topicItem.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(contentLabelW, MAXFLOAT)].height;
        contentLabelH = [text boundingRectWithSize:CGSizeMake(contentLabelW, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}
                                           context:nil].size.height;
    }
    CGFloat topViewW = GYScreenW;
    CGFloat topViewH = contentLabelY + contentLabelH + margin;
    _topTopViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = CGRectGetMaxY(_topTopViewFrame);
    //==============================================================================================
    _pictureTopicViewFrame = CGRectMake(-100, 0, 1, 1);
    _videoTopicViewFrame = CGRectMake(-100, 0, 1, 1);
    //if([topicItem.type isEqualToString:@"image"]) {
    if(topicItem.image) {
        CGSize size = CGSizeMake(topicItem.image.width, topicItem.image.height);
        if(size.width > 0) {
            CGFloat imageX = 0;
            CGFloat imageY = cellHeight;
            CGFloat imageW = GYScreenW;
            CGFloat imageH = imageW * size.height / size.width;
            
            CGFloat WScaleH = 1;
            if(imageH > imageW*WScaleH) {
                imageH = imageW*WScaleH;
            }
            _pictureTopicViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
            cellHeight = CGRectGetMaxY(_pictureTopicViewFrame);
        }
     } else if(topicItem.gif) {
         CGSize size = CGSizeMake(topicItem.gif.width, topicItem.gif.height);
         if(size.width > 0) {
             CGFloat gifX = margin;
             CGFloat gifY = cellHeight;
             CGFloat gifW = size.width;
             CGFloat gifH = size.height;
             
             CGFloat maxW = (GYScreenW - 2*margin);
             if(gifW > maxW) {
                 gifW = maxW;
                 gifH = gifW * size.height / size.width;
             }
             _pictureTopicViewFrame = CGRectMake(gifX, gifY, gifW, gifH);
             cellHeight = CGRectGetMaxY(_pictureTopicViewFrame);
        }
     } if(topicItem.video) {
         CGSize size = CGSizeMake(topicItem.video.width, topicItem.video.height);
         CGFloat videoX = 0;
         CGFloat videoY = cellHeight;
         CGFloat videoW = GYScreenW;
         CGFloat videoH = videoW * size.height / size.width;
         if(videoH > GYScreenW) {
             videoH = GYScreenW;
         }
         _videoTopicViewFrame = CGRectMake(videoX, videoY, videoW, videoH);
         cellHeight = CGRectGetMaxY(_videoTopicViewFrame);
     }
    //==============================================================================================
    _commentTopicViewFrame = CGRectMake(-100, 0, 1, 1);
    if(topicItem.top_comments.count > 0) {
        GYCommentItem *commentItem = topicItem.top_comments[0];
        CGFloat space = 8;
        CGFloat commentX = margin;
        CGFloat commentY = cellHeight+margin;

        CGFloat conLabelW = GYScreenW - 2*margin - 2*space;
        //CGFloat conLabelH = [commentItem.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(conLabelW, MAXFLOAT)].height;
        NSString *text = commentItem.content;
        CGFloat conLabelH = [text boundingRectWithSize:CGSizeMake(conLabelW, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                               context:nil].size.height;

        CGFloat commentW = GYScreenW - 2*margin;
        CGFloat commentH = 41+conLabelH + space;

        _commentTopicViewFrame = CGRectMake(commentX, commentY, commentW, commentH);
        cellHeight = CGRectGetMaxY(_commentTopicViewFrame);
    }
    //==============================================================================================

    CGFloat bottomX = 0;
    CGFloat bottomY = cellHeight;
    
    CGFloat commentW = GYScreenW;
    CGFloat commentH = 48;
    _bottomTopicViewFrame = CGRectMake(bottomX, bottomY, commentW, commentH);
    cellHeight = CGRectGetMaxY(_bottomTopicViewFrame);

    //cellHeight += margin;
    _cellHeight = cellHeight;
}
@end
