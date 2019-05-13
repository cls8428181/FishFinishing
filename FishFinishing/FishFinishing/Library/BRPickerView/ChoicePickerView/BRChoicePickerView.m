//
//  BRChoicePickerView.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "BRChoicePickerView.h"
#import "KNBChoiceTableViewCell.h"
#import "KNBRecruitmentTypeModel.h"

@interface BRChoicePickerView ()<UITableViewDelegate, UITableViewDataSource>
//标签视图
@property (nonatomic, strong) UITableView *tableView;
//模型数据
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *title;
// 单列选择的值
@property (nonatomic, strong) NSString *selectValue;
// 多列选择的值
@property (nonatomic, strong) NSMutableArray *selectValueArr;
@property (nonatomic, assign) NSInteger selectRow;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 主题色
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, copy) BRStringResultBlock resultBlock;
@property (nonatomic, copy) BRStringCancelBlock cancelBlock;
@end

@implementation BRChoicePickerView
+ (void)showTagsPickerWithTitle:(NSString *)title
                     dataSource:(NSArray *)dataSource
                    resultBlock:(BRStringResultBlock)resultBlock
                    cancelBlock:(BRStringCancelBlock)cancelBlock {
    [self showStringPickerWithTitle:title dataSource:dataSource themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(NSArray *)dataSource
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRStringCancelBlock)cancelBlock {
    BRChoicePickerView *strPickerView = [[BRChoicePickerView alloc]initWithTitle:title dataSource:dataSource themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [strPickerView showWithAnimation:YES];
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(NSArray *)dataSource
                   themeColor:(UIColor *)themeColor
                  resultBlock:(BRStringResultBlock)resultBlock
                  cancelBlock:(BRStringCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.title = title;
        self.isAutoSelect = NO;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        self.dataArray = dataSource;
        self.selectRow = 0;
        [self initUI];
    }
    return self;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentUnitModel *model = self.dataArray[indexPath.row];
    KNBChoiceTableViewCell *cell = [KNBChoiceTableViewCell cellWithTableView:tableView title:model.name];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentUnitModel *model = self.dataArray[indexPath.row];
    self.selectValue = model.name;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加标签视图
    [self.alertView addSubview:self.tableView];
    
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
}

#pragma mark - 自定义主题颜色
- (void)setupThemeColor:(UIColor *)themeColor {
    self.leftBtn.layer.cornerRadius = 6.0f;
    self.leftBtn.layer.borderColor = themeColor.CGColor;
    self.leftBtn.layer.borderWidth = 1.0f;
    self.leftBtn.layer.masksToBounds = YES;
    [self.leftBtn setTitleColor:themeColor forState:UIControlStateNormal];
    
    self.rightBtn.backgroundColor = themeColor;
    self.rightBtn.layer.cornerRadius = 6.0f;
    self.rightBtn.layer.masksToBounds = YES;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.titleLabel.textColor = [themeColor colorWithAlphaComponent:0.8f];
}

#pragma mark - 字符串选择器
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, kTopViewHeight + 5, self.alertView.frame.size.width, self.dataArray.count * 50);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor knBgColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)selectValueArr {
    if (!_selectValueArr) {
        _selectValueArr = [NSMutableArray array];
    }
    return _selectValueArr;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    // 点击确定按钮后，执行block回调
    if(_resultBlock) {
        for (int i = 0; i < self.dataArray.count; i++) {
            KNBRecruitmentUnitModel *model = self.dataArray[i];
            if ([self.selectValue isEqualToString:model.name]) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model,@"model", nil];
                _resultBlock(dict);
            }
        }
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kPickerHeight + kTopViewHeight + BOTTOM_MARGIN;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kPickerHeight + kTopViewHeight + BOTTOM_MARGIN;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.tableView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.tableView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}
@end
