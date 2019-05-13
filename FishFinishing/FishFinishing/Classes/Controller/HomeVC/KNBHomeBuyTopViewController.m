//
//  KNBHomeBuyTopViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeBuyTopViewController.h"
#import "KNBRecruitmentCostApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBHomeBuyTopCollectionViewCell.h"
#import "KNBHomeBuyTopHeaderView.h"
#import "KNBHomeBuyTopFooterView.h"
#import "KNBTopRemainingTimeApi.h"
#import "KNBHomeBuyTopModel.h"
#import "KNBRecruitmentPayViewController.h"
#import "KNBRecruitmentModel.h"

@interface KNBHomeBuyTopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) KNBHomeBuyTopHeaderView *headerView;
@property (nonatomic, strong) KNBHomeBuyTopFooterView *footerView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
@end

@implementation KNBHomeBuyTopViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
    
    [self fetchData];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"我要置顶";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.collectionView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    
}

- (void)addUI {
    [self.view addSubview:self.collectionView];
}

- (void)fetchData {
    KNBRecruitmentCostApi *api = [[KNBRecruitmentCostApi alloc] initWithCatId:[self.model.cat_id integerValue] costType:2];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentCostModel changeResponseJSONObject:dic];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

/**
 *  获取时间戳的字符串
 *
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getTimeyyyymmdd:(NSString *)timestamp {
    NSString * timeStampString = timestamp;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:date];
    
    return dayStr;
}

/**
 *  获取当天的字符串
 *
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentCostModel *model = self.dataArray[indexPath.row];
    KNBHomeBuyTopCollectionViewCell *cell = [KNBHomeBuyTopCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.model = model;
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 125);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // 如果是头视图
    if (kind == UICollectionElementKindSectionHeader) {
        // 从重用池里面取
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeBuyTopHeaderView" forIndexPath:indexPath];
        if ([self.model.is_stick isEqualToString:@"0"]) {
            self.headerView.timeLabel.text = @"您还未开通置顶服务，立即开通获得更多资源！";
        } else {
            KNBTopRemainingTimeApi *api = [[KNBTopRemainingTimeApi alloc] initWithFacId:[self.model.fac_id integerValue]];
            KNB_WS(weakSelf);
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                if (api.requestSuccess) {
                    NSDictionary *dic = request.responseObject[@"list"];
                    KNBHomeBuyTopModel *model = [KNBHomeBuyTopModel changeResponseJSONObject:dic];
                    // 倒计时的时间 测试数据
                    NSString *deadlineStr = [weakSelf getTimeyyyymmdd:model.stick_due_time];
                    // 当前时间的时间戳
                    NSString *nowStr = [weakSelf getCurrentTimeyyyymmdd];
                    // 计算时间差值
                    NSInteger secondsCountDown = [weakSelf getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
                    
                    if (weakSelf.timer == nil) {
                        __block NSInteger timeout = secondsCountDown; // 倒计时时间
                        
                        if (timeout!=0) {
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            weakSelf.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                            dispatch_source_set_timer(weakSelf.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
                            dispatch_source_set_event_handler(weakSelf.timer, ^{
                                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                                    dispatch_source_cancel(weakSelf.timer);
                                    weakSelf.timer = nil;
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        weakSelf.headerView.timeLabel.text = @"置顶时间已结束";
                                    });
                                } else { // 倒计时重新计算 时/分/秒
                                    NSInteger days = (int)(timeout/(3600*24));
                                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                                    NSString *strTime = [NSString stringWithFormat:@"您的商户置顶时间剩余 %02ld 天 %02ld 小时 %02ld 分 %02ld 秒", days, hours, minute, second];
                                    
                                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTime];
                                    NSRange range1 = [[str string] rangeOfString:@"您的商户置顶时间剩余"];
                                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range1];
                                    NSRange range2 = [[str string] rangeOfString:@"天"];
                                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range2];
                                    NSRange range3 = [[str string] rangeOfString:@"小时"];
                                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range3];
                                    NSRange range4 = [[str string] rangeOfString:@"分"];
                                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range4];
                                    NSRange range5 = [[str string] rangeOfString:@"秒"];
                                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range5];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        weakSelf.headerView.timeLabel.attributedText = str;
                                    });
                                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                                }
                            });
                            dispatch_resume(weakSelf.timer);
                        }
                    }
                    
                }
            } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            }];
        }
        return _headerView;
    }else{
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeBuyTopFooterView" forIndexPath:indexPath];
        return _footerView;
    }
    
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentCostModel *costModel = self.dataArray[indexPath.row];
    self.recruitmentModel.priceModel = costModel;
    KNBRecruitmentPayViewController *payVC = [[KNBRecruitmentPayViewController alloc] init];
    payVC.recruitmentModel = self.recruitmentModel;
    payVC.type = KNBPayVCTypeTop;
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 60;
        layout.minimumLineSpacing = 13;
        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 153); //头视图的大小
        layout.footerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 193); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(15, 80, 15, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeBuyTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeBuyTopCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeBuyTopHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBHomeBuyTopHeaderView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeBuyTopFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KNBHomeBuyTopFooterView"];
    }
    return _collectionView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.recruitmentModel.serviceModel = model;
}

- (KNBRecruitmentModel *)recruitmentModel {
    if (!_recruitmentModel) {
        _recruitmentModel = [[KNBRecruitmentModel alloc] init];
    }
    return _recruitmentModel;
}

@end
