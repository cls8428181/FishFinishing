//
//  KNBHomeCompanyServerTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyServerTableViewCell.h"
#import "KNBHomeCompanyServerCollectionViewCell.h"

@interface KNBHomeCompanyServerTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
//标签视图
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *modelArray;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation KNBHomeCompanyServerTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyServerTableViewCell";
    KNBHomeCompanyServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(11);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH);
        make.height.mas_equalTo(90);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeServiceModel *model = self.modelArray[indexPath.row];
    KNBHomeCompanyServerCollectionViewCell *cell = [KNBHomeCompanyServerCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    cell.model = model;
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 90);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        KNB_WS(weakSelf);
        [KNBAlertRemind alterWithTitle:@"提示" message:@"请前往编辑页面进行服务类型修改" buttonTitles:@[@"去编辑",@"我知道了"] handler:^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"去编辑"]) {
                !weakSelf.gotoEditBlock ?: weakSelf.gotoEditBlock();
            }
        }];
    } else {
        !self.gotoOrderBlock ?: self.gotoOrderBlock();
    }

}

- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)next;
    }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}


#pragma mark - private method
+ (CGFloat)cellHeight:(BOOL)isEdit {
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && isEdit) {
        return 284;
    } else {
        return 141;
    }
}

- (IBAction)topButtonAction:(id)sender {
    !self.topButtonBlock ?: self.topButtonBlock();
}

#pragma mark - lazy load
- (void)setModel:(KNBHomeServiceModel *)model {
    self.modelArray = model.serviceList;
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && self.isEdit) {
        self.topConstraints.constant = 150;
        self.topButton.hidden = NO;
    } else {
        self.topConstraints.constant = 15;
        self.topButton.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat spacing = (KNB_SCREEN_WIDTH - 368)/2;
        layout.minimumInteritemSpacing = spacing;
        layout.minimumLineSpacing = spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KNBHomeCompanyServerCollectionViewCell class] forCellWithReuseIdentifier:@"KNBHomeCompanyServerCollectionViewCell"];
    }
    return _collectionView;
}

@end
