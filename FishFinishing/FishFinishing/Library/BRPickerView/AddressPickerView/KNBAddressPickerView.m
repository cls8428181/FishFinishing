//
//  KNBAddressPickerView.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBAddressPickerView.h"

@interface KNBAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL _isDataSourceValid;    // 数据源是否合法
    NSInteger _provinceIndex;   // 记录省选中的位置
    NSInteger _cityIndex;       // 记录市选中的位置
    NSInteger _areaIndex;       // 记录区选中的位置
    
    NSArray * _defaultSelectedArr;
}
// 地址选择器
@property (nonatomic, strong) UIPickerView *pickerView;
// 保存传入的数据源
@property (nonatomic, strong) NSArray *dataSource;
// 省模型数组
@property(nonatomic, strong) NSArray *provinceModelArr;
// 市模型数组
@property(nonatomic, strong) NSArray *cityModelArr;
// 区模型数组
@property(nonatomic, strong) NSArray *areaModelArr;
// 显示类型
@property (nonatomic, assign) KNBAddressPickerMode showType;
// 选中的省
@property(nonatomic, strong) KNBCityModel *selectProvinceModel;
// 选中的市
@property(nonatomic, strong) KNBCityModel *selectCityModel;
// 选中的区
@property(nonatomic, strong) KNBCityModel *selectAreaModel;

// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 主题色
@property (nonatomic, strong) UIColor *themeColor;
// 选中后的回调
@property (nonatomic, copy) KNBAddressResultBlock resultBlock;
// 取消选择的回调
@property (nonatomic, copy) KNBAddressCancelBlock cancelBlock;

@end

@implementation KNBAddressPickerView

#pragma mark - 1.显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                 resultBlock:(KNBAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:KNBAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 2.显示地址选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                  themeColor:(UIColor *)themeColor
                                 resultBlock:(KNBAddressResultBlock)resultBlock {
    [self showAddressPickerWithShowType:KNBAddressPickerModeArea dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示地址选择器（支持 设置选择器类型、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(KNBAddressPickerMode)showType
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(KNBAddressResultBlock)resultBlock
                          cancelBlock:(KNBAddressCancelBlock)cancelBlock {
    [self showAddressPickerWithShowType:showType dataSource:nil defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
}

#pragma mark - 4.显示地址选择器（支持 设置选择器类型、传入地区数据源、设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showAddressPickerWithShowType:(KNBAddressPickerMode)showType
                           dataSource:(NSArray *)dataSource
                      defaultSelected:(NSArray *)defaultSelectedArr
                         isAutoSelect:(BOOL)isAutoSelect
                           themeColor:(UIColor *)themeColor
                          resultBlock:(KNBAddressResultBlock)resultBlock
                          cancelBlock:(KNBAddressCancelBlock)cancelBlock {
    KNBAddressPickerView *addressPickerView = [[KNBAddressPickerView alloc] initWithShowType:showType dataSource:dataSource defaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    NSAssert(addressPickerView->_isDataSourceValid, @"数据源不合法！参数异常，请检查地址选择器的数据源是否有误");
    if (addressPickerView->_isDataSourceValid) {
        [addressPickerView showWithAnimation:YES];
    }
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithShowType:(KNBAddressPickerMode)showType
                      dataSource:(NSArray *)dataSource
                 defaultSelected:(NSArray *)defaultSelectedArr
                    isAutoSelect:(BOOL)isAutoSelect
                      themeColor:(UIColor *)themeColor
                     resultBlock:(KNBAddressResultBlock)resultBlock
                     cancelBlock:(KNBAddressCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.showType = showType;
        self.dataSource = dataSource;
        _defaultSelectedArr = defaultSelectedArr;
        _isDataSourceValid = YES;
        
        self.isAutoSelect = isAutoSelect;
        self.themeColor = themeColor;
        self.resultBlock = resultBlock;
        self.cancelBlock = cancelBlock;
        
        [self loadData];
        if (_isDataSourceValid) {
            [self initUI];
        }
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    // 如果外部没有传入地区数据源，就使用本地的数据源
    if (!self.dataSource || self.dataSource.count == 0) {
        /*
         先拿到最外面的 bundle。
         对 framework 链接方式来说就是 framework 的 bundle 根目录，
         对静态库链接方式来说就是 target client 的 main bundle，
         然后再去找下面名为 KNBPickerView 的 bundle 对象。
         */
        
        NSString *filePath =[[NSBundle mainBundle] pathForResource:@"KNBCity" ofType:@"plist"];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
        if (!dataSource || dataSource.count == 0) {
            _isDataSourceValid = NO;
            return;
        }
        self.dataSource = dataSource;
    }
    
    // 1.解析数据源
    [self parseDataSource];
    
    // 2.设置默认值
    [self setupDefaultValue];
    
    // 3.设置默认滚动
    [self scrollToRow:_provinceIndex secondRow:_cityIndex thirdRow:_areaIndex];
}

#pragma mark - 解析数据源
- (void)parseDataSource {
    NSArray *modelArray = [KNBCityModel changeResponseJSONObject:self.dataSource];
    self.provinceModelArr = [modelArray copy];
}

#pragma mark - 设置默认值
- (void)setupDefaultValue {
    __block NSString *selectProvinceName = nil;
    __block NSString *selectCityName = nil;
    __block NSString *selectAreaName = nil;
    // 1. 获取默认选中的省市区的名称
    if (_defaultSelectedArr) {
        if (_defaultSelectedArr.count > 0 && [_defaultSelectedArr[0] isKindOfClass:[NSString class]]) {
            selectProvinceName = _defaultSelectedArr[0];
        }
        if (_defaultSelectedArr.count > 1 && [_defaultSelectedArr[1] isKindOfClass:[NSString class]]) {
            selectCityName = _defaultSelectedArr[1];
        }
        if (_defaultSelectedArr.count > 2 && [_defaultSelectedArr[2] isKindOfClass:[NSString class]]) {
            selectAreaName = _defaultSelectedArr[2];
        }
    }
    
    // 2. 根据名称找到默认选中的省市区索引
    __weak typeof(self) weakSelf = self;
    [self.provinceModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KNBCityModel *model = obj;
        if ([model.name isEqualToString:selectProvinceName]) {
            self->_provinceIndex = idx;
            weakSelf.selectProvinceModel = model;
            *stop = YES;
        } else {
            if (idx == weakSelf.provinceModelArr.count - 1) {
                self->_provinceIndex = 0;
                weakSelf.selectProvinceModel = [weakSelf.provinceModelArr firstObject];
            }
        }
    }];
    if (self.showType == KNBAddressPickerModeCity || self.showType == KNBAddressPickerModeArea) {
        self.cityModelArr = [self getCityModelArray:_provinceIndex];
        [self.cityModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KNBCityModel *model = obj;
            if ([model.name isEqualToString:selectCityName]) {
                self->_cityIndex = idx;
                weakSelf.selectCityModel = model;
                *stop = YES;
            } else {
                if (idx == weakSelf.cityModelArr.count - 1) {
                    self->_cityIndex = 0;
                    weakSelf.selectCityModel = [weakSelf.cityModelArr firstObject];
                }
            }
        }];
    }
    if (self.showType == KNBAddressPickerModeArea) {
        self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
        [self.areaModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KNBCityModel *model = obj;
            if ([model.name isEqualToString:selectAreaName]) {
                _areaIndex = idx;
                weakSelf.selectAreaModel = model;
                *stop = YES;
            } else {
                if (idx == weakSelf.cityModelArr.count - 1) {
                    _areaIndex = 0;
                    weakSelf.selectAreaModel = [weakSelf.areaModelArr firstObject];
                }
            }
        }];
    }
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)provinceIndex secondRow:(NSInteger)cityIndex thirdRow:(NSInteger)areaIndex {
    if (self.showType == KNBAddressPickerModeProvince) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    } else if (self.showType == KNBAddressPickerModeCity) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    } else if (self.showType == KNBAddressPickerModeArea) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
    }
}

// 根据 省索引 获取 城市模型数组
- (NSArray *)getCityModelArray:(NSInteger)provinceIndex {
    KNBCityModel *provinceModel = self.provinceModelArr[provinceIndex];
    // 返回城市模型数组
    return provinceModel.cityList;
}

// 根据 省索引和城市索引 获取 区域模型数组
- (NSArray *)getAreaModelArray:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex {
    KNBCityModel *provinceModel = self.provinceModelArr[provinceIndex];
    KNBCityModel *cityModel = provinceModel.cityList[cityIndex];
    // 返回地区模型数组
    return cityModel.areaList;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    if (self.showType == KNBAddressPickerModeProvince) {
        self.titleLabel.text = @"请选择省份";
    } else if (self.showType == KNBAddressPickerModeCity) {
        self.titleLabel.text = @"请选择城市";
    } else {
        self.titleLabel.text = @"请选择地区";
    }
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
    if (self.themeColor && [self.themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:self.themeColor];
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.showType) {
        case KNBAddressPickerModeProvince:
            return 1;
            break;
        case KNBAddressPickerModeCity:
            return 2;
            break;
        case KNBAddressPickerModeArea:
            return 3;
            break;
            
        default:
            break;
    }
}

// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        // 返回省个数
        return self.provinceModelArr.count;
    }
    if (component == 1) {
        // 返回市个数
        return self.cityModelArr.count;
    }
    if (component == 2) {
        // 返回区个数
        return self.areaModelArr.count;
    }
    return 0;
    
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    // 设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.alertView.frame.size.width) / 3, 35 * kScaleFit)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 * kScaleFit, 0, (self.alertView.frame.size.width) / 3 - 10 * kScaleFit, 35 * kScaleFit)];
    [bgView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:18.0f * kScaleFit];
    // 字体自适应属性
    label.adjustsFontSizeToFitWidth = YES;
    // 自适应最小字体缩放比例
    label.minimumScaleFactor = 0.5f;
    if (component == 0) {
        KNBCityModel *model = self.provinceModelArr[row];
        label.text = model.name;
    }else if (component == 1){
        KNBCityModel *model = self.cityModelArr[row];
        label.text = model.name;
    }else if (component == 2){
        KNBCityModel *model = self.areaModelArr[row];
        label.text = model.name;
    }
    return bgView;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 选择省
        // 保存选择的省份的索引
        _provinceIndex = row;
        switch (self.showType) {
            case KNBAddressPickerModeProvince:
            {
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
            }
                break;
            case KNBAddressPickerModeCity:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                self.selectCityModel = self.cityModelArr[0];
                self.selectAreaModel = nil;
            }
                break;
            case KNBAddressPickerModeArea:
            {
                self.cityModelArr = [self getCityModelArray:_provinceIndex];
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:0];
                [self.pickerView reloadComponent:1];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectProvinceModel = self.provinceModelArr[_provinceIndex];
                if (!isNullArray(self.cityModelArr)) {
                    self.selectCityModel = self.cityModelArr[0];
                } else {
                    self.selectCityModel = nil;
                }
                if (!isNullArray(self.areaModelArr)) {
                    self.selectAreaModel = self.areaModelArr[0];
                } else {
                    self.selectAreaModel = nil;
                }
            }
                break;
            default:
                break;
        }
    }
    if (component == 1) { // 选择市
        // 保存选择的城市的索引
        _cityIndex = row;
        switch (self.showType) {
            case KNBAddressPickerModeCity:
            {
                self.selectCityModel = self.cityModelArr[_cityIndex];
                self.selectAreaModel = nil;
            }
                break;
            case KNBAddressPickerModeArea:
            {
                self.areaModelArr = [self getAreaModelArray:_provinceIndex cityIndex:_cityIndex];
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                self.selectCityModel = self.cityModelArr[_cityIndex];
                self.selectAreaModel = self.areaModelArr[0];
            }
                break;
            default:
                break;
        }
    }
    if (component == 2) { // 选择区
        // 保存选择的地区的索引
        _areaIndex = row;
        if (self.showType == KNBAddressPickerModeArea) {
            self.selectAreaModel = self.areaModelArr[_areaIndex];
        }
    }
    
    // 自动获取数据，滚动完就执行回调
    if (self.isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
        }
    }
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
    // 点击确定按钮后，执行回调
    if(self.resultBlock) {
        self.resultBlock(self.selectProvinceModel, self.selectCityModel, self.selectAreaModel);
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
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
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

- (NSArray *)provinceModelArr {
    if (!_provinceModelArr) {
        _provinceModelArr = [NSArray array];
    }
    return _provinceModelArr;
}

- (NSArray *)cityModelArr {
    if (!_cityModelArr) {
        _cityModelArr = [NSArray array];
    }
    return _cityModelArr;
}

- (NSArray *)areaModelArr {
    if (!_areaModelArr) {
        _areaModelArr = [NSArray array];
    }
    return _areaModelArr;
}

- (KNBCityModel *)selectProvinceModel {
    if (!_selectProvinceModel) {
        _selectProvinceModel = [[KNBCityModel alloc]init];
    }
    return _selectProvinceModel;
}

- (KNBCityModel *)selectCityModel {
    if (!_selectCityModel) {
        _selectCityModel = [[KNBCityModel alloc]init];
        _selectCityModel.code = @"";
        _selectCityModel.name = @"";
    }
    return _selectCityModel;
}

- (KNBCityModel *)selectAreaModel {
    if (!_selectAreaModel) {
        _selectAreaModel = [[KNBCityModel alloc]init];
        _selectAreaModel.code = @"";
        _selectAreaModel.name = @"";
    }
    return _selectAreaModel;
}

@end
