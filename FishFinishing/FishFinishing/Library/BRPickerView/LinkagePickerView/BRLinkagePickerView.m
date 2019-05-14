//
//  BRLinkagePickerView.m
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "BRLinkagePickerView.h"
#import "KNBRecruitmentTypeModel.h"

@interface BRLinkagePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL isDataSourceValid; // 数据源是否合法
}
// 字符串选择器
@property (nonatomic, strong) UIPickerView *pickerView;
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

@implementation BRLinkagePickerView

+ (void)showLinkageStringPickerWithTitle:(NSString *)title
                              dataSource:(NSArray<KNBRecruitmentTypeModel *> *)dataSource
                         defaultSelValue:(id)defaultSelValue
                             resultBlock:(BRStringResultBlock)resultBlock
                             cancelBlock:(BRStringCancelBlock)cancelBlock {
        [self showStringPickerWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(id)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                       themeColor:(UIColor *)themeColor
                      resultBlock:(BRStringResultBlock)resultBlock
                      cancelBlock:(BRStringCancelBlock)cancelBlock {
    BRLinkagePickerView *strPickerView = [[BRLinkagePickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
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
                  cancelBlock:(BRStringCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.title = title;
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
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
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if ([dataSource isKindOfClass:[NSArray class]]) {
        NSArray *modelArray = (NSArray *)dataSource;
        self.dataArray = modelArray;
        for (int i = 0; i < modelArray.count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            KNBRecruitmentTypeModel *model = modelArray[i];
            for (int j = 0; j < model.childList.count; j++) {
                KNBRecruitmentTypeModel *subModel = model.childList[j];
                [subArray addObject:subModel.catName];
            }
            [dataDic setObject:subArray forKey:model.catName];
        }
    } else {
        dataDic = [NSMutableDictionary dictionaryWithDictionary:dataSource];
    }
    // 2. 给数据源赋值}
    
    // 4. 给选择器设置默认值
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
//        NSString *selValue = nil;
//        if (defaultSelValue && [defaultSelValue isKindOfClass:[NSArray class]] && [defaultSelValue count] > 0 && i < [defaultSelValue count] && [self.dataSourceArr[i] containsObject:defaultSelValue[i]]) {
//            [tempArr addObject:defaultSelValue[i]];
//            selValue = defaultSelValue[i];
//        } else {
//            [tempArr addObject:[self.dataSourceArr[i] firstObject]];
//            selValue = [self.dataSourceArr[i] firstObject];
//        }
//        NSInteger row = [self.dataSourceArr[i] indexOfObject:selValue];
//        // 默认滚动的行
//        [self.pickerView selectRow:row inComponent:i animated:NO];
//    }
//    self.selectValueArr = [tempArr copy];
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.pickerView];
//    [self.alertView addSubview:self.leftPickerView];
//    [self.alertView addSubview:self.rightPickerView];
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
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;    }
    return _pickerView;
}

- (NSMutableArray *)selectValueArr {
    if (!_selectValueArr) {
        _selectValueArr = [NSMutableArray array];
    }
    return _selectValueArr;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArray.count;
    } else {
        if (!isNullArray(self.dataArray)) {
            KNBRecruitmentTypeModel *model = self.dataArray[self.selectRow];
            return model.childList.count;
        } else {
            return 1;
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectRow = row;
        [self.selectValueArr removeAllObjects];
        KNBRecruitmentTypeModel *model = self.dataArray[self.selectRow];
        [self.selectValueArr insertObject:model atIndex:0];
        [self.selectValueArr insertObject:model.childList.firstObject atIndex:1];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    } else {
        KNBRecruitmentTypeModel *model = self.dataArray[self.selectRow];
        if (self.selectValueArr.count == 0) {
            [self.selectValueArr insertObject:model atIndex:0];
        }
        if (self.selectValueArr.count > 1) {
            [self.selectValueArr removeLastObject];
        }
        [self.selectValueArr insertObject:model.childList[row] atIndex:1];
    }
    
    // 设置是否自动回调
//    if (self.isAutoSelect) {
//        if(self.resultBlock) {
//            self.resultBlock([self.selectValueArr copy]);
//        }
//    }
}

// 自定义 pickerView 的 label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    //设置分割线的颜色
    //    for (UIView *view in pickerView.subviews) {
    //        view.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    //    }
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width / 3, 35.0f * kScaleFit)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (component == 0) {
        KNBRecruitmentTypeModel *model = self.dataArray[row];
        label.text = model.catName;
    } else {
        if (!isNullArray(self.dataArray)) {
            KNBRecruitmentTypeModel *model = self.dataArray[self.selectRow];
            KNBRecruitmentTypeModel *subModel = model.childList[row];
            label.text = subModel.catName;
        } else {
            label.text = @"";
        }
    }
    return label;
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
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
        if (isNullArray(self.selectValueArr)) {
            KNBRecruitmentTypeModel *model = self.dataArray[0];
            [self.selectValueArr insertObject:model atIndex:0];
            [self.selectValueArr insertObject:model.childList.firstObject atIndex:1];
        }
        _resultBlock(self.selectValueArr);
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
//        [self.leftPickerView removeFromSuperview];
//        [self.rightPickerView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
//        self.leftPickerView = nil;
//        self.rightPickerView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

@end
