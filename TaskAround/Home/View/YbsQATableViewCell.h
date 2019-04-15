//
//  YbsQACollectionViewCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/31.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsQuestionModel.h"
#import "YbsQueModel.h"
#import "YbsQAViewController.h"

@protocol YbsLogicDelegate <NSObject>

- (void)quetionLogicDidUpdate;

@end


//NS_ASSUME_NONNULL_BEGIN

@interface YbsQATableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *qLabel;
@property (nonatomic, strong) UIView *exampleView;
@property (nonatomic, strong) UILabel *exampleLabel;
@property (nonatomic, strong) UIScrollView *exampleSV;

@property (nonatomic, strong) YbsQueModel *questionModel;
@property (nonatomic, weak  ) id <YbsLogicDelegate> delegate;
@property (nonatomic, weak  ) YbsQAViewController *qavc;


+ (NSString *)identifierForCellWithModel:(YbsQueModel *)model;

- (void)reloadWithModel:(YbsQueModel *)model;

@end


@interface DirectionCell : YbsQATableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@interface SingleChoiceCell : YbsQATableViewCell

@property (nonatomic, strong) UITableView *tableView;

@end

@interface MultipleChoiceCell : YbsQATableViewCell

@property (nonatomic, strong) UITableView *tableView;

@end

@interface PictureCell : YbsQATableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface TextPictureCell : YbsQATableViewCell

@property (nonatomic, strong) UITableView *tableView;

@end

@interface VoiceCell : YbsQATableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@interface TextInputCell : YbsQATableViewCell

@property (nonatomic, strong) UITextView *textView;

@end









//NS_ASSUME_NONNULL_END
