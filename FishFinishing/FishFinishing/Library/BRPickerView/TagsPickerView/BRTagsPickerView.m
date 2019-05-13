//
//  BRTagsPickerView.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "BRTagsPickerView.h"
#import "FMTagsView.h"

@interface BRTagsPickerView ()<FMTagsViewDelegate> {
    BOOL isDataSourceValid; // 数据源是否合法
}
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
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

@implementation BRTagsPickerView

+ (void)showTagsPickerWithTitle:(NSString *)title
                              dataSource:(NSArray *)dataSource
                         defaultSelValue:(id)defaultSelValue
                             resultBlock:(BRStringResultBlock)resultBlock
                             cancelBlock:(BRStringCancelBlock)cancelBlock maximumNumberBlock:(nonnull DidBeyondMaximumNumberBlock)maxNumberBlock{
    [self showStringPickerWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil maximumNumberBlock:maxNumberBlock];
}

#pragma mark - 3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRStringCancelBlock)cancelBlock maximumNumberBlock:(nonnull DidBeyondMaximumNumberBlock)maxNumberBlock {
    BRTagsPickerView *strPickerView = [[BRTagsPickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock maximumNumberBlock:maxNumberBlock];
    NSAssert(strPickerView->isDataSourceValid, @"数据源不合法！请检查字符串选择器数据源的格式");
    if (strPickerView->isDataSourceValid) {
        [strPickerView showWithAnimation:YES];
    }
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(id)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(BRStringResultBlock)resultBlock
                  cancelBlock:(BRStringCancelBlock)cancelBlock maximumNumberBlock:(nonnull DidBeyondMaximumNumberBlock)maxNumberBlock {
    if (self = [super init]) {
        self.title = title;
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        self.maxNumberBlock = maxNumberBlock;
        isDataSourceValid = YES;
        self.selectRow = 0;
        [self configDataSource:dataSource defaultSelValue:defaultSelValue];
        if (isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

#pragma mark - 设置数据源
- (void)configDataSource:(id)dataSource defaultSelValue:(id)defaultSelValue {
    // 1.先判断传入的数据源是否合法
    if (!dataSource) {
        isDataSourceValid = NO;
    }
    // 2. 给数据源赋值
    self.dataArray = dataSource;
    // 4. 给选择器设置默认值
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加标签视图
    [self.alertView addSubview:self.tagView];
    self.tagView.tagsArray = self.dataArray;

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

- (void)tagsViewDidBeyondMaximumNumberOfSelection:(FMTagsView *)tagsView {
    !self.maxNumberBlock ?: self.maxNumberBlock();
}

#pragma mark - 字符串选择器
- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, kTopViewHeight + 5, self.alertView.frame.size.width, kPickerHeight);
        tagView.contentInsets = UIEdgeInsetsMake(13, 13, 13, 13);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8, 0.5, 8);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 5;
        tagView.tagBorderColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0x0096e6];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBackgroundColor = [UIColor colorWithHex:0x0096e6];
        tagView.interitemSpacing = 15;
        tagView.tagFont = KNBFont(14);
        tagView.tagTextColor = [UIColor colorWithHex:0x333333];
        tagView.allowsSelection = YES;
        tagView.allowsMultipleSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 30;
        tagView.mininumTagWidth = 75;
        tagView.maximumNumberOfSelection = 3;
        tagView.delegate = self;
        _tagView = tagView;
    }
    return _tagView;
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
        _resultBlock(self.tagView.selecedTags);
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
        [self.tagView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.tagView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

@end
